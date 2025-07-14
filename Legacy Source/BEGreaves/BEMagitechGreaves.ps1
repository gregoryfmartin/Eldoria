using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAGITECHGREAVES
#
###############################################################################

Class BEMagitechGreaves : BEGreaves {
	BEMagitechGreaves() : base() {
		$this.Name               = 'Magitech Greaves'
		$this.MapObjName         = 'magitechgreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves combining magic and technology.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
