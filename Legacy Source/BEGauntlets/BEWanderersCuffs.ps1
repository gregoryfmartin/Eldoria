using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWANDERERSCUFFS
#
###############################################################################

Class BEWanderersCuffs : BEGauntlets {
	BEWanderersCuffs() : base() {
		$this.Name               = 'Wanderer''s Cuffs'
		$this.MapObjName         = 'wandererscuffs'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Durable cuffs for endless travels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
