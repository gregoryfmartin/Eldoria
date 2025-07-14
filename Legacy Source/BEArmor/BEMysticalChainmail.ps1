using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICALCHAINMAIL
#
###############################################################################

Class BEMysticalChainmail : BEArmor {
	BEMysticalChainmail() : base() {
		$this.Name               = 'Mystical Chainmail'
		$this.MapObjName         = 'mysticalchainmail'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail imbued with minor protective enchantments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
