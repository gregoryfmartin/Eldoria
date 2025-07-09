using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GRIFFIN RIDERS HELM
#
###############################################################################

Class BEGriffinRidersHelm : BEHelmet {
	BEGriffinRidersHelm() : base() {
		$this.Name               = 'Griffin Rider''s Helm'
		$this.MapObjName         = 'griffinridershelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A specialized helm for riders of griffins, designed for aerial combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
