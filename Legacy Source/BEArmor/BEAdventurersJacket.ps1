using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADVENTURERSJACKET
#
###############################################################################

Class BEAdventurersJacket : BEArmor {
	BEAdventurersJacket() : base() {
		$this.Name               = 'Adventurer''s Jacket'
		$this.MapObjName         = 'adventurersjacket'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A versatile jacket with many pockets, good for general exploration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
