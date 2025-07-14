using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETORTURERGREAVES
#
###############################################################################

Class BETorturerGreaves : BEGreaves {
	BETorturerGreaves() : base() {
		$this.Name               = 'Torturer Greaves'
		$this.MapObjName         = 'torturergreaves'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of those who inflict pain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
