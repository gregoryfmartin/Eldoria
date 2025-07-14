using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEILLUSIONISTSMASK
#
###############################################################################

Class BEIllusionistsMask : BEHelmet {
	BEIllusionistsMask() : base() {
		$this.Name               = 'Illusionist''s Mask'
		$this.MapObjName         = 'illusionistsmask'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mask worn by illusionists, making their illusions more convincing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
