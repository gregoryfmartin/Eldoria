using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETROLLBOOTS
#
###############################################################################

Class BETrollBoots : BEBoots {
	BETrollBoots() : base() {
		$this.Name               = 'Troll Boots'
		$this.MapObjName         = 'trollboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots with regenerative properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
