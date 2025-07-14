using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBUGBEARGREAVES
#
###############################################################################

Class BEBugbearGreaves : BEGreaves {
	BEBugbearGreaves() : base() {
		$this.Name               = 'Bugbear Greaves'
		$this.MapObjName         = 'bugbeargreaves'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy greaves of bugbears.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
