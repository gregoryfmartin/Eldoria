using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASCETICSSIMPLECORD
#
###############################################################################

Class BEAsceticsSimpleCord : BEJewelry {
	BEAsceticsSimpleCord() : base() {
		$this.Name               = 'Ascetic''s Simple Cord'
		$this.MapObjName         = 'asceticssimplecord'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain cord, representing simplicity and detachment.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
