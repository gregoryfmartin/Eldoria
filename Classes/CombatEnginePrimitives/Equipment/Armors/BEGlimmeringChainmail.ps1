using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLIMMERINGCHAINMAIL
#
###############################################################################

Class BEGlimmeringChainmail : BEArmor {
	BEGlimmeringChainmail() : base() {
		$this.Name               = 'Glimmering Chainmail'
		$this.MapObjName         = 'glimmeringchainmail'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail that catches the light and subtly disorients foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
