using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYRMFANGGAUNTLETS
#
###############################################################################

Class BEWyrmfangGauntlets : BEGauntlets {
	BEWyrmfangGauntlets() : base() {
		$this.Name               = 'Wyrmfang Gauntlets'
		$this.MapObjName         = 'wyrmfanggauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets tipped with the fangs of a juvenile wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
