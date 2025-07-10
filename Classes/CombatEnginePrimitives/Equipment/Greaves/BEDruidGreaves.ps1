using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRUIDGREAVES
#
###############################################################################

Class BEDruidGreaves : BEGreaves {
	BEDruidGreaves() : base() {
		$this.Name               = 'Druid Greaves'
		$this.MapObjName         = 'druidgreaves'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves made from natural materials, attuned to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
