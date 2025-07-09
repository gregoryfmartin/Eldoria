using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SPHINX'S MASK
#
###############################################################################

Class BESphinxsMask : BEHelmet {
	BESphinxsMask() : base() {
		$this.Name               = 'Sphinx''s Mask'
		$this.MapObjName         = 'sphinxsmask'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An enigmatic mask that grants cryptic wisdom and a connection to ancient riddles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
