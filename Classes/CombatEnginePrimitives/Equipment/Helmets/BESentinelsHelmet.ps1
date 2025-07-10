using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTINELSHELMET
#
###############################################################################

Class BESentinelsHelmet : BEHelmet {
	BESentinelsHelmet() : base() {
		$this.Name               = 'Sentinel''s Helmet'
		$this.MapObjName         = 'sentinelshelmet'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, defensive helmet worn by vigilant sentinels, guarding key locations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
