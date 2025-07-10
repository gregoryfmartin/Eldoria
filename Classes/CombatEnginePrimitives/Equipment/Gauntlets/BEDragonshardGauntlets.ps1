using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSHARDGAUNTLETS
#
###############################################################################

Class BEDragonshardGauntlets : BEGauntlets {
	BEDragonshardGauntlets() : base() {
		$this.Name               = 'Dragonshard Gauntlets'
		$this.MapObjName         = 'dragonshardgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fragments of dragon shards, immensely powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
