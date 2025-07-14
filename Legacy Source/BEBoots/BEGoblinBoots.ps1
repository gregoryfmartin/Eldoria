using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINBOOTS
#
###############################################################################

Class BEGoblinBoots : BEBoots {
	BEGoblinBoots() : base() {
		$this.Name               = 'Goblin Boots'
		$this.MapObjName         = 'goblinboots'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude boots taken from goblins.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
