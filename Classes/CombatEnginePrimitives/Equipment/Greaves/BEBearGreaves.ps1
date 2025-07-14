using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARGREAVES
#
###############################################################################

Class BEBearGreaves : BEGreaves {
    BEBearGreaves() : base() {
		$this.Name               = 'Bear Greaves'
		$this.MapObjName         = 'beargreaves'
		$this.PurchasePrice      = 0
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Defense      = 999
			[StatId]::MagicDefense = 999
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ultimate in fuzzy greaves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
    }
}
