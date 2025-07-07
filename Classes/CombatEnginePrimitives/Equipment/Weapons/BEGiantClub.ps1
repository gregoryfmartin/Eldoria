using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GIANT CLUB
#
###############################################################################

Class BEGiantClub : BEWeapon {
	BEGiantClub() : base() {
		$this.Name          = 'Giant Club'
		$this.MapObjName    = 'giantclub'
		$this.PurchasePrice = 820
		$this.SellPrice     = 410
		$this.TargetStats   = @{
			[StatId]::Attack = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal club, wielded by only the strongest warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
