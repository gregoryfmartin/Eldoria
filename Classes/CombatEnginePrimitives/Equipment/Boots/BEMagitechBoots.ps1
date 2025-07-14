using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGITECHBOOTS
#
###############################################################################

Class BEMagitechBoots : BEBoots {
	BEMagitechBoots() : base() {
		$this.Name               = 'Magitech Boots'
		$this.MapObjName         = 'magitechboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots combining magic and technology.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
