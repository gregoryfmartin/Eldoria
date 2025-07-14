using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUDGEGREAVES
#
###############################################################################

Class BEJudgeGreaves : BEGreaves {
	BEJudgeGreaves() : base() {
		$this.Name               = 'Judge Greaves'
		$this.MapObjName         = 'judgegreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a judicial authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
