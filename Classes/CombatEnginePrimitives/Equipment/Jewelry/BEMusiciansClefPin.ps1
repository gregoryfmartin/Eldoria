using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMUSICIANSCLEFPIN
#
###############################################################################

Class BEMusiciansClefPin : BEJewelry {
	BEMusiciansClefPin() : base() {
		$this.Name               = 'Musician''s Clef Pin'
		$this.MapObjName         = 'musiciansclefpin'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a musical clef, for harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
