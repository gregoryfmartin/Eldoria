using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINOIDGREAVES
#
###############################################################################

Class BEGoblinoidGreaves : BEGreaves {
	BEGoblinoidGreaves() : base() {
		$this.Name               = 'Goblinoid Greaves'
		$this.MapObjName         = 'goblinoidgreaves'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves favored by various goblinoid races.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
