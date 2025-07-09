using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE COUNT'S HELMET
#
###############################################################################

Class BECountsHelmet : BEHelmet {
	BECountsHelmet() : base() {
		$this.Name               = 'Count''s Helmet'
		$this.MapObjName         = 'countshelmet'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted helmet worn by counts, symbolizing their standing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
