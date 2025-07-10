using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIERWINDCAPE
#
###############################################################################

Class BEGlacierwindCape : BECape {
	BEGlacierwindCape() : base() {
		$this.Name               = 'Glacierwind Cape'
		$this.MapObjName         = 'glacierwindcape'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that feels perpetually cold, offering resistance to heat.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
