using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTGREAVES
#
###############################################################################

Class BEAdamantGreaves : BEGreaves {
	BEAdamantGreaves() : base() {
		$this.Name               = 'Adamant Greaves'
		$this.MapObjName         = 'adamantgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nearly impenetrable greaves made from adamant ore.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
