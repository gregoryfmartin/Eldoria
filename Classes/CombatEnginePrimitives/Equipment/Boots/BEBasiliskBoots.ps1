using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBASILISKBOOTS
#
###############################################################################

Class BEBasiliskBoots : BEBoots {
	BEBasiliskBoots() : base() {
		$this.Name               = 'Basilisk Boots'
		$this.MapObjName         = 'basiliskboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from basilisk hide, resistant to petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
