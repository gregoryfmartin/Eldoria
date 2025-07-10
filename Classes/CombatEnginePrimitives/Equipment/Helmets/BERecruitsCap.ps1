using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERECRUITSCAP
#
###############################################################################

Class BERecruitsCap : BEHelmet {
	BERecruitsCap() : base() {
		$this.Name               = 'Recruit''s Cap'
		$this.MapObjName         = 'recruitscap'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic cap given to new recruits, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
