using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CERBERUS SKULL HELM
#
###############################################################################

Class BECerberusSkullHelm : BEHelmet {
	BECerberusSkullHelm() : base() {
		$this.Name               = 'Cerberus Skull Helm'
		$this.MapObjName         = 'cerberusskullhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helm made from a cerberus skull, instilling terror.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
