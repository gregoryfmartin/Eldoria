using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIKEDCLUB
#
###############################################################################

Class BESpikedClub : BEWeapon {
	BESpikedClub() : base() {
		$this.Name          = 'Spiked Club'
		$this.MapObjName    = 'spikedclub'
		$this.PurchasePrice = 130
		$this.SellPrice     = 65
		$this.TargetStats   = @{
			[StatId]::Attack = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A club covered in sharp spikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
