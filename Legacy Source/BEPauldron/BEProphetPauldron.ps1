using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROPHETPAULDRON
#
###############################################################################

Class BEProphetPauldron : BEPauldron {
	BEProphetPauldron() : base() {
		$this.Name               = 'Prophet Pauldron'
		$this.MapObjName         = 'prophetpauldron'
		$this.PurchasePrice      = 7500
		$this.SellPrice          = 3750
		$this.TargetStats        = @{
			[StatId]::Defense = 150
			[StatId]::MagicDefense = 71
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who deliver divine messages, granting profound insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
