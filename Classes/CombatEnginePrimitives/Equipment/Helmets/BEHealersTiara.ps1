using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEALERSTIARA
#
###############################################################################

Class BEHealersTiara : BEHelmet {
	BEHealersTiara() : base() {
		$this.Name               = 'Healer''s Tiara'
		$this.MapObjName         = 'healerstiara'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate tiara that enhances healing spells and provides comfort.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
