using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUEENSGUARDPAULDRON
#
###############################################################################

Class BEQueensGuardPauldron : BEPauldron {
	BEQueensGuardPauldron() : base() {
		$this.Name               = 'Queen''s Guard Pauldron'
		$this.MapObjName         = 'queensguardpauldron'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Elegant yet strong, worn by the elite protectors of the queen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
