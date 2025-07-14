using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIGHTFORGEDHELM
#
###############################################################################

Class BELightforgedHelm : BEHelmet {
	BELightforgedHelm() : base() {
		$this.Name               = 'Lightforged Helm'
		$this.MapObjName         = 'lightforgedhelm'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged with holy light, devastating to dark creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
