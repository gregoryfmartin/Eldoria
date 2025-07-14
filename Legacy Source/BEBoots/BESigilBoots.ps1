using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIGILBOOTS
#
###############################################################################

Class BESigilBoots : BEBoots {
	BESigilBoots() : base() {
		$this.Name               = 'Sigil Boots'
		$this.MapObjName         = 'sigilboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots bearing potent magical sigils.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
