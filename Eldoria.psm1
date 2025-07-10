$PrivateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1"
Foreach($File in $PrivateFunctions) {
    . $File.FullName
}

$PublicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"
Foreach($File in $PublicFunctions) {
    . $File.FullName
}

$Enumerations = Get-ChildItem -Path "$PSScriptRoot\Enums\*.ps1"
Foreach($File in $Enumerations) {
    . $File.FullName
}

$ColorSupport = Get-ChildItem -Path "$PSScriptRoot\Classes\ConsoleColor\CC*.ps1"
. "$PSScriptRoot\Classes\ConsoleColor\ConsoleColor24.ps1"
Foreach($File in $ColorSupport) {
    . $File.FullName
}

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
. "$PSScriptRoot\Classes\ATStrings\EnemyEntityImage.ps1"
. "$PSScriptRoot\Classes\ATStrings\EEIEmpty.ps1"
. "$PSScriptRoot\Classes\ATStrings\EEIInternalBase.ps1"

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\ATStrings\EnemyEntityImages\*.ps1")) {
    . $File.FullName
}

#//////////////////////////////////////////////////////////////////////////////
# COMBAT ENGINE SUPPORT
#//////////////////////////////////////////////////////////////////////////////
. "$PSScriptRoot\Classes\Mapping\MapTileObject.ps1"
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\Mapping\MapTileObjects\*.ps1")) {
    . $File.FullName
}
Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\Mapping\MapTileObjects\Warpables\*.ps1")) {
    . $File.FullName
}

. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleEntityProperty.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleAction.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleEntity.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleActionResult.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\PlayerActionInventory.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\PlayerItemInventory.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\Player.ps1"
. "$PSScriptRoot\Classes\CombatEnginePrimitives\EnemyBattleEntity.ps1"

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\BattleActions\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\EnemyEntities\*.ps1")) {
    . $File.FullName
}

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

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Armors\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Boots\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Capes\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Gauntlets\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Greaves\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Helmets\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Jewelry\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Pauldrons\*.ps1")) {
    . $File.FullName
}

Foreach($File in (Get-ChildItem -Path "$PSScriptRoot\Classes\CombatEnginePrimitives\Equipment\Weapons\*.ps1")) {
    . $File.FullName
}
