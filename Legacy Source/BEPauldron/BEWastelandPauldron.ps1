using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWASTELANDPAULDRON
#
###############################################################################

Class BEWastelandPauldron : BEPauldron {
	BEWastelandPauldron() : base() {
		$this.Name               = 'Wasteland Pauldron'
		$this.MapObjName         = 'wastelandpauldron'
		$this.PurchasePrice      = 2450
		$this.SellPrice          = 1225
		$this.TargetStats        = @{
			[StatId]::Defense = 49
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Salvaged and reinforced, offering protection in desolate lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
