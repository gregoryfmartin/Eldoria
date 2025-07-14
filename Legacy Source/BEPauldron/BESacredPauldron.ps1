using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESACREDPAULDRON
#
###############################################################################

Class BESacredPauldron : BEPauldron {
	BESacredPauldron() : base() {
		$this.Name               = 'Sacred Pauldron'
		$this.MapObjName         = 'sacredpauldron'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed by divine power, offering protection against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
