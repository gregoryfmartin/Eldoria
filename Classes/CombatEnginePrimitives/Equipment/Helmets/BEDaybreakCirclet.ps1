using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DAYBREAK CIRCLET
#
###############################################################################

Class BEDaybreakCirclet : BEHelmet {
	BEDaybreakCirclet() : base() {
		$this.Name               = 'Daybreak Circlet'
		$this.MapObjName         = 'daybreakcirclet'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant circlet that harnesses the power of the rising sun, dispelling darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
