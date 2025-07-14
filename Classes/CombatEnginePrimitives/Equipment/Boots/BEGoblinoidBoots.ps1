using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINOIDBOOTS
#
###############################################################################

Class BEGoblinoidBoots : BEBoots {
	BEGoblinoidBoots() : base() {
		$this.Name               = 'Goblinoid Boots'
		$this.MapObjName         = 'goblinoidboots'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots favored by various goblinoid races.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
