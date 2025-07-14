using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERCLAPBRACELET
#
###############################################################################

Class BEThunderclapBracelet : BEJewelry {
	BEThunderclapBracelet() : base() {
		$this.Name               = 'Thunderclap Bracelet'
		$this.MapObjName         = 'thunderclapbracelet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bracelet that hums with static, occasionally discharging electricity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
