using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE QUANTUM HELM
#
###############################################################################

Class BEQuantumHelm : BEHelmet {
	BEQuantumHelm() : base() {
		$this.Name               = 'Quantum Helm'
		$this.MapObjName         = 'quantumhelm'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm incorporating quantum technology, allowing minor reality manipulation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
