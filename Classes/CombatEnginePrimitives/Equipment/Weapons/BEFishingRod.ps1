using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FISHING ROD
#
###############################################################################

Class BEFishingRod : BEWeapon {
	BEFishingRod() : base() {
		$this.Name          = 'Fishing Rod'
		$this.MapObjName    = 'fishingrod'
		$this.PurchasePrice = 30
		$this.SellPrice     = 15
		$this.TargetStats   = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Not truly a weapon, but can be used in a pinch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
