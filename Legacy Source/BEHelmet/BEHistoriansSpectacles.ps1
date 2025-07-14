using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHISTORIANSSPECTACLES
#
###############################################################################

Class BEHistoriansSpectacles : BEHelmet {
	BEHistoriansSpectacles() : base() {
		$this.Name               = 'Historian''s Spectacles'
		$this.MapObjName         = 'historiansspectacles'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Spectacles that aid historians in deciphering ancient texts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
