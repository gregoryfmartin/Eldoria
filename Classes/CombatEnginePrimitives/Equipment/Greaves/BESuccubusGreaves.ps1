using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUCCUBUSGREAVES
#
###############################################################################

Class BESuccubusGreaves : BEGreaves {
	BESuccubusGreaves() : base() {
		$this.Name               = 'Succubus Greaves'
		$this.MapObjName         = 'succubusgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a seductive demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
