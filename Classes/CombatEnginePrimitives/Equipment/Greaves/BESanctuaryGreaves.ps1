using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESANCTUARYGREAVES
#
###############################################################################

Class BESanctuaryGreaves : BEGreaves {
	BESanctuaryGreaves() : base() {
		$this.Name               = 'Sanctuary Greaves'
		$this.MapObjName         = 'sanctuarygreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that offer a sense of peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
