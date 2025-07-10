using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIRENSHEADBAND
#
###############################################################################

Class BESirensHeadband : BEHelmet {
	BESirensHeadband() : base() {
		$this.Name               = 'Siren''s Headband'
		$this.MapObjName         = 'sirensheadband'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering headband worn by sirens, subtly enhancing their enchanting voices.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
