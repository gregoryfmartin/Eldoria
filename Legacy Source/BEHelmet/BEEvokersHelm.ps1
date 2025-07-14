using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEVOKERSHELM
#
###############################################################################

Class BEEvokersHelm : BEHelmet {
	BEEvokersHelm() : base() {
		$this.Name               = 'Evoker''s Helm'
		$this.MapObjName         = 'evokershelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm worn by evokers, amplifying their destructive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
