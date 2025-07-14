using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOBSIDIANFISTS
#
###############################################################################

Class BEObsidianFists : BEGauntlets {
	BEObsidianFists() : base() {
		$this.Name               = 'Obsidian Fists'
		$this.MapObjName         = 'obsidianfists'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from volcanic obsidian, sharp and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
