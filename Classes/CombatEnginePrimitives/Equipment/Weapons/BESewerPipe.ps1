using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SEWER PIPE
#
###############################################################################

Class BESewerPipe : BEWeapon {
	BESewerPipe() : base() {
		$this.Name          = 'Sewer Pipe'
		$this.MapObjName    = 'sewerpipe'
		$this.PurchasePrice = 70
		$this.SellPrice     = 35
		$this.TargetStats   = @{
			[StatId]::Attack = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A discarded pipe from the sewers. Surprisingly robust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
