using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGEOLOGISTSPICKAXEPIN
#
###############################################################################

Class BEGeologistsPickaxePin : BEJewelry {
	BEGeologistsPickaxePin() : base() {
		$this.Name               = 'Geologist''s Pickaxe Pin'
		$this.MapObjName         = 'geologistspickaxepin'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a tiny pickaxe, for mineral detection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
