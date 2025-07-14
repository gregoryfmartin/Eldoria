using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESACRIFICESSHROUD
#
###############################################################################

Class BESacrificesShroud : BEHelmet {
	BESacrificesShroud() : base() {
		$this.Name               = 'Sacrifice''s Shroud'
		$this.MapObjName         = 'sacrificesshroud'
		$this.PurchasePrice      = 10
		$this.SellPrice          = 5
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple shroud for ritual sacrifices, offering no protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
