using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLADEOFTRUTH
#
###############################################################################

Class BEBladeofTruth : BEWeapon {
	BEBladeofTruth() : base() {
		$this.Name          = 'Blade of Truth'
		$this.MapObjName    = 'bladeoftruth'
		$this.PurchasePrice = 1150
		$this.SellPrice     = 575
		$this.TargetStats   = @{
			[StatId]::Attack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary sword said to reveal hidden weaknesses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
