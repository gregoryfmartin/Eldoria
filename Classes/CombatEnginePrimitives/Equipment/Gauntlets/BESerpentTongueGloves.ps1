using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTTONGUEGLOVES
#
###############################################################################

Class BESerpentTongueGloves : BEGauntlets {
	BESerpentTongueGloves() : base() {
		$this.Name               = 'Serpent Tongue Gloves'
		$this.MapObjName         = 'serpenttonguegloves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 12
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with a subtle serpentine pattern, aiding in swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
