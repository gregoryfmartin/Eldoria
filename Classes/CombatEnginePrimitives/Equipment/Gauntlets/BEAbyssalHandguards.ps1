using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALHANDGUARDS
#
###############################################################################

Class BEAbyssalHandguards : BEGauntlets {
	BEAbyssalHandguards() : base() {
		$this.Name               = 'Abyssal Handguards'
		$this.MapObjName         = 'abyssalhandguards'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 98
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards from the deepest, darkest pits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
