using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHPLATE
#
###############################################################################

Class BEEarthPlate : BEArmor {
	BEEarthPlate() : base() {
		$this.Name               = 'Earth Plate'
		$this.MapObjName         = 'earthplate'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plate armor forged from enchanted earth, very sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
