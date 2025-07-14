using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWOVENGLOVES
#
###############################################################################

Class BESpiritWovenGloves : BEGauntlets {
	BESpiritWovenGloves() : base() {
		$this.Name               = 'Spirit Woven Gloves'
		$this.MapObjName         = 'spiritwovengloves'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with spectral threads, offering ethereal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
