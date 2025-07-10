using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECENTAURBOOTS
#
###############################################################################

Class BECentaurBoots : BEBoots {
	BECentaurBoots() : base() {
		$this.Name               = 'Centaur Boots'
		$this.MapObjName         = 'centaurboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for equestrian warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
