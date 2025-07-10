using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKRAKENBOOTS
#
###############################################################################

Class BEKrakenBoots : BEBoots {
	BEKrakenBoots() : base() {
		$this.Name               = 'Kraken Boots'
		$this.MapObjName         = 'krakenboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from the depths, granting water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
