using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGNOMISHPAULDRON
#
###############################################################################

Class BEGnomishPauldron : BEPauldron {
	BEGnomishPauldron() : base() {
		$this.Name               = 'Gnomish Pauldron'
		$this.MapObjName         = 'gnomishpauldron'
		$this.PurchasePrice      = 5850
		$this.SellPrice          = 2925
		$this.TargetStats        = @{
			[StatId]::Defense = 117
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ingeniously crafted with hidden compartments and mechanisms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
