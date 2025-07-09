using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LEVIATHAN SCALE HELM
#
###############################################################################

Class BELeviathanScaleHelm : BEHelmet {
	BELeviathanScaleHelm() : base() {
		$this.Name               = 'Leviathan Scale Helm'
		$this.MapObjName         = 'leviathanscalehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm made from leviathan scales, offering immense protection in water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
