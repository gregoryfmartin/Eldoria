using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAMURAIARMOR
#
###############################################################################

Class BESamuraiArmor : BEArmor {
	BESamuraiArmor() : base() {
		$this.Name               = 'Samurai Armor'
		$this.MapObjName         = 'samuraiarmor'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Intricate and strong armor, balanced for offense and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
