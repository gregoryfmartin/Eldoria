using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTBOOTS
#
###############################################################################

Class BEAlchemistBoots : BEBoots {
	BEAlchemistBoots() : base() {
		$this.Name               = 'Alchemist Boots'
		$this.MapObjName         = 'alchemistboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who transmute elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
