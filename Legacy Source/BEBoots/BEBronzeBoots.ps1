using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRONZEBOOTS
#
###############################################################################

Class BEBronzeBoots : BEBoots {
	BEBronzeBoots() : base() {
		$this.Name               = 'Bronze Boots'
		$this.MapObjName         = 'bronzeboots'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy bronze boots, providing decent foot protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
