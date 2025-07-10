using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEGENDARYHELM
#
###############################################################################

Class BELegendaryHelm : BEHelmet {
	BELegendaryHelm() : base() {
		$this.Name               = 'Legendary Helm'
		$this.MapObjName         = 'legendaryhelm'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from forgotten legends, imbued with immense, mysterious power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
