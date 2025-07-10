using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTWEAVECAPE
#
###############################################################################

Class BEStarlightWeaveCape : BECape {
	BEStarlightWeaveCape() : base() {
		$this.Name               = 'Starlight Weave Cape'
		$this.MapObjName         = 'starlightweavecape'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape woven from threads infused with starlight, subtly enhancing luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
