using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNBOOTS
#
###############################################################################

Class BEWyvernBoots : BEBoots {
	BEWyvernBoots() : base() {
		$this.Name               = 'Wyvern Boots'
		$this.MapObjName         = 'wyvernboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from wyvern scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
