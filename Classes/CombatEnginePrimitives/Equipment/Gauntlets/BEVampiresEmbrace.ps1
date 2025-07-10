using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIRESEMBRACE
#
###############################################################################

Class BEVampiresEmbrace : BEGauntlets {
	BEVampiresEmbrace() : base() {
		$this.Name               = 'Vampire''s Embrace'
		$this.MapObjName         = 'vampiresembrace'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to drain life from enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
