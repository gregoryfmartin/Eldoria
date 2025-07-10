using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIGHTERSCUFFS
#
###############################################################################

Class BEFightersCuffs : BEGauntlets {
	BEFightersCuffs() : base() {
		$this.Name               = 'Fighter''s Cuffs'
		$this.MapObjName         = 'fighterscuffs'
		$this.PurchasePrice      = 270
		$this.SellPrice          = 135
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Strong cuffs for brawlers and melee combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
