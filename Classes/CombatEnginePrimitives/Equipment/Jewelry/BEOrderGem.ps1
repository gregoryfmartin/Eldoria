using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORDERGEM
#
###############################################################################

Class BEOrderGem : BEJewelry {
	BEOrderGem() : base() {
		$this.Name               = 'Order Gem'
		$this.MapObjName         = 'ordergem'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
			[StatId]::Luck = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A perfectly balanced gem, promoting harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
