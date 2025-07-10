using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANDITGREAVES
#
###############################################################################

Class BEBanditGreaves : BEGreaves {
	BEBanditGreaves() : base() {
		$this.Name               = 'Bandit Greaves'
		$this.MapObjName         = 'banditgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves favored by brigands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
