using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MUMMY'S LINEN WRAP 
#
###############################################################################

Class BEMummysLinenWrap : BEHelmet {
	BEMummysLinenWrap() : base() {
		$this.Name               = 'Mummy''s Linen Wrap'
		$this.MapObjName         = 'mummyslinenwrap'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An ancient linen wrap that offers minor protection against curses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
