using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALWEAVEGLOVES
#
###############################################################################

Class BECrystalweaveGloves : BEGauntlets {
	BECrystalweaveGloves() : base() {
		$this.Name               = 'Crystalweave Gloves'
		$this.MapObjName         = 'crystalweavegloves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with fine crystal threads, enhancing focus.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
