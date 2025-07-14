using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENBOOTS
#
###############################################################################

Class BEDwarvenBoots : BEBoots {
	BEDwarvenBoots() : base() {
		$this.Name               = 'Dwarven Boots'
		$this.MapObjName         = 'dwarvenboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Robust boots forged by dwarven artisans.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
