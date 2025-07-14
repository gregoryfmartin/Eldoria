using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIMPERIALGREAVES
#
###############################################################################

Class BEImperialGreaves : BEGreaves {
	BEImperialGreaves() : base() {
		$this.Name               = 'Imperial Greaves'
		$this.MapObjName         = 'imperialgreaves'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of the imperial guard, highly polished.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
