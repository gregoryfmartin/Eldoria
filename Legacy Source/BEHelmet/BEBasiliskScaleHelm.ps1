using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBASILISKSCALEHELM
#
###############################################################################

Class BEBasiliskScaleHelm : BEHelmet {
	BEBasiliskScaleHelm() : base() {
		$this.Name               = 'Basilisk Scale Helm'
		$this.MapObjName         = 'basiliskscalehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from basilisk scales, offering resistance to petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
