using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STUDDED CLUB
#
###############################################################################

Class BEStuddedClub : BEWeapon {
	BEStuddedClub() : base() {
		$this.Name          = 'Studded Club'
		$this.MapObjName    = 'studdedclub'
		$this.PurchasePrice = 100
		$this.SellPrice     = 50
		$this.TargetStats   = @{
			[StatId]::Attack = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A club embedded with metal studs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
