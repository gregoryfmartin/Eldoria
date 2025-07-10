using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASCETICPAULDRON
#
###############################################################################

Class BEAsceticPauldron : BEPauldron {
	BEAsceticPauldron() : base() {
		$this.Name               = 'Ascetic Pauldron'
		$this.MapObjName         = 'asceticpauldron'
		$this.PurchasePrice      = 9050
		$this.SellPrice          = 4525
		$this.TargetStats        = @{
			[StatId]::Defense = 181
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Minimizes distractions, allowing for heightened focus and discipline.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
