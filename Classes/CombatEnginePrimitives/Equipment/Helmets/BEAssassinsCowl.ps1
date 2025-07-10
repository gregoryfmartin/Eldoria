using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINSCOWL
#
###############################################################################

Class BEAssassinsCowl : BEHelmet {
	BEAssassinsCowl() : base() {
		$this.Name               = 'Assassin''s Cowl'
		$this.MapObjName         = 'assassinscowl'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cowl that grants the wearer enhanced senses and deadly precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
