using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGIANTGREAVES
#
###############################################################################

Class BEGiantGreaves : BEGreaves {
	BEGiantGreaves() : base() {
		$this.Name               = 'Giant Greaves'
		$this.MapObjName         = 'giantgreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves sized for colossal beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
