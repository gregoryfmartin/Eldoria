using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJESTERPAULDRON
#
###############################################################################

Class BEJesterPauldron : BEPauldron {
	BEJesterPauldron() : base() {
		$this.Name               = 'Jester Pauldron'
		$this.MapObjName         = 'jesterpauldron'
		$this.PurchasePrice      = 7850
		$this.SellPrice          = 3925
		$this.TargetStats        = @{
			[StatId]::Defense = 157
			[StatId]::MagicDefense = 77
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Provides unexpected defenses and chaotic effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
