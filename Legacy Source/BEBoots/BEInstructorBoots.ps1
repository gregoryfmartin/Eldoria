using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINSTRUCTORBOOTS
#
###############################################################################

Class BEInstructorBoots : BEBoots {
	BEInstructorBoots() : base() {
		$this.Name               = 'Instructor Boots'
		$this.MapObjName         = 'instructorboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for teaching new techniques.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
