using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICESRUNEBANDS
#
###############################################################################

Class BEApprenticesRunebands : BEGauntlets {
	BEApprenticesRunebands() : base() {
		$this.Name               = 'Apprentice''s Runebands'
		$this.MapObjName         = 'apprenticesrunebands'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic runebands for a magic apprentice, aiding their studies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
