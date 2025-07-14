using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOTANISTGREAVES
#
###############################################################################

Class BEBotanistGreaves : BEGreaves {
	BEBotanistGreaves() : base() {
		$this.Name               = 'Botanist Greaves'
		$this.MapObjName         = 'botanistgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for plant specialists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
