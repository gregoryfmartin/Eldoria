using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTSAPRON
#
###############################################################################

Class BEAlchemistsApron : BEArmor {
	BEAlchemistsApron() : base() {
		$this.Name               = 'Alchemist''s Apron'
		$this.MapObjName         = 'alchemistsapron'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy apron with many pockets, useful for potion crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
