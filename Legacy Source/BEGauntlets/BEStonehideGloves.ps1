using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTONEHIDEGLOVES
#
###############################################################################

Class BEStonehideGloves : BEGauntlets {
	BEStonehideGloves() : base() {
		$this.Name               = 'Stonehide Gloves'
		$this.MapObjName         = 'stonehidegloves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from petrified animal hide, surprisingly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
