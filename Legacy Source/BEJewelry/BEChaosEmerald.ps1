using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAOSEMERALD
#
###############################################################################

Class BEChaosEmerald : BEJewelry {
	BEChaosEmerald() : base() {
		$this.Name               = 'Chaos Emerald'
		$this.MapObjName         = 'chaosemerald'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Attack = 2
			[StatId]::Defense = 2
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Speed = 2
			[StatId]::Luck = 2
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chaotic emerald, distorting reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
