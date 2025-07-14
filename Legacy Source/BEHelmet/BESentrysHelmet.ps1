using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTRYSHELMET
#
###############################################################################

Class BESentrysHelmet : BEHelmet {
	BESentrysHelmet() : base() {
		$this.Name               = 'Sentry''s Helmet'
		$this.MapObjName         = 'sentryshelmet'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard helmet for sentries, providing reliable protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
