using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEMOTH CLUB
#
###############################################################################

Class BEBehemothClub : BEWeapon {
	BEBehemothClub() : base() {
		$this.Name          = 'Behemoth Club'
		$this.MapObjName    = 'behemothclub'
		$this.PurchasePrice = 5200
		$this.SellPrice     = 2600
		$this.TargetStats   = @{
			[StatId]::Attack = 145
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gigantic club, requiring immense strength to wield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
