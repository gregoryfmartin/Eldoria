using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBUGBEARBOOTS
#
###############################################################################

Class BEBugbearBoots : BEBoots {
	BEBugbearBoots() : base() {
		$this.Name               = 'Bugbear Boots'
		$this.MapObjName         = 'bugbearboots'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots of bugbears.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
