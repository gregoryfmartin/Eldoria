using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALLINEGREAVES
#
###############################################################################

Class BECrystallineGreaves : BEGreaves {
	BECrystallineGreaves() : base() {
		$this.Name               = 'Crystalline Greaves'
		$this.MapObjName         = 'crystallinegreaves'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves crafted from durable crystals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
