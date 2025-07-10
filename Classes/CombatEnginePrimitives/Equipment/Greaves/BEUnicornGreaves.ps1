using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNICORNGREAVES
#
###############################################################################

Class BEUnicornGreaves : BEGreaves {
	BEUnicornGreaves() : base() {
		$this.Name               = 'Unicorn Greaves'
		$this.MapObjName         = 'unicorngreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pure greaves, associated with healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
