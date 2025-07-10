using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGESPAULDRON
#
###############################################################################

Class BESagesPauldron : BEPauldron {
	BESagesPauldron() : base() {
		$this.Name               = 'Sage''s Pauldron'
		$this.MapObjName         = 'sagespauldron'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by wise sages, granting insight and magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
