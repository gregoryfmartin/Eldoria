using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXWINGCAPE
#
###############################################################################

Class BEPhoenixwingCape : BECape {
	BEPhoenixwingCape() : base() {
		$this.Name               = 'Phoenixwing Cape'
		$this.MapObjName         = 'phoenixwingcape'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape made from the vibrant feathers of a phoenix, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
