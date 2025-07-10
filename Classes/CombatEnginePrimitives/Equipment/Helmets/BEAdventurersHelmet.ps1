using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADVENTURERSHELMET
#
###############################################################################

Class BEAdventurersHelmet : BEHelmet {
	BEAdventurersHelmet() : base() {
		$this.Name               = 'Adventurer''s Helmet'
		$this.MapObjName         = 'adventurershelmet'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reliable helmet for any adventurer, offering balanced protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
