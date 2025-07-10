using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROFANEMARK
#
###############################################################################

Class BEProfaneMark : BEJewelry {
	BEProfaneMark() : base() {
		$this.Name               = 'Profane Mark'
		$this.MapObjName         = 'profanemark'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mark, radiating unholy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
