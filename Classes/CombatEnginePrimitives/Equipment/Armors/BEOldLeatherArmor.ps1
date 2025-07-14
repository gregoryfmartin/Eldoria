using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOLDLEATHERARMOR
#
###############################################################################

Class BEOldLeatherArmor : BEArmor {
	BEOldLeatherArmor() : base() {
		$this.Name               = 'Old Leather Armor'
		$this.MapObjName         = 'oldleatherarmor'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn and patched leather armor, still offers some defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
