using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENSILVERGAUNTLETS
#
###############################################################################

Class BESunkenSilverGauntlets : BEGauntlets {
	BESunkenSilverGauntlets() : base() {
		$this.Name               = 'Sunken Silver Gauntlets'
		$this.MapObjName         = 'sunkensilvergauntlets'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silver gauntlets recovered from a sunken ship, glimmering.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
