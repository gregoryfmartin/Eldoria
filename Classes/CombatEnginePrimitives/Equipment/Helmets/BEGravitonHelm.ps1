using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVITONHELM
#
###############################################################################

Class BEGravitonHelm : BEHelmet {
	BEGravitonHelm() : base() {
		$this.Name               = 'Graviton Helm'
		$this.MapObjName         = 'gravitonhelm'
		$this.PurchasePrice      = 5200
		$this.SellPrice          = 2600
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that manipulates gravity, allowing the wearer to float or crush foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
