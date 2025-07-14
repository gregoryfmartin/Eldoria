using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALWEAVEGLOVESII
#
###############################################################################

Class BECrystalweaveGlovesII : BEGauntlets {
	BECrystalweaveGlovesII() : base() {
		$this.Name               = 'Crystalweave Gloves II'
		$this.MapObjName         = 'crystalweaveglovesii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Crystalweave Gloves, enhancing focus further.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
