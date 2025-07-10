using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVESTOFTHEWILD
#
###############################################################################

Class BEVestoftheWild : BEArmor {
	BEVestoftheWild() : base() {
		$this.Name               = 'Vest of the Wild'
		$this.MapObjName         = 'vestofthewild'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from beast hides, ideal for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
