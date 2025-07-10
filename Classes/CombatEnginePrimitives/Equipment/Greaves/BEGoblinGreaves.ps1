using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINGREAVES
#
###############################################################################

Class BEGoblinGreaves : BEGreaves {
	BEGoblinGreaves() : base() {
		$this.Name               = 'Goblin Greaves'
		$this.MapObjName         = 'goblingreaves'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude greaves taken from goblins.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
