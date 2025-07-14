using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENBOOTS
#
###############################################################################

Class BEElvenBoots : BEBoots {
	BEElvenBoots() : base() {
		$this.Name               = 'Elven Boots'
		$this.MapObjName         = 'elvenboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 20
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Graceful boots favored by elves, light and agile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
