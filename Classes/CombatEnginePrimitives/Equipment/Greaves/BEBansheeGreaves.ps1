using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANSHEEGREAVES
#
###############################################################################

Class BEBansheeGreaves : BEGreaves {
	BEBansheeGreaves() : base() {
		$this.Name               = 'Banshee Greaves'
		$this.MapObjName         = 'bansheegreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that emit a mournful wail.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
