using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE PEARL TIARA
#
###############################################################################

Class BEPearlTiara : BEHelmet {
	BEPearlTiara() : base() {
		$this.Name               = 'Pearl Tiara'
		$this.MapObjName         = 'pearltiara'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate tiara with lustrous pearls, enhancing healing and purity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
