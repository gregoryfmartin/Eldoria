using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHENPAULDRON
#
###############################################################################

Class BEEarthenPauldron : BEPauldron {
	BEEarthenPauldron() : base() {
		$this.Name               = 'Earthen Pauldron'
		$this.MapObjName         = 'earthenpauldron'
		$this.PurchasePrice      = 3150
		$this.SellPrice          = 1575
		$this.TargetStats        = @{
			[StatId]::Defense = 63
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from compressed earth, offering unparalleled physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
