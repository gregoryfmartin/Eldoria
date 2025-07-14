using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROGUECAPE
#
###############################################################################

Class BERogueCape : BECape {
	BERogueCape() : base() {
		$this.Name               = 'Rogue Cape'
		$this.MapObjName         = 'roguecape'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cape, ideal for blending into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
