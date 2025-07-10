using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOURTWIZARDSROBE
#
###############################################################################

Class BECourtWizardsRobe : BEArmor {
	BECourtWizardsRobe() : base() {
		$this.Name               = 'Court Wizard''s Robe'
		$this.MapObjName         = 'courtwizardsrobe'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely embroidered robe, befitting a royal mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
