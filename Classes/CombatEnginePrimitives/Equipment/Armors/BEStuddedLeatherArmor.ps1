using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTUDDEDLEATHERARMOR
#
###############################################################################

Class BEStuddedLeatherArmor : BEArmor {
	BEStuddedLeatherArmor() : base() {
		$this.Name               = 'Studded Leather Armor'
		$this.MapObjName         = 'studdedleatherarmor'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather armor reinforced with metal studs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
