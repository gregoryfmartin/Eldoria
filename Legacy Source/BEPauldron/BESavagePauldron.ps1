using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAVAGEPAULDRON
#
###############################################################################

Class BESavagePauldron : BEPauldron {
	BESavagePauldron() : base() {
		$this.Name               = 'Savage Pauldron'
		$this.MapObjName         = 'savagepauldron'
		$this.PurchasePrice      = 8400
		$this.SellPrice          = 4200
		$this.TargetStats        = @{
			[StatId]::Defense = 168
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from raw materials, for those who embrace primal combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
