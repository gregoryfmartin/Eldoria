using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGISTRATEBOOTS
#
###############################################################################

Class BEMagistrateBoots : BEBoots {
	BEMagistrateBoots() : base() {
		$this.Name               = 'Magistrate Boots'
		$this.MapObjName         = 'magistrateboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a civil officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
