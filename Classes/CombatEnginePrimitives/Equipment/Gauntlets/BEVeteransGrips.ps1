using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVETERANSGRIPS
#
###############################################################################

Class BEVeteransGrips : BEGauntlets {
	BEVeteransGrips() : base() {
		$this.Name               = 'Veteran''s Grips'
		$this.MapObjName         = 'veteransgrips'
		$this.PurchasePrice      = 410
		$this.SellPrice          = 205
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Well-worn gauntlets of an experienced fighter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
