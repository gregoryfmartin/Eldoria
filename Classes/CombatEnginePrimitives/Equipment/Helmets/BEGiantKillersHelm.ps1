using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GIANT KILLER'S HELM
#
###############################################################################

Class BEGiantKillersHelm : BEHelmet {
	BEGiantKillersHelm() : base() {
		$this.Name               = 'Giant Killer''s Helm'
		$this.MapObjName         = 'giantkillershelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that enhances the wearer''s ability to fight giants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
