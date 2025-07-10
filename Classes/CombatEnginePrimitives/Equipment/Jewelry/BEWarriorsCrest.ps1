using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORSCREST
#
###############################################################################

Class BEWarriorsCrest : BEJewelry {
	BEWarriorsCrest() : base() {
		$this.Name               = 'Warrior''s Crest'
		$this.MapObjName         = 'warriorscrest'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small crest, symbolizing strength and courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
