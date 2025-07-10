using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANGELSHALO
#
###############################################################################

Class BEAngelsHalo : BEHelmet {
	BEAngelsHalo() : base() {
		$this.Name               = 'Angel''s Halo'
		$this.MapObjName         = 'angelshalo'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering halo radiating divine energy, protecting against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
