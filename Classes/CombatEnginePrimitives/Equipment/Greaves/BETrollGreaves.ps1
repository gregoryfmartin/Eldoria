using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETROLLGREAVES
#
###############################################################################

Class BETrollGreaves : BEGreaves {
	BETrollGreaves() : base() {
		$this.Name               = 'Troll Greaves'
		$this.MapObjName         = 'trollgreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves with regenerative properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
