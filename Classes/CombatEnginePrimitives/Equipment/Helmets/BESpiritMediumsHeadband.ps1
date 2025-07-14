using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITMEDIUMSHEADBAND
#
###############################################################################

Class BESpiritMediumsHeadband : BEHelmet {
	BESpiritMediumsHeadband() : base() {
		$this.Name               = 'Spirit Medium''s Headband'
		$this.MapObjName         = 'spiritmediumsheadband'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids spirit mediums in communicating with the deceased.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
