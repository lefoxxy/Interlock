$ErrorActionPreference = 'Stop'

function Get-QuestId {
    param([string]$Seed)

    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Seed)
        return ([System.BitConverter]::ToString($sha1.ComputeHash($bytes)) -replace '-', '').Substring(0, 16)
    }
    finally {
        $sha1.Dispose()
    }
}

function Escape-Snbt {
    param([string]$Value)

    return $Value.Replace('\', '\\').Replace('"', '\"')
}

function ItemTask {
    param(
        [string]$Id,
        [string]$ItemId,
        [int]$Count = 1
    )

    return [ordered]@{
        kind = 'item'
        id = $Id
        item = $ItemId
        count = $Count
    }
}

function ObserveTask {
    param(
        [string]$Id,
        [string]$Observe
    )

    return [ordered]@{
        kind = 'observation'
        id = $Id
        observe = $Observe
    }
}

function CheckTask {
    param([string]$Id)

    return [ordered]@{
        kind = 'checkmark'
        id = $Id
    }
}

function RewardDef {
    param(
        [string]$Id,
        [string]$ItemId,
        [int]$Count = 1
    )

    return [ordered]@{
        id = $Id
        item = $ItemId
        count = $Count
    }
}

function QuestDef {
    param(
        [string]$Id,
        [string]$Title,
        [string]$Description,
        [string]$Icon,
        [double]$X,
        [double]$Y,
        [hashtable[]]$Tasks,
        [hashtable[]]$Rewards
    )

    return [ordered]@{
        id = $Id
        title = $Title
        description = $Description
        icon = $Icon
        x = $X
        y = $Y
        tasks = $Tasks
        rewards = $Rewards
    }
}

function Get-QuestShape {
    param(
        [int]$QuestIndex,
        [int]$QuestCount
    )

    if ($QuestIndex -eq 0) {
        return 'gear'
    }

    if ($QuestIndex -eq ($QuestCount - 1)) {
        return 'octagon'
    }

    switch ($QuestIndex % 3) {
        1 { return 'rsquare' }
        2 { return 'diamond' }
        default { return 'hexagon' }
    }
}

function Get-QuestSize {
    param(
        [int]$QuestIndex,
        [int]$QuestCount
    )

    if ($QuestIndex -eq 0 -or $QuestIndex -eq ($QuestCount - 1)) {
        return 2.25
    }

    return 1.75
}

function Get-QuestY {
    param([int]$QuestIndex)

    switch ($QuestIndex) {
        0 { return 0.0 }
        1 { return -1.5 }
        2 { return 1.5 }
        3 { return -1.5 }
        default { return 0.0 }
    }
}

function ChapterDef {
    param(
        [string]$Id,
        [string]$Filename,
        [string]$Title,
        [string]$Icon,
        [int]$OrderIndex,
        [object[]]$Quests
    )

    return [ordered]@{
        id = $Id
        filename = $Filename
        title = $Title
        icon = $Icon
        order_index = $OrderIndex
        quests = $Quests
    }
}

$chapters = @(
    (ChapterDef -Id (Get-QuestId 'chapter:awakening') -Filename 'awakening' -Title 'Awakening' -Icon 'sophisticatedbackpacks:backpack' -OrderIndex 0 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:awakening:1') -Title 'Pack Light, Build Heavy' -Description 'Nothing in this factory happens by accident. Every line, buffer, machine, and power feed exists because you put it there and made it work together. Interlock is about building systems that hold under pressure, grow with demand, and turn scattered tools into a real industrial base.\n\nYou will start with physical infrastructure: storage that makes sense, routed materials, early power, and machine lines you can actually read. From there, the factory grows through better engineering. Immersive Engineering lays the groundwork, Mekanism becomes the processing backbone, Industrial Foregoing expands automation once you have earned it, and AE2 arrives only when the rest of the factory is ready to be coordinated instead of replaced.\n\nProgress here comes from design, throughput, and control. If a system fails, you fix it. If a line stalls, you improve it. The goal is not to get lucky and stumble into progress. The goal is to build something that works because every part of it belongs.' -Icon 'sophisticatedbackpacks:backpack' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:awakening:1') -ItemId 'sophisticatedbackpacks:backpack')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:awakening:1') -ItemId 'minecraft:bread' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:awakening:2') -Title 'A Place for Parts' -Description 'Put down real storage instead of living out of a loose pile of chests.' -Icon 'sophisticatedstorage:barrel' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:awakening:2') -Observe 'sophisticatedstorage:barrel')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:awakening:2') -ItemId 'minecraft:chest' -Count 2)))
        (QuestDef -Id (Get-QuestId 'quest:awakening:3') -Title 'Stop Carrying Everything by Hand' -Description 'Run your first item route with Pipez and let the base move its own materials.' -Icon 'pipez:item_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:awakening:3') -ItemId 'pipez:item_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:awakening:3') -ItemId 'pipez:wrench')))
        (QuestDef -Id (Get-QuestId 'quest:awakening:4') -Title 'The First Manual' -Description 'Pick up the Engineer''s Manual and give the workshop a direction.' -Icon 'immersiveengineering:manual' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:awakening:4') -ItemId 'immersiveengineering:manual')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:awakening:4') -ItemId 'immersiveengineering:stick_treated' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:awakening:5') -Title 'Ready for Real Work' -Description 'Take stock of the base and make sure it actually feels ready for industry before you move on.' -Icon 'sophisticatedstorage:chest' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:awakening:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:awakening:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:tools_of_industry') -Filename 'tools_of_industry' -Title 'Tools of Industry' -Icon 'immersiveengineering:craftingtable' -OrderIndex 1 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:tools:1') -Title 'Set the Bench' -Description 'Build an engineering corner that can support the next wave of parts.' -Icon 'immersiveengineering:craftingtable' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:tools:1') -Observe 'immersiveengineering:craftingtable')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:tools:1') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:tools:2') -Title 'Parts on the Shelf' -Description 'Stock your first real engineering components instead of crafting each one at the last second.' -Icon 'immersiveengineering:component_iron' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:tools:2') -ItemId 'immersiveengineering:component_iron' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:tools:2') -ItemId 'minecraft:copper_ingot' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:tools:3') -Title 'Wire for the Workshop' -Description 'Get your first copper coil ready so future power and machine lines have something to stand on.' -Icon 'immersiveengineering:wirecoil_copper' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:tools:3') -ItemId 'immersiveengineering:wirecoil_copper')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:tools:3') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:tools:4') -Title 'Storage with Intent' -Description 'Upgrade the stockroom so machine parts and building materials stop fighting for the same slots.' -Icon 'sophisticatedstorage:upgrade_base' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:tools:4') -ItemId 'sophisticatedstorage:upgrade_base')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:tools:4') -ItemId 'sophisticatedbackpacks:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:tools:5') -Title 'Built Like a Workshop' -Description 'Make sure the room feels deliberate before you move into motion and power.' -Icon 'sophisticatedstorage:chest' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:tools:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:tools:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:harnessing_motion') -Filename 'harnessing_motion' -Title 'Harnessing Motion' -Icon 'immersiveengineering:waterwheel_segment' -OrderIndex 2 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:motion:1') -Title 'Raise the Frame' -Description 'Lay down the first moving parts of the workshop and give them some breathing room.' -Icon 'immersiveengineering:waterwheel_segment' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:motion:1') -ItemId 'immersiveengineering:waterwheel_segment' -Count 4)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:motion:1') -ItemId 'immersiveengineering:stick_treated' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:motion:2') -Title 'Make It Turn' -Description 'Put down your first IE dynamo and start giving motion a purpose.' -Icon 'immersiveengineering:dynamo' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:motion:2') -Observe 'immersiveengineering:dynamo')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:motion:2') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:motion:3') -Title 'Connect the Floor' -Description 'Run connectors through the machine area so the first moving line belongs to the workshop.' -Icon 'immersiveengineering:connector_lv' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:motion:3') -ItemId 'immersiveengineering:connector_lv' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:motion:3') -ItemId 'immersiveengineering:wirecoil_copper')))
        (QuestDef -Id (Get-QuestId 'quest:motion:4') -Title 'Storage on the Line' -Description 'Keep your motion setup fed by tying it back into the stockroom.' -Icon 'sophisticatedstorage:chest' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:motion:4') -Observe 'sophisticatedstorage:chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:motion:4') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:motion:5') -Title 'The Floor Comes Alive' -Description 'Step back and make sure this first moving section reads like a system, not a test rig.' -Icon 'immersiveengineering:dynamo' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:motion:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:motion:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:first_power') -Filename 'first_power' -Title 'First Power' -Icon 'immersiveengineering:capacitor_lv' -OrderIndex 3 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:power:1') -Title 'Make It Spin' -Description 'Bring the first real generator online and give the base its own heartbeat.' -Icon 'immersiveengineering:dynamo' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:power:1') -Observe 'immersiveengineering:dynamo')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:power:1') -ItemId 'minecraft:coal' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:power:2') -Title 'Run the First Line' -Description 'Wire the new power into the workshop so it actually reaches useful work.' -Icon 'immersiveengineering:connector_lv_relay' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:power:2') -ItemId 'immersiveengineering:connector_lv_relay' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:power:2') -ItemId 'immersiveengineering:wirecoil_copper')))
        (QuestDef -Id (Get-QuestId 'quest:power:3') -Title 'Give It a Buffer' -Description 'Place the first LV capacitor so the grid can handle more than one little spike at a time.' -Icon 'immersiveengineering:capacitor_lv' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:power:3') -Observe 'immersiveengineering:capacitor_lv')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:power:3') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:power:4') -Title 'Power on the Machine Row' -Description 'Tie your new grid into a real machine area instead of leaving it stranded in the power corner.' -Icon 'pipez:energy_pipe' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:power:4') -ItemId 'pipez:energy_pipe' -Count 4)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:power:4') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:power:5') -Title 'Your First Real Grid' -Description 'Make sure the workshop now feels powered on purpose instead of held together with temporary fixes.' -Icon 'immersiveengineering:capacitor_lv' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:power:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:power:5') -ItemId 'minecraft:redstone' -Count 6)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:ore_to_output') -Filename 'ore_to_output' -Title 'Ore to Output' -Icon 'immersiveengineering:crusher' -OrderIndex 4 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:ore:1') -Title 'The First Real Input' -Description 'Set aside a proper ore intake instead of stuffing raw materials wherever they fit.' -Icon 'sophisticatedstorage:chest' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ore:1') -Observe 'sophisticatedstorage:chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ore:1') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:ore:2') -Title 'Bring the Crusher Online' -Description 'Place the crusher and turn the workshop into a real processing floor.' -Icon 'immersiveengineering:crusher' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ore:2') -Observe 'immersiveengineering:crusher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ore:2') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ore:3') -Title 'Raw In, Crushed Out' -Description 'Route ore into the line and stop relying on hand-fed batches.' -Icon 'pipez:item_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ore:3') -ItemId 'pipez:item_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ore:3') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ore:4') -Title 'Finished Goods Have a Home' -Description 'Give processed materials their own storage so the line stays readable.' -Icon 'sophisticatedstorage:storage_output' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ore:4') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ore:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:ore:5') -Title 'Ore to Output' -Description 'Lock in a line that starts with raw material and ends with usable stock without constant babysitting.' -Icon 'immersiveengineering:crusher' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:ore:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ore:5') -ItemId 'minecraft:copper_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:the_engineers_mindset') -Filename 'the_engineers_mindset' -Title 'The Engineer''s Mindset' -Icon 'sophisticatedstorage:controller' -OrderIndex 5 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:mindset:1') -Title 'Give Each Shelf a Job' -Description 'Start organizing the workshop so storage follows function instead of convenience.' -Icon 'sophisticatedstorage:controller' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mindset:1') -Observe 'sophisticatedstorage:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mindset:1') -ItemId 'minecraft:chest' -Count 2)))
        (QuestDef -Id (Get-QuestId 'quest:mindset:2') -Title 'Inputs Belong Near the Line' -Description 'Add a dedicated storage input where materials actually enter production.' -Icon 'sophisticatedstorage:storage_input' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mindset:2') -Observe 'sophisticatedstorage:storage_input')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mindset:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:mindset:3') -Title 'Outputs Belong at the End' -Description 'Do the same for finished goods so the workshop finally has a readable flow.' -Icon 'sophisticatedstorage:storage_output' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mindset:3') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mindset:3') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:mindset:4') -Title 'Leave Room to Grow' -Description 'Add a stack upgrade and prove the workshop is being built for tomorrow too.' -Icon 'sophisticatedstorage:stack_upgrade_tier_1' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mindset:4') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mindset:4') -ItemId 'sophisticatedbackpacks:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:mindset:5') -Title 'Build Like You Mean It' -Description 'Do a last cleanup pass and make sure the workshop now has some intentional shape.' -Icon 'sophisticatedstorage:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:mindset:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mindset:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:wires_and_wheels') -Filename 'wires_and_wheels' -Title 'Wires and Wheels' -Icon 'immersiveengineering:connector_lv_relay' -OrderIndex 6 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:wires:1') -Title 'Run It Clean' -Description 'Add another stretch of power and machine infrastructure without turning the floor into a knot.' -Icon 'immersiveengineering:connector_lv' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:wires:1') -ItemId 'immersiveengineering:connector_lv' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:wires:1') -ItemId 'immersiveengineering:wirecoil_copper')))
        (QuestDef -Id (Get-QuestId 'quest:wires:2') -Title 'Backbone Relay' -Description 'Use relays to extend the floor without making the line unreadable.' -Icon 'immersiveengineering:connector_lv_relay' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:wires:2') -ItemId 'immersiveengineering:connector_lv_relay' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:wires:2') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:wires:3') -Title 'Feed the Machine Row' -Description 'Extend routed items out to the machine row so the whole floor feels connected.' -Icon 'pipez:item_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:wires:3') -ItemId 'pipez:item_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:wires:3') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:wires:4') -Title 'Catch the Outputs' -Description 'Upgrade output handling so the machine row stops dumping everything into the first open slot.' -Icon 'sophisticatedstorage:storage_output' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:wires:4') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:wires:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:wires:5') -Title 'Wires and Wheels' -Description 'Make sure the whole early machine row now reads as one industrial section.' -Icon 'immersiveengineering:dynamo' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:wires:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:wires:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:processing_lines') -Filename 'processing_lines' -Title 'Processing Lines' -Icon 'immersiveengineering:crusher' -OrderIndex 7 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:lines:1') -Title 'One Job, One Line' -Description 'Commit to a dedicated early processing line instead of scattering machines around the room.' -Icon 'immersiveengineering:crusher' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:lines:1') -Observe 'immersiveengineering:crusher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:lines:1') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:lines:2') -Title 'Feed the Front End' -Description 'Keep raw materials arriving automatically so the line can stay busy.' -Icon 'pipez:item_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:lines:2') -ItemId 'pipez:item_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:lines:2') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:lines:3') -Title 'Fluid Support' -Description 'Add the pump work needed to support a more complete line.' -Icon 'immersiveengineering:fluid_pump' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:lines:3') -Observe 'immersiveengineering:fluid_pump')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:lines:3') -ItemId 'pipez:fluid_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:lines:4') -Title 'Catch the Good Stuff' -Description 'Give the finished side enough storage and room that it no longer clogs the whole floor.' -Icon 'sophisticatedstorage:chest' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:lines:4') -Observe 'sophisticatedstorage:chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:lines:4') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:lines:5') -Title 'Processing Lines' -Description 'This line should now run like a system instead of a sequence of chores.' -Icon 'immersiveengineering:fluid_pump' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:lines:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:lines:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:fluid_handling') -Filename 'fluid_handling' -Title 'Fluid Handling' -Icon 'immersiveengineering:fluid_pipe' -OrderIndex 8 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:fluids:1') -Title 'The First Wet Line' -Description 'Put down a real fluid route and stop pretending buckets are good enough.' -Icon 'pipez:fluid_pipe' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:fluids:1') -ItemId 'pipez:fluid_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:fluids:1') -ItemId 'pipez:wrench')))
        (QuestDef -Id (Get-QuestId 'quest:fluids:2') -Title 'Pipe the Machine Room' -Description 'Use IE fluid pipework where the line needs to feel anchored to the floor.' -Icon 'immersiveengineering:fluid_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:fluids:2') -ItemId 'immersiveengineering:fluid_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:fluids:2') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:fluids:3') -Title 'Pump with Purpose' -Description 'Give the fluid side of the workshop an actual machine and not just a pipe run.' -Icon 'immersiveengineering:fluid_pump' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:fluids:3') -Observe 'immersiveengineering:fluid_pump')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:fluids:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:fluids:4') -Title 'Buffer the Wet Side' -Description 'Use better storage around the fluid section so the whole thing is easier to live with.' -Icon 'sophisticatedstorage:barrel' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:fluids:4') -Observe 'sophisticatedstorage:barrel')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:fluids:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:fluids:5') -Title 'Fluids Belong in the Factory Too' -Description 'Do a final pass and make sure the fluid section reads like part of the workshop instead of an awkward add-on.' -Icon 'immersiveengineering:fluid_pump' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:fluids:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:fluids:5') -ItemId 'minecraft:copper_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:logistics_foundations') -Filename 'logistics_foundations' -Title 'Logistics Foundations' -Icon 'pipez:universal_pipe' -OrderIndex 9 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:logistics:1') -Title 'Give the Base a Backbone' -Description 'Commit to a main Pipez route that actually organizes the workshop.' -Icon 'pipez:universal_pipe' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:logistics:1') -ItemId 'pipez:universal_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:logistics:1') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:logistics:2') -Title 'Separate the Stock' -Description 'Upgrade storage so raw inputs and finished goods stop tripping over each other.' -Icon 'sophisticatedstorage:controller' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:logistics:2') -Observe 'sophisticatedstorage:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:logistics:2') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:logistics:3') -Title 'Items Across the Floor' -Description 'Extend a useful route far enough that the base starts feeling like more than one room.' -Icon 'pipez:item_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:logistics:3') -ItemId 'pipez:item_pipe' -Count 16)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:logistics:3') -ItemId 'sophisticatedbackpacks:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:logistics:4') -Title 'Storage at the End of the Line' -Description 'Put a proper destination on the far side of the route.' -Icon 'sophisticatedstorage:gold_chest' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:logistics:4') -Observe 'sophisticatedstorage:gold_chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:logistics:4') -ItemId 'minecraft:iron_ingot' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:logistics:5') -Title 'Logistics Foundations' -Description 'Make sure the workshop can now move its own materials without you acting as the missing transport layer.' -Icon 'pipez:universal_pipe' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:logistics:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:logistics:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:scaling_production') -Filename 'scaling_production' -Title 'Scaling Production' -Icon 'immersiveengineering:component_steel' -OrderIndex 10 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:scaling:1') -Title 'The Line Is Too Small' -Description 'Admit your early floor has limits and start building something it can grow into.' -Icon 'immersiveengineering:component_steel' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:scaling:1') -ItemId 'immersiveengineering:component_steel' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:scaling:1') -ItemId 'minecraft:iron_ingot' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:scaling:2') -Title 'More Through the Backbone' -Description 'Push more traffic across the main route without the workshop falling apart.' -Icon 'pipez:universal_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:scaling:2') -ItemId 'pipez:universal_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:scaling:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:scaling:3') -Title 'Storage That Matches the Work' -Description 'Upgrade the stockroom again so volume stops spilling into random chests.' -Icon 'sophisticatedstorage:gold_chest' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:scaling:3') -Observe 'sophisticatedstorage:gold_chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:scaling:3') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:scaling:4') -Title 'Bigger Power Floor' -Description 'Add the heavier IE parts needed to support a larger factory section.' -Icon 'immersiveengineering:capacitor_mv' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:scaling:4') -Observe 'immersiveengineering:capacitor_mv')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:scaling:4') -ItemId 'minecraft:redstone' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:scaling:5') -Title 'Scaling Production' -Description 'Make sure the production floor now feels intentionally bigger instead of merely busier.' -Icon 'immersiveengineering:capacitor_mv' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:scaling:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:scaling:5') -ItemId 'minecraft:copper_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:system_stability') -Filename 'system_stability' -Title 'System Stability' -Icon 'immersiveengineering:light_engineering' -OrderIndex 11 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:stability:1') -Title 'No More Flickering Lines' -Description 'Tighten up one weak point in the workshop before it gets amplified by everything that comes next.' -Icon 'immersiveengineering:light_engineering' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:stability:1') -ItemId 'immersiveengineering:light_engineering')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:stability:1') -ItemId 'minecraft:iron_ingot' -Count 3)))
        (QuestDef -Id (Get-QuestId 'quest:stability:2') -Title 'Buffers Save Bad Days' -Description 'Use better storage to take the edge off a workshop that is finally running more than one job at once.' -Icon 'sophisticatedstorage:stack_upgrade_tier_1' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:stability:2') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:stability:2') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:stability:3') -Title 'Power That Doesn''t Flinch' -Description 'Add one more branch of energy transport and keep the whole floor calm under load.' -Icon 'pipez:energy_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:stability:3') -ItemId 'pipez:energy_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:stability:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:stability:4') -Title 'Clean the Crossings' -Description 'Use relays and routing cleanup so the machine floor stops fighting itself.' -Icon 'immersiveengineering:connector_lv_relay' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:stability:4') -ItemId 'immersiveengineering:connector_lv_relay' -Count 2)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:stability:4') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:stability:5') -Title 'System Stability' -Description 'Give the workshop one final check and make sure it is ready to carry a much more demanding core progression.' -Icon 'immersiveengineering:capacitor_mv' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:stability:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:stability:5') -ItemId 'minecraft:redstone' -Count 6)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:enter_mekanism') -Filename 'enter_mekanism' -Title 'Enter Mekanism' -Icon 'mekanism:metallurgic_infuser' -OrderIndex 12 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:mek:1') -Title 'A New Kind of Machine' -Description 'Place your first Metallurgic Infuser and let the base learn some precision.' -Icon 'mekanism:metallurgic_infuser' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mek:1') -Observe 'mekanism:metallurgic_infuser')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mek:1') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:mek:2') -Title 'Circuits, Not Just Steel' -Description 'Craft the first real control circuit and accept that the workshop has changed.' -Icon 'mekanism:basic_control_circuit' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mek:2') -ItemId 'mekanism:basic_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mek:2') -ItemId 'minecraft:redstone' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:mek:3') -Title 'Steel for the New Backbone' -Description 'Build the casing that ties Mekanism into the rest of the factory.' -Icon 'mekanism:steel_casing' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mek:3') -ItemId 'mekanism:steel_casing')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mek:3') -ItemId 'mekanism:alloy_infused' -Count 2)))
        (QuestDef -Id (Get-QuestId 'quest:mek:4') -Title 'A Better First Process' -Description 'Bring an Enrichment Chamber online and let it show why Mekanism is the new core.' -Icon 'mekanism:enrichment_chamber' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mek:4') -Observe 'mekanism:enrichment_chamber')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mek:4') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:mek:5') -Title 'Enter Mekanism' -Description 'Make sure the new machine row feels permanent, powered, and connected to the rest of the factory.' -Icon 'mekanism:enrichment_chamber' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:mek:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mek:5') -ItemId 'mekanism:ingot_osmium' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:refinement_chains') -Filename 'refinement_chains' -Title 'Refinement Chains' -Icon 'mekanism:crusher' -OrderIndex 13 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:refine:1') -Title 'Add the Next Stage' -Description 'Build a second serious Mekanism step so materials stop being done after one touch.' -Icon 'mekanism:crusher' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:refine:1') -Observe 'mekanism:crusher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:refine:1') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:refine:2') -Title 'Heat for the Line' -Description 'Add the energized smelter and make the chain feel like a real production run.' -Icon 'mekanism:energized_smelter' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:refine:2') -Observe 'mekanism:energized_smelter')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:refine:2') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:refine:3') -Title 'Link the Machines' -Description 'Feed the chain with enough routing that it starts to carry itself.' -Icon 'pipez:item_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:refine:3') -ItemId 'pipez:item_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:refine:3') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:refine:4') -Title 'Power for the Chain' -Description 'Put an Energy Tablet into the system and accept the factory''s appetite has grown.' -Icon 'mekanism:energy_tablet' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:refine:4') -ItemId 'mekanism:energy_tablet')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:refine:4') -ItemId 'minecraft:iron_ingot' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:refine:5') -Title 'Refinement Chains' -Description 'Take a last look at the line and make sure it now works like one thought instead of three separate machines.' -Icon 'mekanism:crusher' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:refine:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:refine:5') -ItemId 'mekanism:alloy_infused' -Count 2)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:chemical_processing') -Filename 'chemical_processing' -Title 'Chemical Processing' -Icon 'mekanism:chemical_injection_chamber' -OrderIndex 14 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:chem:1') -Title 'Now It Gets Complicated' -Description 'Place your first chemical machine and let the factory become a little more demanding.' -Icon 'mekanism:chemical_injection_chamber' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:chem:1') -Observe 'mekanism:chemical_injection_chamber')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:chem:1') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:chem:2') -Title 'More Control, More Cost' -Description 'Step up to an advanced control circuit so the chemistry line can keep going.' -Icon 'mekanism:advanced_control_circuit' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:chem:2') -ItemId 'mekanism:advanced_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:chem:2') -ItemId 'minecraft:redstone' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:chem:3') -Title 'Give the Line a Battery' -Description 'Add the first proper Mekanism cube to support machines that no longer sip power.' -Icon 'mekanism:basic_energy_cube' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:chem:3') -ItemId 'mekanism:basic_energy_cube')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:chem:3') -ItemId 'pipez:energy_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:chem:4') -Title 'Keep the Outputs Sorted' -Description 'Give the chemical side enough routed support and storage to stay sane.' -Icon 'sophisticatedstorage:storage_output' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:chem:4') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:chem:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:chem:5') -Title 'Chemical Processing' -Description 'Give the chemistry wing one final check and make sure it belongs to the same factory instead of feeling like a side project.' -Icon 'mekanism:chemical_injection_chamber' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:chem:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:chem:5') -ItemId 'mekanism:alloy_infused' -Count 2)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:energy_expansion') -Filename 'energy_expansion' -Title 'Energy Expansion' -Icon 'powah:energizing_orb' -OrderIndex 15 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:powah:1') -Title 'A New Power Tier' -Description 'Craft the first Powah casing and commit to a more serious grid.' -Icon 'powah:dielectric_casing' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:powah:1') -ItemId 'powah:dielectric_casing')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:powah:1') -ItemId 'powah:dielectric_paste' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:powah:2') -Title 'Stored Current' -Description 'Build your first Powah cell so the grid starts feeling planned instead of stretched thin.' -Icon 'powah:energy_cell_starter' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:powah:2') -Observe 'powah:energy_cell_starter')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:powah:2') -ItemId 'minecraft:redstone' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:powah:3') -Title 'Cable the New Grid' -Description 'Run the first Powah cable path into the factory proper.' -Icon 'powah:energy_cable_starter' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:powah:3') -ItemId 'powah:energy_cable_starter' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:powah:3') -ItemId 'powah:dielectric_paste' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:powah:4') -Title 'Bring the Orb Online' -Description 'Place the Energizing Orb and open the door to Powah''s real progression.' -Icon 'powah:energizing_orb' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:powah:4') -Observe 'powah:energizing_orb')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:powah:4') -ItemId 'powah:capacitor_basic')))
        (QuestDef -Id (Get-QuestId 'quest:powah:5') -Title 'Energy Expansion' -Description 'Do one final check and make sure Powah now feels like a true part of the base power story.' -Icon 'powah:energizing_orb' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:powah:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:powah:5') -ItemId 'powah:photoelectric_pane' -Count 2)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:precision_engineering') -Filename 'precision_engineering' -Title 'Precision Engineering' -Icon 'mekanism:advanced_control_circuit' -OrderIndex 16 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:precision:1') -Title 'The Cheap Parts Aren''t Enough' -Description 'Start replacing rougher pieces with parts you actually trust in the long term.' -Icon 'mekanism:advanced_control_circuit' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:precision:1') -ItemId 'mekanism:advanced_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:precision:1') -ItemId 'mekanism:alloy_infused' -Count 2)))
        (QuestDef -Id (Get-QuestId 'quest:precision:2') -Title 'Support the Better Machines' -Description 'Bring a better energy cube into the line so upgrades have somewhere to stand.' -Icon 'mekanism:basic_energy_cube' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:precision:2') -ItemId 'mekanism:basic_energy_cube')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:precision:2') -ItemId 'pipez:energy_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:precision:3') -Title 'Exact Inputs' -Description 'Tighten routing and storage around one important machine line.' -Icon 'sophisticatedstorage:storage_input' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:precision:3') -Observe 'sophisticatedstorage:storage_input')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:precision:3') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:precision:4') -Title 'Long-Term Hardware' -Description 'Craft the circuit tier that marks a workshop no longer built out of temporary compromises.' -Icon 'mekanism:elite_control_circuit' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:precision:4') -ItemId 'mekanism:elite_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:precision:4') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:precision:5') -Title 'Precision Engineering' -Description 'Take the pass that turns a merely working machine area into one you want to keep.' -Icon 'mekanism:elite_control_circuit' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:precision:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:precision:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:factory_design') -Filename 'factory_design' -Title 'Factory Design' -Icon 'sophisticatedstorage:controller' -OrderIndex 17 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:design:1') -Title 'Give Each Section a Job' -Description 'Use the storage controller to anchor a more intentional factory layout.' -Icon 'sophisticatedstorage:controller' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:design:1') -Observe 'sophisticatedstorage:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:design:1') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:design:2') -Title 'A Hall for the Lines' -Description 'Extend logistics through a broader slice of the factory instead of another cramped corner.' -Icon 'pipez:universal_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:design:2') -ItemId 'pipez:universal_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:design:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:design:3') -Title 'Power Belongs in the Plan Too' -Description 'Use better energy routing so power looks like it was part of the build from the start.' -Icon 'pipez:energy_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:design:3') -ItemId 'pipez:energy_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:design:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:design:4') -Title 'Storage Where It Matters' -Description 'Put storage on the floor where it actually supports the design instead of filling gaps.' -Icon 'sophisticatedstorage:storage_output' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:design:4') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:design:4') -ItemId 'sophisticatedbackpacks:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:design:5') -Title 'Factory Design' -Description 'Step back and make sure the floor now has recognizable zones instead of a single expanding workshop blob.' -Icon 'sophisticatedstorage:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:design:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:design:5') -ItemId 'minecraft:iron_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:automated_harvest') -Filename 'automated_harvest' -Title 'Automated Harvest' -Icon 'powah:energy_cell_basic' -OrderIndex 18 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:harvest:1') -Title 'Plan the Automation Wing' -Description 'Build the power and storage foundations for future automation without unlocking IF early.' -Icon 'powah:energy_cell_basic' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:harvest:1') -Observe 'powah:energy_cell_basic')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:harvest:1') -ItemId 'powah:dielectric_paste' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:harvest:2') -Title 'Route Future Inputs' -Description 'Run the item routes that future farming gear will need.' -Icon 'pipez:item_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:harvest:2') -ItemId 'pipez:item_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:harvest:2') -ItemId 'pipez:universal_pipe' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:harvest:3') -Title 'Route Future Fluids' -Description 'Do the same for fluid movement so the room is ready when the plastic chain comes online.' -Icon 'pipez:fluid_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:harvest:3') -ItemId 'pipez:fluid_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:harvest:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:harvest:4') -Title 'Stock the Support Room' -Description 'Put down the storage that will eventually receive harvest output.' -Icon 'sophisticatedstorage:gold_chest' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:harvest:4') -Observe 'sophisticatedstorage:gold_chest')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:harvest:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:harvest:5') -Title 'Harvest Wing Ready' -Description 'Do the layout pass now so Industrial Foregoing arrives into a clean space later.' -Icon 'powah:energy_cell_basic' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:harvest:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:harvest:5') -ItemId 'minecraft:iron_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:mob_industry') -Filename 'mob_industry' -Title 'Mob Industry' -Icon 'mekanism:advanced_control_circuit' -OrderIndex 19 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:mob:1') -Title 'A Room for the Ugly Work' -Description 'Reserve and power a space for future mob handling without using IF machines ahead of schedule.' -Icon 'mekanism:advanced_control_circuit' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mob:1') -ItemId 'mekanism:advanced_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mob:1') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:mob:2') -Title 'Drain and Route' -Description 'Build the fluid side of the room so it can eventually support the dirtier jobs.' -Icon 'pipez:fluid_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mob:2') -ItemId 'pipez:fluid_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mob:2') -ItemId 'pipez:energy_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:mob:3') -Title 'Leave Space for Intake' -Description 'Set up the routing and storage the room will need before the first real machine ever lands.' -Icon 'sophisticatedstorage:storage_input' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mob:3') -Observe 'sophisticatedstorage:storage_input')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mob:3') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:mob:4') -Title 'Leave Space for Output' -Description 'Do the same for drops and byproducts so the eventual line has somewhere to report.' -Icon 'sophisticatedstorage:storage_output' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mob:4') -Observe 'sophisticatedstorage:storage_output')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mob:4') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:mob:5') -Title 'Mob Wing Ready' -Description 'This room should now be prepared, contained, and waiting for the actual IF unlock.' -Icon 'mekanism:advanced_control_circuit' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:mob:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mob:5') -ItemId 'minecraft:iron_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:latex_and_plastic') -Filename 'latex_and_plastic' -Title 'Latex and Plastic' -Icon 'industrialforegoing:latex_processing_unit' -OrderIndex 20 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:plastic:1') -Title 'First Frame, Real Cost' -Description 'Craft the first gated IF frame and feel the price of finally opening the automation branch.' -Icon 'industrialforegoing:machine_frame_pity' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:plastic:1') -ItemId 'industrialforegoing:machine_frame_pity')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:plastic:1') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:plastic:2') -Title 'Tap the Trees' -Description 'Place the Fluid Extractor and start the latex side of the chain for real.' -Icon 'industrialforegoing:fluid_extractor' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:plastic:2') -Observe 'industrialforegoing:fluid_extractor')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:plastic:2') -ItemId 'pipez:fluid_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:plastic:3') -Title 'Cook the Mess' -Description 'Place the Latex Processing Unit and turn goo into something the factory can build with.' -Icon 'industrialforegoing:latex_processing_unit' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:plastic:3') -Observe 'industrialforegoing:latex_processing_unit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:plastic:3') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:plastic:4') -Title 'Plastic on the Shelf' -Description 'Actually stock a small reserve so IF stops feeling like a one-off novelty craft.' -Icon 'industrialforegoing:plastic' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:plastic:4') -ItemId 'industrialforegoing:plastic' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:plastic:4') -ItemId 'sophisticatedstorage:upgrade_base')))
        (QuestDef -Id (Get-QuestId 'quest:plastic:5') -Title 'Latex and Plastic' -Description 'This is the real IF unlock. Make sure the new material line is stable before you scale it.' -Icon 'industrialforegoing:plastic' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:plastic:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:plastic:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:industrial_scaling') -Filename 'industrial_scaling' -Title 'Industrial Scaling' -Icon 'industrialforegoing:machine_frame_simple' -OrderIndex 21 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:ifscale:1') -Title 'Build the Next Frame' -Description 'Step into the next IF tier now that the plastic chain can actually support it.' -Icon 'industrialforegoing:machine_frame_simple' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ifscale:1') -ItemId 'industrialforegoing:machine_frame_simple')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ifscale:1') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ifscale:2') -Title 'The First Worker' -Description 'Place the Plant Gatherer and let the automation wing start earning its floor space.' -Icon 'industrialforegoing:plant_gatherer' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ifscale:2') -Observe 'industrialforegoing:plant_gatherer')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ifscale:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:ifscale:3') -Title 'Plant It Once' -Description 'Pair the gatherer with a Plant Sower so the line can loop on purpose.' -Icon 'industrialforegoing:plant_sower' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ifscale:3') -Observe 'industrialforegoing:plant_sower')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ifscale:3') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ifscale:4') -Title 'Ready for Bigger Work' -Description 'Craft the advanced frame so the wing can grow without breaking its own rules.' -Icon 'industrialforegoing:machine_frame_advanced' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ifscale:4') -ItemId 'industrialforegoing:machine_frame_advanced')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ifscale:4') -ItemId 'mekanism:advanced_control_circuit')))
        (QuestDef -Id (Get-QuestId 'quest:ifscale:5') -Title 'Industrial Scaling' -Description 'Make sure IF now feels like a real wing of the factory instead of one expensive gimmick room.' -Icon 'industrialforegoing:machine_frame_advanced' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:ifscale:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ifscale:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:controlled_automation') -Filename 'controlled_automation' -Title 'Controlled Automation' -Icon 'industrialforegoing:mob_crusher' -OrderIndex 22 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:control:1') -Title 'Build the Heavy Frame' -Description 'Craft the top IF frame tier so automation can scale without losing its gates.' -Icon 'industrialforegoing:machine_frame_supreme' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:control:1') -ItemId 'industrialforegoing:machine_frame_supreme')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:control:1') -ItemId 'industrialforegoing:plastic' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:control:2') -Title 'The Animal Line' -Description 'Place the Animal Rancher and make sure it has a clear job in the factory.' -Icon 'industrialforegoing:animal_rancher' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:control:2') -Observe 'industrialforegoing:animal_rancher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:control:2') -ItemId 'pipez:fluid_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:control:3') -Title 'The Mob Line' -Description 'Place the Mob Crusher and give the dirty work room a real purpose.' -Icon 'industrialforegoing:mob_crusher' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:control:3') -Observe 'industrialforegoing:mob_crusher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:control:3') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:control:4') -Title 'Fluid on Command' -Description 'Place the Fluid Placer and put one more automation tool under control instead of leaving it loose.' -Icon 'industrialforegoing:fluid_placer' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:control:4') -Observe 'industrialforegoing:fluid_placer')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:control:4') -ItemId 'mekanism:elite_control_circuit')))
        (QuestDef -Id (Get-QuestId 'quest:control:5') -Title 'Controlled Automation' -Description 'Do the pass that makes the automation wing feel coordinated instead of merely full of machines.' -Icon 'industrialforegoing:mob_crusher' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:control:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:control:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:digital_storage') -Filename 'digital_storage' -Title 'Digital Storage' -Icon 'ae2:controller' -OrderIndex 23 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:ae2:1') -Title 'Earn the Controller' -Description 'Craft the gated controller and open AE2 the hard way.' -Icon 'ae2:controller' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ae2:1') -ItemId 'ae2:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ae2:1') -ItemId 'ae2:fluix_dust' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ae2:2') -Title 'First Drive, First Shelf' -Description 'Place the drive that turns AE2 from an idea into a room full of hardware.' -Icon 'ae2:drive' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:ae2:2') -Observe 'ae2:drive')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ae2:2') -ItemId 'ae2:quartz_glass' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ae2:3') -Title 'The First Cell' -Description 'Craft a 1k component and start building storage the way this pack expects you to earn it.' -Icon 'ae2:cell_component_1k' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ae2:3') -ItemId 'ae2:cell_component_1k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ae2:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:ae2:4') -Title 'A Cell Worth Using' -Description 'Craft the first item cell so AE2 starts doing real storage work instead of sitting pretty.' -Icon 'ae2:item_storage_cell_1k' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:ae2:4') -ItemId 'ae2:item_storage_cell_1k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ae2:4') -ItemId 'ae2:fluix_glass_cable' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:ae2:5') -Title 'Digital Storage' -Description 'Make sure the first AE2 room adds control without erasing the value of your physical logistics.' -Icon 'ae2:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:ae2:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:ae2:5') -ItemId 'minecraft:iron_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:network_architecture') -Filename 'network_architecture' -Title 'Network Architecture' -Icon 'ae2:fluix_glass_cable' -OrderIndex 24 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:net:1') -Title 'Run the First Real Cable' -Description 'Extend the AE2 network beyond the storage room and into the factory.' -Icon 'ae2:fluix_glass_cable' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:net:1') -ItemId 'ae2:fluix_glass_cable' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:net:1') -ItemId 'ae2:fluix_dust' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:net:2') -Title 'More Than One Shelf' -Description 'Craft a 4k component so AE2 can start growing with the rest of the base.' -Icon 'ae2:cell_component_4k' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:net:2') -ItemId 'ae2:cell_component_4k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:net:2') -ItemId 'ae2:quartz_glass' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:net:3') -Title 'A Bigger Cell' -Description 'Craft the 4k storage cell and give the network room to matter.' -Icon 'ae2:item_storage_cell_4k' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:net:3') -ItemId 'ae2:item_storage_cell_4k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:net:3') -ItemId 'minecraft:redstone' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:net:4') -Title 'Keep the Core Clean' -Description 'Build the cable and drive layout like you expect to live with it for a long time.' -Icon 'ae2:drive' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:net:4') -Observe 'ae2:drive')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:net:4') -ItemId 'ae2:fluix_glass_cable' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:net:5') -Title 'Network Architecture' -Description 'Make sure the network now reaches into the factory without trying to replace everything else.' -Icon 'ae2:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:net:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:net:5') -ItemId 'minecraft:iron_ingot' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:system_integration') -Filename 'system_integration' -Title 'System Integration' -Icon 'ae2:drive' -OrderIndex 25 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:integrate:1') -Title 'Let Storage Meet Production' -Description 'Tie AE2 into a real production wing instead of a quiet side room.' -Icon 'ae2:drive' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:integrate:1') -Observe 'ae2:drive')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:integrate:1') -ItemId 'ae2:fluix_glass_cable' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:integrate:2') -Title 'Pipes Where Pipes Belong' -Description 'Keep physical logistics in the jobs they still do best.' -Icon 'pipez:universal_pipe' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:integrate:2') -ItemId 'pipez:universal_pipe' -Count 8)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:integrate:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:integrate:3') -Title 'Mekanism Reports In' -Description 'Use a higher circuit tier to show the core machine backbone is now part of a bigger whole.' -Icon 'mekanism:advanced_control_circuit' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:integrate:3') -ItemId 'mekanism:advanced_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:integrate:3') -ItemId 'mekanism:alloy_infused' -Count 2)))
        (QuestDef -Id (Get-QuestId 'quest:integrate:4') -Title 'Automation Joins the Grid' -Description 'Use the simple IF frame as proof that automation now lives inside the same factory logic.' -Icon 'industrialforegoing:machine_frame_simple' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:integrate:4') -ItemId 'industrialforegoing:machine_frame_simple')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:integrate:4') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:integrate:5') -Title 'System Integration' -Description 'Take the pass that makes every major modded system feel like part of one factory instead of neighboring projects.' -Icon 'ae2:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:integrate:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:integrate:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:throughput_optimization') -Filename 'throughput_optimization' -Title 'Throughput Optimization' -Icon 'ae2:item_storage_cell_4k' -OrderIndex 26 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:throughput:1') -Title 'Find the Slow Step' -Description 'Upgrade a real bottleneck instead of adding random speed to random places.' -Icon 'ae2:item_storage_cell_4k' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:throughput:1') -ItemId 'ae2:item_storage_cell_4k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:throughput:1') -ItemId 'ae2:fluix_glass_cable' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:throughput:2') -Title 'Feed the Hungry Side' -Description 'Use stronger power support where higher demand actually lives.' -Icon 'mekanism:basic_energy_cube' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:throughput:2') -ItemId 'mekanism:basic_energy_cube')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:throughput:2') -ItemId 'pipez:energy_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:throughput:3') -Title 'Trim the Waste' -Description 'Clean up one more major line so it wastes less motion and less space.' -Icon 'pipez:universal_pipe' -X 8.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:throughput:3') -ItemId 'pipez:universal_pipe' -Count 12)) -Rewards @((RewardDef -Id (Get-QuestId 'reward:throughput:3') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
        (QuestDef -Id (Get-QuestId 'quest:throughput:4') -Title 'Tune the Automation Wing' -Description 'Use a working IF production block as proof that the optimized side of the factory can keep up too.' -Icon 'industrialforegoing:plant_gatherer' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:throughput:4') -Observe 'industrialforegoing:plant_gatherer')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:throughput:4') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:throughput:5') -Title 'Throughput Optimization' -Description 'Make sure the factory now feels smoother, quicker, and less wasteful than it did one chapter ago.' -Icon 'ae2:item_storage_cell_4k' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:throughput:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:throughput:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:mass_production') -Filename 'mass_production' -Title 'Mass Production' -Icon 'industrialforegoing:machine_frame_supreme' -OrderIndex 27 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:mass:1') -Title 'A Department, Not a Line' -Description 'Build at a scale where one section of the factory can carry meaningful stock on its own.' -Icon 'industrialforegoing:machine_frame_supreme' -X 0.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mass:1') -ItemId 'industrialforegoing:machine_frame_supreme')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mass:1') -ItemId 'industrialforegoing:plastic' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:mass:2') -Title 'Keep the Network Fed' -Description 'Give AE2 enough capacity that the storage side keeps up with the production side.' -Icon 'ae2:item_storage_cell_4k' -X 4.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mass:2') -ItemId 'ae2:item_storage_cell_4k')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mass:2') -ItemId 'ae2:fluix_glass_cable' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:mass:3') -Title 'Power That Stays On' -Description 'Use a better Powah cell to keep heavier wings calm under sustained load.' -Icon 'powah:energy_cell_basic' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:mass:3') -Observe 'powah:energy_cell_basic')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mass:3') -ItemId 'powah:dielectric_paste' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:mass:4') -Title 'Circuits for the Long Haul' -Description 'Use an elite circuit as proof this line is not a temporary build anymore.' -Icon 'mekanism:elite_control_circuit' -X 12.0 -Y 0.0 -Tasks @((ItemTask -Id (Get-QuestId 'task:mass:4') -ItemId 'mekanism:elite_control_circuit')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mass:4') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:mass:5') -Title 'Mass Production' -Description 'Do the last pass that turns this wing from a clever setup into something the whole factory depends on.' -Icon 'industrialforegoing:machine_frame_supreme' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:mass:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:mass:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:autonomous_systems') -Filename 'autonomous_systems' -Title 'Autonomous Systems' -Icon 'industrialforegoing:mob_duplicator' -OrderIndex 28 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:auto:1') -Title 'Pick a System to Free' -Description 'Choose one important process and let it start carrying itself.' -Icon 'industrialforegoing:animal_rancher' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:auto:1') -Observe 'industrialforegoing:animal_rancher')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:auto:1') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:auto:2') -Title 'No Manual Start Button' -Description 'Use a machine that keeps a tougher line moving even when you are doing something else.' -Icon 'industrialforegoing:mob_duplicator' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:auto:2') -Observe 'industrialforegoing:mob_duplicator')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:auto:2') -ItemId 'pipez:item_pipe' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:auto:3') -Title 'Storage That Follows Along' -Description 'Back the autonomous section with networked storage that can actually keep up.' -Icon 'ae2:controller' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:auto:3') -Observe 'ae2:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:auto:3') -ItemId 'ae2:fluix_glass_cable' -Count 6)))
        (QuestDef -Id (Get-QuestId 'quest:auto:4') -Title 'The Grid Supports It' -Description 'Make sure the automated section has real energy behind it instead of borrowed leftovers.' -Icon 'powah:energy_cell_basic' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:auto:4') -Observe 'powah:energy_cell_basic')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:auto:4') -ItemId 'powah:dielectric_paste' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:auto:5') -Title 'Autonomous Systems' -Description 'Take the pass that makes one big piece of the factory trustworthy even when you walk away from it.' -Icon 'industrialforegoing:mob_duplicator' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:auto:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:auto:5') -ItemId 'minecraft:redstone' -Count 4)))
    ))
    (ChapterDef -Id (Get-QuestId 'chapter:the_perfect_factory') -Filename 'the_perfect_factory' -Title 'The Perfect Factory' -Icon 'ae2:controller' -OrderIndex 29 -Quests @(
        (QuestDef -Id (Get-QuestId 'quest:perfect:1') -Title 'Early Bones Still Matter' -Description 'Make sure the old IE backbone still has a visible place in the finished build.' -Icon 'immersiveengineering:dynamo' -X 0.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:perfect:1') -Observe 'immersiveengineering:dynamo')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:perfect:1') -ItemId 'minecraft:iron_ingot' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:perfect:2') -Title 'Core Machines, Still Central' -Description 'Keep Mekanism at the heart of the factory instead of letting it disappear behind convenience.' -Icon 'mekanism:metallurgic_infuser' -X 4.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:perfect:2') -Observe 'mekanism:metallurgic_infuser')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:perfect:2') -ItemId 'mekanism:ingot_osmium' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:perfect:3') -Title 'Automation in Its Place' -Description 'Keep IF in the role it earned: powerful, useful, and still clearly mid-to-late support.' -Icon 'industrialforegoing:plant_gatherer' -X 8.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:perfect:3') -Observe 'industrialforegoing:plant_gatherer')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:perfect:3') -ItemId 'industrialforegoing:plastic' -Count 4)))
        (QuestDef -Id (Get-QuestId 'quest:perfect:4') -Title 'Control Without Replacement' -Description 'Keep AE2 present as the late control layer without erasing the physical factory beneath it.' -Icon 'ae2:controller' -X 12.0 -Y 0.0 -Tasks @((ObserveTask -Id (Get-QuestId 'task:perfect:4') -Observe 'ae2:controller')) -Rewards @((RewardDef -Id (Get-QuestId 'reward:perfect:4') -ItemId 'ae2:fluix_glass_cable' -Count 8)))
        (QuestDef -Id (Get-QuestId 'quest:perfect:5') -Title 'The Perfect Factory' -Description 'Finish a factory where every major system has a clear role, clean boundaries, and a reason to be there.' -Icon 'ae2:controller' -X 16.0 -Y 0.0 -Tasks @((CheckTask -Id (Get-QuestId 'task:perfect:5'))) -Rewards @((RewardDef -Id (Get-QuestId 'reward:perfect:5') -ItemId 'sophisticatedstorage:stack_upgrade_tier_1')))
    ))
)

