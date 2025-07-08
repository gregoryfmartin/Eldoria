using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GUARDIANS HELM
#
###############################################################################

Class BEGuardiansHelm : BEHelmet {
	BEGuardiansHelm() : base() {
		$this.Name               = 'Guardian''s Helm'
		$this.MapObjName         = 'guardianshelm'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy, defensive helmet worn by guardians, deflecting blows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
