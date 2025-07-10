using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEICYHELM
#
###############################################################################

Class BEIcyHelm : BEHelmet {
	BEIcyHelm() : base() {
		$this.Name               = 'Icy Helm'
		$this.MapObjName         = 'icyhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm covered in permafrost, freezing enemies with each blow.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
