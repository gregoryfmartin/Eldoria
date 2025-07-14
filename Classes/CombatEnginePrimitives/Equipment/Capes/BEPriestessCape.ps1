using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTESSCAPE
#
###############################################################################

Class BEPriestessCape : BECape {
	BEPriestessCape() : base() {
		$this.Name               = 'Priestess Cape'
		$this.MapObjName         = 'priestesscape'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure white cape, imbued with a gentle blessing.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}
