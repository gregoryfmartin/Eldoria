using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPRESSSPAULDRON
#
###############################################################################

Class BEEmpresssPauldron : BEPauldron {
	BEEmpresssPauldron() : base() {
		$this.Name               = 'Empress''s Pauldron'
		$this.MapObjName         = 'empressspauldron'
		$this.PurchasePrice      = 9550
		$this.SellPrice          = 4775
		$this.TargetStats        = @{
			[StatId]::Defense = 191
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Elegant and formidable, worn by powerful female monarchs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
