using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHANTOMPAULDRON
#
###############################################################################

Class BEPhantomPauldron : BEPauldron {
	BEPhantomPauldron() : base() {
		$this.Name               = 'Phantom Pauldron'
		$this.MapObjName         = 'phantompauldron'
		$this.PurchasePrice      = 4900
		$this.SellPrice          = 2450
		$this.TargetStats        = @{
			[StatId]::Defense = 98
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Makes its wearer semi-corporeal, allowing them to phase through attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
