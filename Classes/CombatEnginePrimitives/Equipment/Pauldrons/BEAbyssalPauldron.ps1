using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALPAULDRON
#
###############################################################################

Class BEAbyssalPauldron : BEPauldron {
	BEAbyssalPauldron() : base() {
		$this.Name               = 'Abyssal Pauldron'
		$this.MapObjName         = 'abyssalpauldron'
		$this.PurchasePrice      = 4050
		$this.SellPrice          = 2025
		$this.TargetStats        = @{
			[StatId]::Defense = 81
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pulled from the deepest trenches, exuding an ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
