using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTPAULDRON
#
###############################################################################

Class BEAdamantPauldron : BEPauldron {
	BEAdamantPauldron() : base() {
		$this.Name               = 'Adamant Pauldron'
		$this.MapObjName         = 'adamantpauldron'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Legendary metal pauldron, offering immense protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
