using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDOOMBRINGER
#
###############################################################################

Class BEDoomBringer : BEWeapon {
	BEDoomBringer() : base() {
		$this.Name          = 'Doom Bringer'
		$this.MapObjName    = 'doombringer'
		$this.PurchasePrice = 6600
		$this.SellPrice     = 3300
		$this.TargetStats   = @{
			[StatId]::Attack = 170
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying weapon that instills fear and despair in all who face it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
