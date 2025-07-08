using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STORMBRINGER
#
###############################################################################

Class BEStormbringer : BEWeapon {
	BEStormbringer() : base() {
		$this.Name          = 'Stormbringer'
		$this.MapObjName    = 'stormbringer'
		$this.PurchasePrice = 4300
		$this.SellPrice     = 2150
		$this.TargetStats   = @{
			[StatId]::Attack      = 105
			[StatId]::MagicAttack = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sword that can summon gusts of wind and lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
