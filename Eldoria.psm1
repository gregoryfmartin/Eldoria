using namespace System
using namespace System.Media

Add-Type -AssemblyName PresentationCore

Set-StrictMode -Version Latest

$PSStyle.Progress.View = 'Minimal'

$Script:Rui = $(Get-Host).UI.RawUI

. "$PSScriptRoot\Private\LoadStrings.ps1"








Clear-Host
Write-Host "`e[?25l" -NoNewLine

Write-Host "`e[38;2;0;123;167m`e[5m$($Script:ModuleStringLoad)`e[m`n`n"
Write-Host "`e[38;2;205;28;24m`e[5m$($Script:ModuleStringEldoria)`e[m`n`n"










Write-Progress -Activity $Script:ProgressActivity -Status ($Script:EnumLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Enums\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:ColorLoadStrings | Get-Random) -PercentComplete -1
. "$PSScriptRoot\Classes\ConsoleColor\ConsoleColor24.ps1"
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\ConsoleColor\CC*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:FnlLoadStrings | Get-Random) -PercentComplete -1
. "$PSScriptRoot\Classes\Mapping\FastNoiseLite\FastNoiseLite.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:AnsiLoadStrings | Get-Random) -PercentComplete -1
#//////////////////////////////////////////////////////////////////////////////
# AT STRING SUPPORT
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Classes\ATStrings\ATControlSequences.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATForegroundColor.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATForegroundColorNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATBackgroundColor.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATBackgroundColorNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATDecoration.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATDecorationNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATCoordinates.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATCoordinatesNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATCoordinatesDefault.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATStringPrefix.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATStringPrefixNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATString.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATStringNone.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATStringComposite.ps1"
. "$PSScriptRoot\Classes\ATStrings\ATSceneImageString.ps1"
. "$PSScriptRoot\Classes\ATStrings\SceneImage.ps1"
. "$PSScriptRoot\Classes\ATStrings\SIEmpty.ps1"
. "$PSScriptRoot\Classes\ATStrings\SIInternalBase.ps1"
. "$PSScriptRoot\Classes\ATStrings\SIRandomNoise.ps1"
. "$PSScriptRoot\Classes\ATStrings\EnemyEntityImage.ps1"
. "$PSScriptRoot\Classes\ATStrings\EEIEmpty.ps1"
. "$PSScriptRoot\Classes\ATStrings\EEIInternalBase.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:EnemyLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\ATStrings\EnemyEntityImages\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:MapLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\ATStrings\SIMaps\*.ps1")) {
    . $File.FullName
}

#//////////////////////////////////////////////////////////////////////////////
# COMBAT ENGINE SUPPORT
#//////////////////////////////////////////////////////////////////////////////
Write-Progress -Activity $Script:ProgressActivity -Status ($Script:MapObjLoadStrings | Get-Random) -PercentComplete -1
. "$PSScriptRoot\Classes\Mapping\MapTileObject.ps1"
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\Mapping\MapTileObjects\*.ps1")) {
    . $File.FullName
}
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\Mapping\MapTileObjects\Warpables\*.ps1")) {
    . $File.FullName
}
. "$PSScriptRoot\Classes\Mapping\MapTile.ps1"
. "$PSScriptRoot\Classes\Mapping\Map.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:BattleEngineLoadStrings | Get-Random) -PercentComplete -1
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleEntityProperty.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleAction.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleEntity.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleActionResult.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\PlayerActionInventory.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\PlayerItemInventory.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Player.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\EnemyBattleEntity.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:BattleTechniqueLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleActions\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:EnemyEntityLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\EnemyEntities\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:EquipBasicLoadStrings | Get-Random) -PercentComplete -1
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BattleEquipment.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEArmor.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEBoots.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BECape.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEGauntlets.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEGreaves.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEHelmet.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEJewelry.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEPauldron.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\BEWeapon.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:ArmorLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Armors\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:BootLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Boots\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:CapeLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Capes\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:GauntletLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Gauntlets\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:GreavesLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Greaves\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:HelmetLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Helmets\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:JewelryLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Jewelry\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:PauldronLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Pauldrons\*.ps1")) {
    . $File.FullName
}

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:WeaponLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Weapons\*.ps1")) {
    . $File.FullName
}










Write-Progress -Activity $Script:ProgressActivity -Status ($Script:WindowSupportLoadStrings | Get-Random) -PercentComplete -1
#//////////////////////////////////////////////////////////////////////////////
# BUFFER/WINDOW SUPPORT
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Classes\BufferManager.ps1"
. "$PSScriptRoot\Classes\UI\UIEContainer.ps1"
. "$PSScriptRoot\Classes\UI\WindowBase.ps1"
. "$PSScriptRoot\Classes\UI\BattlePhaseIndicator.ps1"
. "$PSScriptRoot\Classes\UI\SSAFiglet.ps1"
. "$PSScriptRoot\Classes\UI\SSASubtitle.ps1"
. "$PSScriptRoot\Classes\UI\SSAPressEnterPrompt.ps1"

Write-Progress -Activity $Script:ProgressActivity -Status ($Script:WindowBuildLoadStrings | Get-Random) -PercentComplete -1
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\UI\Windows\*.ps1")) {
    . $File.FullName
}










Write-Progress -Activity $Script:ProgressActivity -Status ($Script:FinishUpLoadStrings | Get-Random) -PercentComplete -1
#//////////////////////////////////////////////////////////////////////////////
# BATTLE MANAGER SUPPORT
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Classes\BattleManager.ps1"

. "$PSScriptRoot\Classes\GameCore.ps1"










Write-Progress -Activity $Script:ProgressActivity -Status ($Script:SixelLoadStrings | Get-Random) -PercentComplete -1
#//////////////////////////////////////////////////////////////////////////////
# RESOURCE LOADING
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Resources\Sixel\Profiles.ps1"










Write-Progress -Activity $Script:ProgressActivity -Status ($Script:GlobalsLoadStrings | Get-Random) -PercentComplete -1
#//////////////////////////////////////////////////////////////////////////////
# VARIABLES
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Private\Variables.ps1"










. "$PSScriptRoot\Public\Start-Eldoria.ps1"










Clear-Host; Clear-Host
Write-Host "Loading complete! Run `e[38;2;228;208;10m`e[5mStart-Eldoria`e[m to play!`n`n"
