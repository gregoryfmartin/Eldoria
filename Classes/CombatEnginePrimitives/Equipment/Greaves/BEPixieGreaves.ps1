using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPIXIEGREAVES
#
###############################################################################

Class BEPixieGreaves : BEGreaves {
	BEPixieGreaves() : base() {
		$this.Name               = 'Pixie Greaves'
		$this.MapObjName         = 'pixiegreaves'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Tiny and almost weightless greaves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
