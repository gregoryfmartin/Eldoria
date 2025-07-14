using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENTRYBOOTS
#
###############################################################################

Class BESentryBoots : BEBoots {
	BESentryBoots() : base() {
		$this.Name               = 'Sentry Boots'
		$this.MapObjName         = 'sentryboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for watchful guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
