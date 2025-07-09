using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CHIMERA HORN HELM
#
###############################################################################

Class BEChimeraHornHelm : BEHelmet {
	BEChimeraHornHelm() : base() {
		$this.Name               = 'Chimera Horn Helm'
		$this.MapObjName         = 'chimerahornhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm adorned with chimera horns, embodying the ferocity of multiple beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
