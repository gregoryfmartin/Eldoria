using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNALGRIPS
#
###############################################################################

Class BEInfernalGrips : BEGauntlets {
	BEInfernalGrips() : base() {
		$this.Name               = 'Infernal Grips'
		$this.MapObjName         = 'infernalgrips'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that burn with a malevolent fire, searing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
