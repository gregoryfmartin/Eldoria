using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONLORDBOOTS
#
###############################################################################

Class BEDragonlordBoots : BEBoots {
	BEDragonlordBoots() : base() {
		$this.Name               = 'Dragonlord Boots'
		$this.MapObjName         = 'dragonlordboots'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by a dragonlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
