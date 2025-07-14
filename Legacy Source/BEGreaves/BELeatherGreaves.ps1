using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERGREAVES
#
###############################################################################

Class BELeatherGreaves : BEGreaves {
	BELeatherGreaves() : base() {
		$this.Name               = 'Leather Greaves'
		$this.MapObjName         = 'leathergreaves'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple leather leg guards, offering basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
