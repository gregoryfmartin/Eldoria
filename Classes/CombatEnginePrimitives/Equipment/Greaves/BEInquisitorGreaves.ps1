using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINQUISITORGREAVES
#
###############################################################################

Class BEInquisitorGreaves : BEGreaves {
	BEInquisitorGreaves() : base() {
		$this.Name               = 'Inquisitor Greaves'
		$this.MapObjName         = 'inquisitorgreaves'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for those who seek out heresy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
