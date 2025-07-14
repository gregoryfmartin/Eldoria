using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDISCIPLINEGREAVES
#
###############################################################################

Class BEDisciplineGreaves : BEGreaves {
	BEDisciplineGreaves() : base() {
		$this.Name               = 'Discipline Greaves'
		$this.MapObjName         = 'disciplinegreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that promote self-control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
