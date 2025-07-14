using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPERSEVERANCEGREAVES
#
###############################################################################

Class BEPerseveranceGreaves : BEGreaves {
	BEPerseveranceGreaves() : base() {
		$this.Name               = 'Perseverance Greaves'
		$this.MapObjName         = 'perseverancegreaves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that encourage persistence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
