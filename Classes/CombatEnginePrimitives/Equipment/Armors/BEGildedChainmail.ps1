using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGILDEDCHAINMAIL
#
###############################################################################

Class BEGildedChainmail : BEArmor {
	BEGildedChainmail() : base() {
		$this.Name               = 'Gilded Chainmail'
		$this.MapObjName         = 'gildedchainmail'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail with decorative gold plating, less practical.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
