using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHIELDMAIDENSPAULDRON
#
###############################################################################

Class BEShieldmaidensPauldron : BEPauldron {
	BEShieldmaidensPauldron() : base() {
		$this.Name               = 'Shieldmaiden''s Pauldron'
		$this.MapObjName         = 'shieldmaidenspauldron'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by fierce shieldmaidens, providing robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
