using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICWANDERERSHOOD
#
###############################################################################

Class BECosmicWanderersHood : BEHelmet {
	BECosmicWanderersHood() : base() {
		$this.Name               = 'Cosmic Wanderer''s Hood'
		$this.MapObjName         = 'cosmicwanderershood'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood that aids wanderers across the cosmos, protecting them from stellar energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
