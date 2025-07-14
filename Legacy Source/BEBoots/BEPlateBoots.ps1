using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLATEBOOTS
#
###############################################################################

Class BEPlateBoots : BEBoots {
	BEPlateBoots() : base() {
		$this.Name               = 'Plate Boots'
		$this.MapObjName         = 'plateboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Full plate foot armor, excellent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
