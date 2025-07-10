using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIERYHELM
#
###############################################################################

Class BEFieryHelm : BEHelmet {
	BEFieryHelm() : base() {
		$this.Name               = 'Fiery Helm'
		$this.MapObjName         = 'fieryhelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm wreathed in eternal flames, burning enemies on contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
