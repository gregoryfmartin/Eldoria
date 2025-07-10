using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMMANDOGREAVES
#
###############################################################################

Class BECommandoGreaves : BEGreaves {
	BECommandoGreaves() : base() {
		$this.Name               = 'Commando Greaves'
		$this.MapObjName         = 'commandogreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for elite fighting units.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
