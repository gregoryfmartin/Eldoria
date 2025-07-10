using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLAGUEDOCTORSCOAT
#
###############################################################################

Class BEPlagueDoctorsCoat : BEArmor {
	BEPlagueDoctorsCoat() : base() {
		$this.Name               = 'Plague Doctor''s Coat'
		$this.MapObjName         = 'plaguedoctorscoat'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A long, thick coat offering protection against miasma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
