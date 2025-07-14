using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREALITYANCHORHELM
#
###############################################################################

Class BERealityAnchorHelm : BEHelmet {
	BERealityAnchorHelm() : base() {
		$this.Name               = 'Reality Anchor Helm'
		$this.MapObjName         = 'realityanchorhelm'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that anchors the wearer to reality, preventing temporal or dimensional displacement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
