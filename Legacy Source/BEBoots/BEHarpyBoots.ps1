using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARPYBOOTS
#
###############################################################################

Class BEHarpyBoots : BEBoots {
	BEHarpyBoots() : base() {
		$this.Name               = 'Harpy Boots'
		$this.MapObjName         = 'harpyboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that aid in agile aerial combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
