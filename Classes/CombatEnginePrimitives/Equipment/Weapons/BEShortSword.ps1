using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SHORT SWORD
#
###############################################################################

Class BEShortSword : BEWeapon {
	BEShortSword() : base() {
		$this.Name          = 'Short Sword'
		$this.MapObjName    = 'shortsword'
		$this.PurchasePrice = 120
		$this.SellPrice     = 60
		$this.TargetStats   = @{
			[StatId]::Attack = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard one-handed sword, good for basic combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
