using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARHAMMER
#
###############################################################################

Class BEWarHammer : BEWeapon {
	BEWarHammer() : base() {
		$this.Name          = 'War Hammer'
		$this.MapObjName    = 'warhammer'
		$this.PurchasePrice = 300
		$this.SellPrice     = 150
		$this.TargetStats   = @{
			[StatId]::Attack = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, blunt weapon designed to crush armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
