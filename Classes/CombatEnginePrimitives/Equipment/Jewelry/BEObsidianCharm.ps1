using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBSIDIANCHARM
#
###############################################################################

Class BEObsidianCharm : BEJewelry {
	BEObsidianCharm() : base() {
		$this.Name               = 'Obsidian Charm'
		$this.MapObjName         = 'obsidiancharm'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A black obsidian charm, absorbing dark energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
