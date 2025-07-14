using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHGREAVES
#
###############################################################################

Class BESeraphGreaves : BEGreaves {
	BESeraphGreaves() : base() {
		$this.Name               = 'Seraph Greaves'
		$this.MapObjName         = 'seraphgreaves'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of angelic origin.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
