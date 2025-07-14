using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTRYGREAVES
#
###############################################################################

Class BESentryGreaves : BEGreaves {
	BESentryGreaves() : base() {
		$this.Name               = 'Sentry Greaves'
		$this.MapObjName         = 'sentrygreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for watchful guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