function Format-Task {
    param([hashtable]$Task)

    switch ($Task.kind) {
        'item' {
            return @"
{ id: "$($Task.id)", item: { count: $($Task.count), id: "$($Task.item)" }, type: "item" }
"@
        }
        'observation' {
            return @"
{ id: "$($Task.id)", icon: "$($Task.observe)", observe_type: 0, timer: 0L, to_observe: "$($Task.observe)", type: "observation" }
"@
        }
        'checkmark' {
            return @"
{ id: "$($Task.id)", type: "checkmark" }
"@
        }
    }
}

function Format-Reward {
    param([hashtable]$Reward)

    return @"
{ count: 1, id: "$($Reward.id)", item: { count: $($Reward.count), id: "$($Reward.item)" }, type: "item" }
"@
}

$root = Join-Path $PSScriptRoot '..\config\ftbquests\quests'
$chaptersDir = Join-Path $root 'chapters'
New-Item -ItemType Directory -Force -Path $chaptersDir | Out-Null

$groupId = Get-QuestId 'group:interlock'

$data = @"
{
    default_autoclaim_rewards: "disabled"
    default_consume_items: false
    default_quest_disable_jei: false
    default_quest_shape: "square"
    default_reward_team: false
    detection_delay: 10
    disable_gui: false
    drop_loot_crates: false
    emergency_items_cooldown: 300
    grid_scale: 1.0d
    icon: "immersiveengineering:manual"
    lock_message: ""
    loot_crate_no_drop: { boss: 0, monster: 0, passive: 0 }
    pause_game: false
    progression_mode: "linear"
    title: "Interlock"
    version: 1
}
"@
Set-Content -Path (Join-Path $root 'data.snbt') -Value $data

