using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBSIDIANCUIRASS
#
###############################################################################

Class BEObsidianCuirass : BEArmor {
	BEObsidianCuirass() : base() {
		$this.Name               = 'Obsidian Cuirass'
		$this.MapObjName         = 'obsidiancuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass carved from pure obsidian, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
