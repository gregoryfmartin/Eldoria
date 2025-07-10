using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESINGERSVOICECHARM
#
###############################################################################

Class BESingersVoiceCharm : BEJewelry {
	BESingersVoiceCharm() : base() {
		$this.Name               = 'Singer''s Voice Charm'
		$this.MapObjName         = 'singersvoicecharm'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that subtly enhances the voice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
