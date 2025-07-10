using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEVILPAULDRON
#
###############################################################################

Class BEDevilPauldron : BEPauldron {
	BEDevilPauldron() : base() {
		$this.Name               = 'Devil Pauldron'
		$this.MapObjName         = 'devilpauldron'
		$this.PurchasePrice      = 6100
		$this.SellPrice          = 3050
		$this.TargetStats        = @{
			[StatId]::Defense = 122
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A relic of immense evil, granting unholy strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
