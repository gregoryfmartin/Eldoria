using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEHAMMER
#
###############################################################################

Class BEStoneHammer : BEWeapon {
	BEStoneHammer() : base() {
		$this.Name          = 'Stone Hammer'
		$this.MapObjName    = 'stonehammer'
		$this.PurchasePrice = 70
		$this.SellPrice     = 35
		$this.TargetStats   = @{
			[StatId]::Attack = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A primitive hammer with a stone head.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
