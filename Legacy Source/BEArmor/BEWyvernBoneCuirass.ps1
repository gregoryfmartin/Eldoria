using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNBONECUIRASS
#
###############################################################################

Class BEWyvernBoneCuirass : BEArmor {
	BEWyvernBoneCuirass() : base() {
		$this.Name               = 'Wyvern Bone Cuirass'
		$this.MapObjName         = 'wyvernbonecuirass'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass crafted from the bones of a wyvern, lightweight yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
