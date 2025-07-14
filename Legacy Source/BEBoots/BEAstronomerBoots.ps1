using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRONOMERBOOTS
#
###############################################################################

Class BEAstronomerBoots : BEBoots {
	BEAstronomerBoots() : base() {
		$this.Name               = 'Astronomer Boots'
		$this.MapObjName         = 'astronomerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for star gazers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
