using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHERUBPAULDRON
#
###############################################################################

Class BECherubPauldron : BEPauldron {
	BECherubPauldron() : base() {
		$this.Name               = 'Cherub Pauldron'
		$this.MapObjName         = 'cherubpauldron'
		$this.PurchasePrice      = 6200
		$this.SellPrice          = 3100
		$this.TargetStats        = @{
			[StatId]::Defense = 124
			[StatId]::MagicDefense = 47
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and angelic, bestowing blessings upon its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
