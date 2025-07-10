using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE INNKEEPER'S HEADBAND
#
###############################################################################

Class BEInnkeepersHeadband : BEHelmet {
	BEInnkeepersHeadband() : base() {
		$this.Name               = 'Innkeeper''s Headband'
		$this.MapObjName         = 'innkeepersheadband'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by innkeepers, offering a welcoming demeanor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
