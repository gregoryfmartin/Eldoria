using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMERCHANTSTURBAN
#
###############################################################################

Class BEMerchantsTurban : BEHelmet {
	BEMerchantsTurban() : base() {
		$this.Name               = 'Merchant''s Turban'
		$this.MapObjName         = 'merchantsturban'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical turban worn by merchants, suitable for travel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
