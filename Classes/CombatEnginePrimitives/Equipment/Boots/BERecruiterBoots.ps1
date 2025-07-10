using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERECRUITERBOOTS
#
###############################################################################

Class BERecruiterBoots : BEBoots {
	BERecruiterBoots() : base() {
		$this.Name               = 'Recruiter Boots'
		$this.MapObjName         = 'recruiterboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for enlisting new members.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
