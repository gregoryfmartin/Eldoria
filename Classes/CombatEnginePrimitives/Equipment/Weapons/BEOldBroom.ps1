using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOLDBROOM
#
###############################################################################

Class BEOldBroom : BEWeapon {
	BEOldBroom() : base() {
		$this.Name          = 'Old Broom'
		$this.MapObjName    = 'oldbroom'
		$this.PurchasePrice = 20
		$this.SellPrice     = 10
		$this.TargetStats   = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A worn-out broom. Not very effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
