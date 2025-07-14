using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERECRUITERGREAVES
#
###############################################################################

Class BERecruiterGreaves : BEGreaves {
	BERecruiterGreaves() : base() {
		$this.Name               = 'Recruiter Greaves'
		$this.MapObjName         = 'recruitergreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for enlisting new members.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
