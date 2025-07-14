using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLHELM
#
###############################################################################

Class BEStarfallHelm : BEHelmet {
	BEStarfallHelm() : base() {
		$this.Name               = 'Starfall Helm'
		$this.MapObjName         = 'starfallhelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm said to be forged from fallen stars, possessing cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
