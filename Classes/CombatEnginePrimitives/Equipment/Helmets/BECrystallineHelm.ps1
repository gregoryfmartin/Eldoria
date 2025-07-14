using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALLINEHELM
#
###############################################################################

Class BECrystallineHelm : BEHelmet {
	BECrystallineHelm() : base() {
		$this.Name               = 'Crystalline Helm'
		$this.MapObjName         = 'crystallinehelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of pure crystal, offering excellent protection and magic amplification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
