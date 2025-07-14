using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBSIDIANPLATE
#
###############################################################################

Class BEObsidianPlate : BEArmor {
	BEObsidianPlate() : base() {
		$this.Name               = 'Obsidian Plate'
		$this.MapObjName         = 'obsidianplate'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from solidified volcanic glass, very strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
