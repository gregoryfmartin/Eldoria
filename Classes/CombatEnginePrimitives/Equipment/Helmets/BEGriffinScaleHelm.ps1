using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GRIFFIN SCALE HELM
#
###############################################################################

Class BEGriffinScaleHelm : BEHelmet {
	BEGriffinScaleHelm() : base() {
		$this.Name               = 'Griffin Scale Helm'
		$this.MapObjName         = 'griffinscalehelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from griffin scales, offering light yet sturdy protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
