using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAUTOMATONGEAR
#
###############################################################################

Class BEAutomatonGear : BEJewelry {
	BEAutomatonGear() : base() {
		$this.Name               = 'Automaton Gear'
		$this.MapObjName         = 'automatongear'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A perfectly crafted gear from an ancient automaton.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
