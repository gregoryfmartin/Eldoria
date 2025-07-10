using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTUDDEDLEATHERGAUNTLETS
#
###############################################################################

Class BEStuddedLeatherGauntlets : BEGauntlets {
	BEStuddedLeatherGauntlets() : base() {
		$this.Name               = 'Studded Leather Gauntlets'
		$this.MapObjName         = 'studdedleathergauntlets'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets with small metal studs for added defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
