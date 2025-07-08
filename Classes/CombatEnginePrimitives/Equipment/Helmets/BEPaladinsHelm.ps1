using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE PALADINS HELM
#
###############################################################################

Class BEPaladinsHelm : BEHelmet {
	BEPaladinsHelm() : base() {
		$this.Name               = 'Paladin''s Helm'
		$this.MapObjName         = 'paladinshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gleaming helmet worn by holy warriors, radiating divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
