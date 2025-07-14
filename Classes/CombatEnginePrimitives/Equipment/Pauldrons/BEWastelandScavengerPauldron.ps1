using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWASTELANDSCAVENGERPAULDRON
#
###############################################################################

Class BEWastelandScavengerPauldron : BEPauldron {
	BEWastelandScavengerPauldron() : base() {
		$this.Name               = 'Wasteland Scavenger Pauldron'
		$this.MapObjName         = 'wastelandscavengerpauldron'
		$this.PurchasePrice      = 8950
		$this.SellPrice          = 4475
		$this.TargetStats        = @{
			[StatId]::Defense = 179
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Patchwork but resilient, for surviving harsh, desolate lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
