using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINHIDETUNIC
#
###############################################################################

Class BEGoblinHideTunic : BEArmor {
	BEGoblinHideTunic() : base() {
		$this.Name               = 'Goblin Hide Tunic'
		$this.MapObjName         = 'goblinhidetunic'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude tunic made from goblin hides, smells faintly of swamp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
