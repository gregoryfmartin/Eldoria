using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ZOOLOGIST'S HEADBAND
#
###############################################################################

Class BEZoologistsHeadband : BEHelmet {
	BEZoologistsHeadband() : base() {
		$this.Name               = 'Zoologist''s Headband'
		$this.MapObjName         = 'zoologistsheadband'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids zoologists in understanding animal behavior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
