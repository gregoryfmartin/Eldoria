using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANICHELM
#
###############################################################################

Class BEVolcanicHelm : BEHelmet {
	BEVolcanicHelm() : base() {
		$this.Name               = 'Volcanic Helm'
		$this.MapObjName         = 'volcanichelm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm forged in volcanic fire, granting resistance to heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
