using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEWORNTUNIC
#
###############################################################################

Class BEBattleWornTunic : BEArmor {
	BEBattleWornTunic() : base() {
		$this.Name               = 'Battle-Worn Tunic'
		$this.MapObjName         = 'battleworntunic'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A torn but resilient tunic, seen many skirmishes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
