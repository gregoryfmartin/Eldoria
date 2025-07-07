using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CLUB
#
###############################################################################

Class BEClub : BEWeapon {
	BEClub() : base() {
		$this.Name          = 'Club'
		$this.MapObjName    = 'club'
		$this.PurchasePrice = 60
		$this.SellPrice     = 30
		$this.TargetStats   = @{
			[StatId]::Attack = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, blunt instrument.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
