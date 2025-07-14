using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSCALECAPE
#
###############################################################################

Class BEDragonscaleCape : BECape {
	BEDragonscaleCape() : base() {
		$this.Name               = 'Dragonscale Cape'
		$this.MapObjName         = 'dragonscalecape'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape crafted from the durable scales of a dragon.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
