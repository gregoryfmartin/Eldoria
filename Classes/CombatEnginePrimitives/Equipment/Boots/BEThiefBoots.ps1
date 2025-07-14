using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFBOOTS
#
###############################################################################

Class BEThiefBoots : BEBoots {
	BEThiefBoots() : base() {
		$this.Name               = 'Thief Boots'
		$this.MapObjName         = 'thiefboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for stealthy operatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
