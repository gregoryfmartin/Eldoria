using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGODDESSSTOUCHGAUNTLETS
#
###############################################################################

Class BEGoddesssTouchGauntlets : BEGauntlets {
	BEGoddesssTouchGauntlets() : base() {
		$this.Name               = 'Goddess''s Touch Gauntlets'
		$this.MapObjName         = 'goddessstouchgauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be touched by a goddess, supreme defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
