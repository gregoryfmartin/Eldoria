using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUNGLEHUNTERPAULDRON
#
###############################################################################

Class BEJungleHunterPauldron : BEPauldron {
	BEJungleHunterPauldron() : base() {
		$this.Name               = 'Jungle Hunter Pauldron'
		$this.MapObjName         = 'junglehunterpauldron'
		$this.PurchasePrice      = 8600
		$this.SellPrice          = 4300
		$this.TargetStats        = @{
			[StatId]::Defense = 172
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends seamlessly with dense foliage, aiding ambushes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
