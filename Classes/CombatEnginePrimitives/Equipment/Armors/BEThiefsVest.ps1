using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFSVEST
#
###############################################################################

Class BEThiefsVest : BEArmor {
	BEThiefsVest() : base() {
		$this.Name               = 'Thief''s Vest'
		$this.MapObjName         = 'thiefsvest'
		$this.PurchasePrice      = 210
		$this.SellPrice          = 105
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight vest designed for agility and concealment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
