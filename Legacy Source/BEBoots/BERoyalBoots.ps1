using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALBOOTS
#
###############################################################################

Class BERoyalBoots : BEBoots {
	BERoyalBoots() : base() {
		$this.Name               = 'Royal Boots'
		$this.MapObjName         = 'royalboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for royalty, exquisitely crafted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
