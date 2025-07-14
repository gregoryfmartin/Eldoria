using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENGAUNTLETS
#
###############################################################################

Class BESunkenGauntlets : BEGauntlets {
	BESunkenGauntlets() : base() {
		$this.Name               = 'Sunken Gauntlets'
		$this.MapObjName         = 'sunkengauntlets'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Barnacle-encrusted gauntlets from a forgotten wreck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
