using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERLEAFGLOVES
#
###############################################################################

Class BESilverleafGloves : BEGauntlets {
	BESilverleafGloves() : base() {
		$this.Name               = 'Silverleaf Gloves'
		$this.MapObjName         = 'silverleafgloves'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from mystical silverleaf, light and protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
