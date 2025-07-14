using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANSRESOLVEGAUNTLETS
#
###############################################################################

Class BEGuardiansResolveGauntlets : BEGauntlets {
	BEGuardiansResolveGauntlets() : base() {
		$this.Name               = 'Guardian''s Resolve Gauntlets'
		$this.MapObjName         = 'guardiansresolvegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a guardian''s unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
