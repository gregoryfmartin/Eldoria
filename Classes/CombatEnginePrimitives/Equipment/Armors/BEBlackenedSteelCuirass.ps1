using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLACKENEDSTEELCUIRASS
#
###############################################################################

Class BEBlackenedSteelCuirass : BEArmor {
	BEBlackenedSteelCuirass() : base() {
		$this.Name               = 'Blackened Steel Cuirass'
		$this.MapObjName         = 'blackenedsteelcuirass'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Steel cuirass treated to a dark, menacing finish.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
