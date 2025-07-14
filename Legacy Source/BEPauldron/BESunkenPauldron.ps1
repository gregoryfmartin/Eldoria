using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENPAULDRON
#
###############################################################################

Class BESunkenPauldron : BEPauldron {
	BESunkenPauldron() : base() {
		$this.Name               = 'Sunken Pauldron'
		$this.MapObjName         = 'sunkenpauldron'
		$this.PurchasePrice      = 4100
		$this.SellPrice          = 2050
		$this.TargetStats        = @{
			[StatId]::Defense = 82
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Waterlogged but incredibly resilient, carries the scent of the ocean.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
