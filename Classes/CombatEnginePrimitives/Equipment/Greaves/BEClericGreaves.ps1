using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLERICGREAVES
#
###############################################################################

Class BEClericGreaves : BEGreaves {
	BEClericGreaves() : base() {
		$this.Name               = 'Cleric Greaves'
		$this.MapObjName         = 'clericgreaves'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves blessed by divine power, for healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
