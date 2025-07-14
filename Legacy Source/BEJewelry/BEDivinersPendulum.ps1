using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINERSPENDULUM
#
###############################################################################

Class BEDivinersPendulum : BEJewelry {
	BEDivinersPendulum() : base() {
		$this.Name               = 'Diviner''s Pendulum'
		$this.MapObjName         = 'divinerspendulum'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pendulum that sways to reveal truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
