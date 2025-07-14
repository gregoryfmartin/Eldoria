using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFEYIRONGAUNTLETS
#
###############################################################################

Class BEFeyIronGauntlets : BEGauntlets {
	BEFeyIronGauntlets() : base() {
		$this.Name               = 'Fey Iron Gauntlets'
		$this.MapObjName         = 'feyirongauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from special Fey iron, resistant to magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
