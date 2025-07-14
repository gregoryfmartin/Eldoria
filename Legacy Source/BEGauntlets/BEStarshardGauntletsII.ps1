using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARSHARDGAUNTLETSII
#
###############################################################################

Class BEStarshardGauntletsII : BEGauntlets {
	BEStarshardGauntletsII() : base() {
		$this.Name               = 'Starshard Gauntlets II'
		$this.MapObjName         = 'starshardgauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Starshard Gauntlets, radiating stronger cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
