using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGODLYBOOTS
#
###############################################################################

Class BEGodlyBoots : BEBoots {
	BEGodlyBoots() : base() {
		$this.Name               = 'Godly Boots'
		$this.MapObjName         = 'godlyboots'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by deities, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
