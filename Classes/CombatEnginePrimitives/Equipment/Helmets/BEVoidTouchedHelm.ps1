using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VOID TOUCHED HELM
#
###############################################################################

Class BEVoidTouchedHelm : BEHelmet {
	BEVoidTouchedHelm() : base() {
		$this.Name               = 'Void Touched Helm'
		$this.MapObjName         = 'voidtouchedhelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that has touched the void, granting resistance to void energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
