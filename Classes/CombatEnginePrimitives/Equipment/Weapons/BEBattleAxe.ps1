using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BATTLE AXE
#
###############################################################################

Class BEBattleAxe : BEWeapon {
	BEBattleAxe() : base() {
		$this.Name          = 'Battle Axe'
		$this.MapObjName    = 'battleaxe'
		$this.PurchasePrice = 320
		$this.SellPrice     = 160
		$this.TargetStats   = @{
			[StatId]::Attack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A large, two-handed axe, devastating in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
