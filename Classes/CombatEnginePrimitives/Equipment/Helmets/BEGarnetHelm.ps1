using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARNETHELM
#
###############################################################################

Class BEGarnetHelm : BEHelmet {
	BEGarnetHelm() : base() {
		$this.Name               = 'Garnet Helm'
		$this.MapObjName         = 'garnethelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a deep red garnet, boosting vitality and inner strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
