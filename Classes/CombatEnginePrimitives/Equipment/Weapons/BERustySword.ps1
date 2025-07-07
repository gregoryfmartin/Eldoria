using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUSTY SWORD
#
###############################################################################

Class BERustySword : BEWeapon {
	BERustySword() : base() {
		$this.Name          = 'Rusty Sword'
		$this.MapObjName    = 'rustysword'
		$this.PurchasePrice = 45
		$this.SellPrice     = 22
		$this.TargetStats   = @{
			[StatId]::Attack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An old, neglected sword. Not very effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
