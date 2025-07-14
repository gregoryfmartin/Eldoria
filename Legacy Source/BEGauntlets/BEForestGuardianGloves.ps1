using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTGUARDIANGLOVES
#
###############################################################################

Class BEForestGuardianGloves : BEGauntlets {
	BEForestGuardianGloves() : base() {
		$this.Name               = 'Forest Guardian Gloves'
		$this.MapObjName         = 'forestguardiangloves'
		$this.PurchasePrice      = 310
		$this.SellPrice          = 155
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from forest materials, blending with nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
