using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMARSHALGREAVES
#
###############################################################################

Class BEMarshalGreaves : BEGreaves {
	BEMarshalGreaves() : base() {
		$this.Name               = 'Marshal Greaves'
		$this.MapObjName         = 'marshalgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a high-ranking law officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
