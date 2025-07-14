using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALCROWN
#
###############################################################################

Class BEAbyssalCrown : BEHelmet {
	BEAbyssalCrown() : base() {
		$this.Name               = 'Abyssal Crown'
		$this.MapObjName         = 'abyssalcrown'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark crown from the abyss, granting control over deep-sea creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