$groupEntries = $chapters | ForEach-Object {
    "    { id: `"$groupId`", title: `"Interlock`" }"
}
$chapterGroups = "{`n chapter_groups: [`n$($groupEntries[0])`n ]`n}"
Set-Content -Path (Join-Path $root 'chapter_groups.snbt') -Value $chapterGroups

$previousQuestId = $null

foreach ($chapter in $chapters) {
    $questBlocks = New-Object System.Collections.Generic.List[string]
    $lastQuestId = $null

    for ($i = 0; $i -lt $chapter.quests.Count; $i++) {
        $quest = $chapter.quests[$i]
        $shape = Get-QuestShape -QuestIndex $i -QuestCount $chapter.quests.Count
        $size = Get-QuestSize -QuestIndex $i -QuestCount $chapter.quests.Count
        $renderY = Get-QuestY -QuestIndex $i
        $dependencies = @()
        if ($i -eq 0) {
            if ($previousQuestId) {
                $dependencies += $previousQuestId
            }
        }
        else {
            $dependencies += $chapter.quests[$i - 1].id
        }

        $dependencyBlock = if ($dependencies.Count -gt 0) {
            $dependencyIds = ($dependencies | ForEach-Object { '"' + $_ + '"' }) -join ', '
            "    dependencies: [$dependencyIds]`n"
        }
        else {
            ''
        }

        $tasksBlock = ($quest.tasks | ForEach-Object { '        ' + (Format-Task $_).Trim() }) -join ",`n"
        $rewardsBlock = ($quest.rewards | ForEach-Object { '        ' + (Format-Reward $_).Trim() }) -join ",`n"
        $questBlocks.Add(@"
  {
$dependencyBlock    description: ["$(Escape-Snbt $quest.description)"]
    icon: "$($quest.icon)"
    id: "$($quest.id)"
    rewards: [
$rewardsBlock
    ]
    shape: "$shape"
    size: ${size}d
    tasks: [
$tasksBlock
    ]
    title: "$(Escape-Snbt $quest.title)"
    x: $($quest.x)d
    y: ${renderY}d
  }
"@.TrimEnd())

        $lastQuestId = $quest.id
    }

    $chapterContent = @"
{
  autofocus_id: "$($chapter.quests[0].id)"
  default_hide_dependency_lines: false
  default_quest_shape: "square"
  filename: "$($chapter.filename)"
  group: "$groupId"
  hide_quest_until_deps_visible: true
  icon: "$($chapter.icon)"
  icon_scale: 1.25d
  id: "$($chapter.id)"
  order_index: $($chapter.order_index)
  quest_links: []
  quests: [
$($questBlocks -join ",`n")
  ]
  title: "$(Escape-Snbt $chapter.title)"
}
"@

    Set-Content -Path (Join-Path $chaptersDir ($chapter.filename + '.snbt')) -Value $chapterContent
    $previousQuestId = $lastQuestId
}
