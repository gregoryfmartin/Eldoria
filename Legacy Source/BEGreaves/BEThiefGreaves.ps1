using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFGREAVES
#
###############################################################################

Class BEThiefGreaves : BEGreaves {
	BEThiefGreaves() : base() {
		$this.Name               = 'Thief Greaves'
		$this.MapObjName         = 'thiefgreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves for stealthy operatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
