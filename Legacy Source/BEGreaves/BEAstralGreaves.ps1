using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALGREAVES
#
###############################################################################

Class BEAstralGreaves : BEGreaves {
	BEAstralGreaves() : base() {
		$this.Name               = 'Astral Greaves'
		$this.MapObjName         = 'astralgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that draw power from the stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
