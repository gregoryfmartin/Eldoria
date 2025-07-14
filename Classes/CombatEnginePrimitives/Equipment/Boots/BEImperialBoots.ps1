using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIMPERIALBOOTS
#
###############################################################################

Class BEImperialBoots : BEBoots {
	BEImperialBoots() : base() {
		$this.Name               = 'Imperial Boots'
		$this.MapObjName         = 'imperialboots'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the imperial guard, highly polished.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
