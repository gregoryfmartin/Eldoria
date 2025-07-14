using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARPYGREAVES
#
###############################################################################

Class BEHarpyGreaves : BEGreaves {
	BEHarpyGreaves() : base() {
		$this.Name               = 'Harpy Greaves'
		$this.MapObjName         = 'harpygreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 15
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that aid in agile aerial combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
