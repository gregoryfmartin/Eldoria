using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALGREAVES
#
###############################################################################

Class BEEtherealGreaves : BEGreaves {
	BEEtherealGreaves() : base() {
		$this.Name               = 'Ethereal Greaves'
		$this.MapObjName         = 'etherealgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves existing between realms, difficult to perceive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
