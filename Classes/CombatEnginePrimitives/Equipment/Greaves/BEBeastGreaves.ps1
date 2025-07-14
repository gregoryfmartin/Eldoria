using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTGREAVES
#
###############################################################################

Class BEBeastGreaves : BEGreaves {
	BEBeastGreaves() : base() {
		$this.Name               = 'Beast Greaves'
		$this.MapObjName         = 'beastgreaves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves made from monstrous beast hides.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
