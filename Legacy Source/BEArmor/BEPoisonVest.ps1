using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPOISONVEST
#
###############################################################################

Class BEPoisonVest : BEArmor {
	BEPoisonVest() : base() {
		$this.Name               = 'Poison Vest'
		$this.MapObjName         = 'poisonvest'
		$this.PurchasePrice      = 290
		$this.SellPrice          = 145
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest coated in a subtle, non-toxic venom, useful for rogues.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
