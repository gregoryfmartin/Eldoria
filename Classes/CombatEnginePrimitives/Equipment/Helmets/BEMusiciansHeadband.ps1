using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MUSICIAN'S HEADBAND
#
###############################################################################

Class BEMusiciansHeadband : BEHelmet {
	BEMusiciansHeadband() : base() {
		$this.Name               = 'Musician''s Headband'
		$this.MapObjName         = 'musiciansheadband'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband that helps musicians maintain rhythm and harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
