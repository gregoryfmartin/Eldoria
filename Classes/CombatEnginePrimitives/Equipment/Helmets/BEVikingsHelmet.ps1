using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VIKINGS HELMET
#
###############################################################################

Class BEVikingsHelmet : BEHelmet {
	BEVikingsHelmet() : base() {
		$this.Name               = 'Viking''s Helmet'
		$this.MapObjName         = 'vikingshelmet'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A horned helmet worn by fierce Viking warriors, inspiring dread.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
