using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDOCTORSHEADMIRROR
#
###############################################################################

Class BEDoctorsHeadMirror : BEHelmet {
	BEDoctorsHeadMirror() : base() {
		$this.Name               = 'Doctor''s Head Mirror'
		$this.MapObjName         = 'doctorsheadmirror'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reflective mirror worn by doctors, aiding in examinations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
