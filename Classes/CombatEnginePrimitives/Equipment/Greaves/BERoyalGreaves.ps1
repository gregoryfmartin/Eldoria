using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALGREAVES
#
###############################################################################

Class BERoyalGreaves : BEGreaves {
	BERoyalGreaves() : base() {
		$this.Name               = 'Royal Greaves'
		$this.MapObjName         = 'royalgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves fit for royalty, exquisitely crafted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
