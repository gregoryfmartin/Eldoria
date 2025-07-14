using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIMEWEAVERSHOOD
#
###############################################################################

Class BETimeWeaversHood : BEHelmet {
	BETimeWeaversHood() : base() {
		$this.Name               = 'Time Weaver''s Hood'
		$this.MapObjName         = 'timeweavershood'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that allows the wearer to subtly manipulate the flow of time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
