using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANGREAVES
#
###############################################################################

Class BETitanGreaves : BEGreaves {
	BETitanGreaves() : base() {
		$this.Name               = 'Titan Greaves'
		$this.MapObjName         = 'titangreaves'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of legendary titans, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
