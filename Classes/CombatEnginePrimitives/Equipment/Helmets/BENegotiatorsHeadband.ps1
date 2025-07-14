using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEGOTIATORSHEADBAND
#
###############################################################################

Class BENegotiatorsHeadband : BEHelmet {
	BENegotiatorsHeadband() : base() {
		$this.Name               = 'Negotiator''s Headband'
		$this.MapObjName         = 'negotiatorsheadband'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that aids negotiators in finding common ground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
