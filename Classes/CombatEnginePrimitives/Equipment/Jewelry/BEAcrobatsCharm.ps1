using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEACROBATSCHARM
#
###############################################################################

Class BEAcrobatsCharm : BEJewelry {
	BEAcrobatsCharm() : base() {
		$this.Name               = 'Acrobat''s Charm'
		$this.MapObjName         = 'acrobatscharm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small charm that aids in agility and balance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
