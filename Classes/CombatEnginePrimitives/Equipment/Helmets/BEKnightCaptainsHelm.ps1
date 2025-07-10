using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTCAPTAINSHELM
#
###############################################################################

Class BEKnightCaptainsHelm : BEHelmet {
	BEKnightCaptainsHelm() : base() {
		$this.Name               = 'Knight-Captain''s Helm'
		$this.MapObjName         = 'knightcaptainshelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A distinguished helm worn by knight-captains, leading their brethren.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
