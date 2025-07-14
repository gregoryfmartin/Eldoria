using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMTHORNHELM
#
###############################################################################

Class BEDreamthornHelm : BEHelmet {
	BEDreamthornHelm() : base() {
		$this.Name               = 'Dreamthorn Helm'
		$this.MapObjName         = 'dreamthornhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with sharp, dream-infused thorns, inflicting nightmares on enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
