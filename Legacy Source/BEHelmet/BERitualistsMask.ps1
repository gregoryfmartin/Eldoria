using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERITUALISTSMASK
#
###############################################################################

Class BERitualistsMask : BEHelmet {
	BERitualistsMask() : base() {
		$this.Name               = 'Ritualist''s Mask'
		$this.MapObjName         = 'ritualistsmask'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mask worn by ritualists, enhancing their arcane ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
