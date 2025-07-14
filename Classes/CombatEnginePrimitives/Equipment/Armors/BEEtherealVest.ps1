using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALVEST
#
###############################################################################

Class BEEtherealVest : BEArmor {
	BEEtherealVest() : base() {
		$this.Name               = 'Ethereal Vest'
		$this.MapObjName         = 'etherealvest'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A semi-transparent vest that seems to flicker in and out of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
