using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBASILISKPAULDRON
#
###############################################################################

Class BEBasiliskPauldron : BEPauldron {
	BEBasiliskPauldron() : base() {
		$this.Name               = 'Basilisk Pauldron'
		$this.MapObjName         = 'basiliskpauldron'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{
			[StatId]::Defense = 104
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Petrifies attackers with its gaze, offering unique defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
