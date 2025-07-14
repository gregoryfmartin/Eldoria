using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIERCORE
#
###############################################################################

Class BEGlacierCore : BEJewelry {
	BEGlacierCore() : base() {
		$this.Name               = 'Glacier Core'
		$this.MapObjName         = 'glaciercore'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard of eternal ice, chilling to the bone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
