using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENINJAPAULDRON
#
###############################################################################

Class BENinjaPauldron : BEPauldron {
	BENinjaPauldron() : base() {
		$this.Name               = 'Ninja Pauldron'
		$this.MapObjName         = 'ninjapauldron'
		$this.PurchasePrice      = 9300
		$this.SellPrice          = 4650
		$this.TargetStats        = @{
			[StatId]::Defense = 186
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and stealthy, designed for silent infiltration and swift strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
