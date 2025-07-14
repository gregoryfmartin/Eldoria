using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALHANDGUARDS
#
###############################################################################

Class BEGlacialHandguards : BEGauntlets {
	BEGlacialHandguards() : base() {
		$this.Name               = 'Glacial Handguards'
		$this.MapObjName         = 'glacialhandguards'
		$this.PurchasePrice      = 740
		$this.SellPrice          = 370
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards emitting an icy aura, slowing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
