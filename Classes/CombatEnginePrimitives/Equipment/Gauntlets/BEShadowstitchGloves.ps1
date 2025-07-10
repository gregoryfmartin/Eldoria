using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWSTITCHGLOVES
#
###############################################################################

Class BEShadowstitchGloves : BEGauntlets {
	BEShadowstitchGloves() : base() {
		$this.Name               = 'Shadowstitch Gloves'
		$this.MapObjName         = 'shadowstitchgloves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves sewn from threads of shadow, providing stealth and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
