param(
  [string]$MinecraftVersion = "1.21.1",
  [string]$NeoForgeVersion = "21.1.226"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$runtimeDir = Join-Path $root ".runtime"
$serverDir = Join-Path $runtimeDir "server"
$serverModsDir = Join-Path $serverDir "mods"
$modsDir = Join-Path $root "mods"
$lockPath = Join-Path $root "meta\installed-mods.json"
$installerJar = Join-Path $runtimeDir "neoforge-$NeoForgeVersion-installer.jar"

New-Item -ItemType Directory -Force -Path $runtimeDir | Out-Null

if (-not (Test-Path $installerJar)) {
  $installerUri = "https://maven.neoforged.net/releases/net/neoforged/neoforge/$NeoForgeVersion/neoforge-$NeoForgeVersion-installer.jar"
  Invoke-WebRequest -Uri $installerUri -OutFile $installerJar -Headers @{ "User-Agent" = "Interlock Modpack Bootstrap" }
}

if (-not (Test-Path $lockPath)) {
  throw "installed-mods.json not found. Run install-modpack.ps1 first."
}

if (-not (Test-Path (Join-Path $serverDir "run.bat"))) {
  & java -jar $installerJar --install-server $serverDir | Out-Host
}

New-Item -ItemType Directory -Force -Path $serverModsDir | Out-Null
Get-ChildItem -Path $serverModsDir -File | Remove-Item -Force

$serverKubeJsDir = Join-Path $serverDir "kubejs"
if (Test-Path $serverKubeJsDir) {
  Remove-Item $serverKubeJsDir -Recurse -Force
}
Copy-Item -Path (Join-Path $root "kubejs") -Destination $serverKubeJsDir -Recurse -Force

$lock = Get-Content $lockPath | ConvertFrom-Json

foreach ($mod in $lock.mods) {
  if ($mod.server_side -eq "unsupported") {
    continue
  }

  Copy-Item -Path (Join-Path $root $mod.file) -Destination (Join-Path $serverModsDir ([io.path]::GetFileName($mod.file))) -Force
}

Set-Content -Path (Join-Path $serverDir "eula.txt") -Value "eula=true"

$logPath = Join-Path $serverDir "validation.log"
if (Test-Path $logPath) {
  Remove-Item $logPath -Force
}

$existingJavaIds = @(Get-Process java -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id)
$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "run.bat nogui > validation.log 2>&1" -WorkingDirectory $serverDir -PassThru

$deadline = (Get-Date).AddMinutes(4)
$success = $false

while ((Get-Date) -lt $deadline) {
  Start-Sleep -Seconds 5

  if (Test-Path $logPath) {
    $content = Get-Content $logPath -Raw

    if ($content -match 'Done \(' -or $content -match 'For help, type "help"') {
      $success = $true
      break
    }

    if ($content -match 'FATAL' -or $content -match 'Mod loading has failed' -or $content -match 'Missing or unsupported mandatory dependencies') {
      break
    }
  }

}

$newJavaProcesses = @(Get-Process java -ErrorAction SilentlyContinue | Where-Object { $existingJavaIds -notcontains $_.Id })
foreach ($javaProcess in $newJavaProcesses) {
  Stop-Process -Id $javaProcess.Id -Force -ErrorAction SilentlyContinue
}

if (-not $success -and (Test-Path $logPath)) {
  $content = Get-Content $logPath -Raw
  if ($content -match 'Done \(' -or $content -match 'For help, type "help"') {
    $success = $true
  }
}

if (-not $success) {
  throw "Server validation did not reach a successful startup state. Check .runtime/server/validation.log."
}

Copy-Item -Path (Join-Path $serverDir "config\\*") -Destination (Join-Path $root "config") -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path (Join-Path $serverDir "defaultconfigs\\*") -Destination (Join-Path $root "defaultconfigs") -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Server validation completed successfully"
