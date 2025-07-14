using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHAMMEROFJUDGMENT
#
###############################################################################

Class BEHammerofJudgment : BEWeapon {
	BEHammerofJudgment() : base() {
		$this.Name          = 'Hammer of Judgment'
		$this.MapObjName    = 'hammerofjudgment'
		$this.PurchasePrice = 6300
		$this.SellPrice     = 3150
		$this.TargetStats   = @{
			[StatId]::Attack      = 165
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal hammer that delivers righteous judgment, capable of stunning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
