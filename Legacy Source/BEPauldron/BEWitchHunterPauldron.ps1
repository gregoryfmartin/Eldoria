using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWITCHHUNTERPAULDRON
#
###############################################################################

Class BEWitchHunterPauldron : BEPauldron {
	BEWitchHunterPauldron() : base() {
		$this.Name               = 'Witch Hunter Pauldron'
		$this.MapObjName         = 'witchhunterpauldron'
		$this.PurchasePrice      = 7200
		$this.SellPrice          = 3600
		$this.TargetStats        = @{
			[StatId]::Defense = 144
			[StatId]::MagicDefense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Specifically designed to combat magic users, with innate resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
