using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CLERICS COIF
#
###############################################################################

Class BEClericsCoif : BEHelmet {
	BEClericsCoif() : base() {
		$this.Name               = 'Cleric''s Coif'
		$this.MapObjName         = 'clericscoif'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple coif worn by clerics, providing modest protection and spiritual focus.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
