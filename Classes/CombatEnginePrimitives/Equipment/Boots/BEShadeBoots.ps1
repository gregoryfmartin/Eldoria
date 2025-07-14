using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADEBOOTS
#
###############################################################################

Class BEShadeBoots : BEBoots {
	BEShadeBoots() : base() {
		$this.Name               = 'Shade Boots'
		$this.MapObjName         = 'shadeboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a shadowy entity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
