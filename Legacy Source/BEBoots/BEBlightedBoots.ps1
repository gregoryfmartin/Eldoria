using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLIGHTEDBOOTS
#
###############################################################################

Class BEBlightedBoots : BEBoots {
	BEBlightedBoots() : base() {
		$this.Name               = 'Blighted Boots'
		$this.MapObjName         = 'blightedboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots afflicted by a terrible curse.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
