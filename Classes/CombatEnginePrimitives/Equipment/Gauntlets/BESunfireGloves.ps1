using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNFIREGLOVES
#
###############################################################################

Class BESunfireGloves : BEGauntlets {
	BESunfireGloves() : base() {
		$this.Name               = 'Sunfire Gloves'
		$this.MapObjName         = 'sunfiregloves'
		$this.PurchasePrice      = 510
		$this.SellPrice          = 255
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that radiate soft warmth, comforting and protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
