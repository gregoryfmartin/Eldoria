using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENGINEERGREAVES
#
###############################################################################

Class BEEngineerGreaves : BEGreaves {
	BEEngineerGreaves() : base() {
		$this.Name               = 'Engineer Greaves'
		$this.MapObjName         = 'engineergreaves'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of mechanical innovators.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
