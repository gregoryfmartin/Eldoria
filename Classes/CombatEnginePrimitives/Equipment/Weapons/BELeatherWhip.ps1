using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LEATHER WHIP
#
###############################################################################

Class BELeatherWhip : BEWeapon {
	BELeatherWhip() : base() {
		$this.Name          = 'Leather Whip'
		$this.MapObjName    = 'leatherwhip'
		$this.PurchasePrice = 90
		$this.SellPrice     = 45
		$this.TargetStats   = @{
			[StatId]::Attack = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flexible whip made of leather, good for crowd control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
