using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VETERAN'S HELM
#
###############################################################################

Class BEVeteransHelm : BEHelmet {
	BEVeteransHelm() : base() {
		$this.Name               = 'Veteran''s Helm'
		$this.MapObjName         = 'veteranshelm'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A battle-scarred helm worn by veterans, showing their experience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
