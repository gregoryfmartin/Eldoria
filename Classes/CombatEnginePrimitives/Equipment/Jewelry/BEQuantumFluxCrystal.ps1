using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUANTUMFLUXCRYSTAL
#
###############################################################################

Class BEQuantumFluxCrystal : BEJewelry {
	BEQuantumFluxCrystal() : base() {
		$this.Name               = 'Quantum Flux Crystal'
		$this.MapObjName         = 'quantumfluxcrystal'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crystal that vibrates with quantum fluctuations.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
