using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMARSHALBOOTS
#
###############################################################################

Class BEMarshalBoots : BEBoots {
	BEMarshalBoots() : base() {
		$this.Name               = 'Marshal Boots'
		$this.MapObjName         = 'marshalboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a high-ranking law officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
