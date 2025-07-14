using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAKEHIDEGLOVES
#
###############################################################################

Class BEDrakehideGloves : BEGauntlets {
	BEDrakehideGloves() : base() {
		$this.Name               = 'Drakehide Gloves'
		$this.MapObjName         = 'drakehidegloves'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from the hide of a young drake, flexible and tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
