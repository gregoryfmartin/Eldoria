using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONHIDEBOOTS
#
###############################################################################

Class BEDragonhideBoots : BEBoots {
	BEDragonhideBoots() : base() {
		$this.Name               = 'Dragonhide Boots'
		$this.MapObjName         = 'dragonhideboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from the tough hide of a dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
