using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEACOLYTESROBE
#
###############################################################################

Class BEAcolytesRobe : BEArmor {
	BEAcolytesRobe() : base() {
		$this.Name               = 'Acolyte''s Robe'
		$this.MapObjName         = 'acolytesrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solemn robe worn by those devoted to ancient deities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
