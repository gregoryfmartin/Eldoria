using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUDGEBOOTS
#
###############################################################################

Class BEJudgeBoots : BEBoots {
	BEJudgeBoots() : base() {
		$this.Name               = 'Judge Boots'
		$this.MapObjName         = 'judgeboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a judicial authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
