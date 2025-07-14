using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMMANDERBOOTS
#
###############################################################################

Class BECommanderBoots : BEBoots {
	BECommanderBoots() : base() {
		$this.Name               = 'Commander Boots'
		$this.MapObjName         = 'commanderboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a battle hardened commander.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
