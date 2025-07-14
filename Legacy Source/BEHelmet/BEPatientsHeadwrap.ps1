using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPATIENTSHEADWRAP
#
###############################################################################

Class BEPatientsHeadwrap : BEHelmet {
	BEPatientsHeadwrap() : base() {
		$this.Name               = 'Patient''s Headwrap'
		$this.MapObjName         = 'patientsheadwrap'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A soft headwrap for patients, offering comfort.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
