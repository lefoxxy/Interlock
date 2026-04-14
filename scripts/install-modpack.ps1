param()

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$root = Split-Path -Parent $PSScriptRoot
$modsDir = Join-Path $root "mods"
$lockPath = Join-Path $root "meta\installed-mods.json"

if (-not (Test-Path $lockPath)) {
  throw "installed-mods.json not found."
}

New-Item -ItemType Directory -Force -Path $modsDir | Out-Null

$lock = Get-Content $lockPath -Raw | ConvertFrom-Json

function Get-ModrinthDownloadUrl {
  param(
    [Parameter(Mandatory = $true)][string]$VersionUrl,
    [Parameter(Mandatory = $true)][string]$ExpectedFileName,
    [string]$ProjectSlug,
    [string]$ExpectedVersion
  )

  if ($VersionUrl -notmatch '/version/([^/]+)$') {
    if (-not $ProjectSlug) {
      throw "Could not parse Modrinth version id from $VersionUrl"
    }

    $projectApiUrl = "https://api.modrinth.com/v2/project/$ProjectSlug/version"
    $response = Invoke-RestMethod -Uri $projectApiUrl -Headers @{ "User-Agent" = "Interlock Modpack Bootstrap" }
    $matchedVersion = $response | Where-Object {
      $_.version_number -eq $ExpectedVersion -or
      ($_.files | Where-Object { $_.filename -eq $ExpectedFileName })
    } | Select-Object -First 1

    if (-not $matchedVersion) {
      throw "Could not resolve Modrinth version for $ProjectSlug $ExpectedVersion"
    }

    $primary = $matchedVersion.files | Where-Object { $_.primary } | Select-Object -First 1
    if (-not $primary) {
      $primary = $matchedVersion.files | Where-Object { $_.filename -eq $ExpectedFileName } | Select-Object -First 1
    }
    if (-not $primary) {
      $primary = $matchedVersion.files | Select-Object -First 1
    }
    if (-not $primary) {
      throw "No downloadable files returned for $ProjectSlug $ExpectedVersion"
    }

    return $primary.url
  }

  $versionId = $Matches[1]
  $apiUrl = "https://api.modrinth.com/v2/version/$versionId"
  $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "Interlock Modpack Bootstrap" }
  $primary = $response.files | Where-Object { $_.primary } | Select-Object -First 1

  if (-not $primary) {
    $primary = $response.files | Where-Object { $_.filename -eq $ExpectedFileName } | Select-Object -First 1
  }

  if (-not $primary) {
    $primary = $response.files | Select-Object -First 1
  }

  if (-not $primary) {
    throw "No downloadable files returned for $VersionUrl"
  }

  return $primary.url
}

function Get-ModrinthProjectSlug {
  param(
    [Parameter(Mandatory = $true)][string]$ProjectUrl,
    [string]$FallbackSlug
  )

  if ($ProjectUrl -match 'modrinth\.com/mod/([^/]+)') {
    return $Matches[1]
  }

  return $FallbackSlug
}

function Get-MavenDownloadUrl {
  param(
    [Parameter(Mandatory = $true)][string]$BaseUrl,
    [Parameter(Mandatory = $true)][string]$Version,
    [Parameter(Mandatory = $true)][string]$FileName
  )

  $normalized = $BaseUrl.TrimEnd('/')
  return "$normalized/$Version/$FileName"
}

$downloaded = @()

foreach ($mod in $lock.mods) {
  $fileName = [io.path]::GetFileName($mod.file)
  $destination = Join-Path $modsDir $fileName
  $projectSlug = Get-ModrinthProjectSlug -ProjectUrl $mod.url -FallbackSlug $mod.slug

  if (Test-Path $destination) {
    $downloaded += "SKIP`t$fileName"
    continue
  }

  switch ($mod.source) {
    "modrinth" {
      $downloadUrl = Get-ModrinthDownloadUrl -VersionUrl $mod.url -ExpectedFileName $fileName -ProjectSlug $projectSlug -ExpectedVersion $mod.version
    }
    "maven" {
      if ($mod.url -like "https://modrinth.com/mod/*") {
        $downloadUrl = Get-ModrinthDownloadUrl -VersionUrl $mod.url -ExpectedFileName $fileName -ProjectSlug $projectSlug -ExpectedVersion $mod.version
      } else {
        $downloadUrl = Get-MavenDownloadUrl -BaseUrl $mod.url -Version $mod.version -FileName $fileName
      }
    }
    default {
      throw "Unsupported mod source '$($mod.source)' for $($mod.name)"
    }
  }

  try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destination -Headers @{ "User-Agent" = "Interlock Modpack Bootstrap" }
    $downloaded += "GET`t$fileName"
  } catch {
    throw "Failed downloading $fileName from $downloadUrl :: $($_.Exception.Message)"
  }
}

$downloaded
