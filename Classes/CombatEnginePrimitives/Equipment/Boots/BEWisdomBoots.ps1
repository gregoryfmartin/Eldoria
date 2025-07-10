using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWISDOMBOOTS
#
###############################################################################

Class BEWisdomBoots : BEBoots {
	BEWisdomBoots() : base() {
		$this.Name               = 'Wisdom Boots'
		$this.MapObjName         = 'wisdomboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of profound insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
