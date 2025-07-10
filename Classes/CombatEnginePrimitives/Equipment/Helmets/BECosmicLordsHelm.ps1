using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICLORDSHELM
#
###############################################################################

Class BECosmicLordsHelm : BEHelmet {
	BECosmicLordsHelm() : base() {
		$this.Name               = 'Cosmic Lord''s Helm'
		$this.MapObjName         = 'cosmiclordshelm'
		$this.PurchasePrice      = 20000
		$this.SellPrice          = 10000
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants dominion over both time and space, truly omnipotent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
