using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHPAULDRON
#
###############################################################################

Class BESeraphPauldron : BEPauldron {
	BESeraphPauldron() : base() {
		$this.Name               = 'Seraph Pauldron'
		$this.MapObjName         = 'seraphpauldron'
		$this.PurchasePrice      = 6250
		$this.SellPrice          = 3125
		$this.TargetStats        = @{
			[StatId]::Defense = 125
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of the highest angels, granting incredible divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
