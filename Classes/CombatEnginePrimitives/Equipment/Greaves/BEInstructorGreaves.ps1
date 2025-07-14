using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINSTRUCTORGREAVES
#
###############################################################################

Class BEInstructorGreaves : BEGreaves {
	BEInstructorGreaves() : base() {
		$this.Name               = 'Instructor Greaves'
		$this.MapObjName         = 'instructorgreaves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for teaching new techniques.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
