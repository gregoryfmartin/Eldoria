using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE INFERNO AXE
#
###############################################################################

Class BEInfernoAxe : BEWeapon {
	BEInfernoAxe() : base() {
		$this.Name          = 'Inferno Axe'
		$this.MapObjName    = 'infernoaxe'
		$this.PurchasePrice = 4800
		$this.SellPrice     = 2400
		$this.TargetStats   = @{
			[StatId]::Attack      = 120
			[StatId]::MagicAttack = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An axe wreathed in eternal flames, burning all it touches.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
