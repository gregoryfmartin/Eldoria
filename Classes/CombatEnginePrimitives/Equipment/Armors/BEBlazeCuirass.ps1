using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLAZECUIRASS
#
###############################################################################

Class BEBlazeCuirass : BEArmor {
	BEBlazeCuirass() : base() {
		$this.Name               = 'Blaze Cuirass'
		$this.MapObjName         = 'blazecuirass'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass imbued with fire magic, protecting against heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
