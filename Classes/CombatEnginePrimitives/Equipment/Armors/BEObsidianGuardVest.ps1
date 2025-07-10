using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBSIDIANGUARDVEST
#
###############################################################################

Class BEObsidianGuardVest : BEArmor {
	BEObsidianGuardVest() : base() {
		$this.Name               = 'Obsidian Guard Vest'
		$this.MapObjName         = 'obsidianguardvest'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest reinforced with shards of obsidian, offering sharp defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
