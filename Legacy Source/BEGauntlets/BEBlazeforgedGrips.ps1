using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZEFORGEDGRIPS
#
###############################################################################

Class BEBlazeforgedGrips : BEGauntlets {
	BEBlazeforgedGrips() : base() {
		$this.Name               = 'Blazeforged Grips'
		$this.MapObjName         = 'blazeforgedgrips'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips heated in intense flames, maintaining their warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
