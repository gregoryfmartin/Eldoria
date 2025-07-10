using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICSHEADBAND
#
###############################################################################

Class BEMysticsHeadband : BEHelmet {
	BEMysticsHeadband() : base() {
		$this.Name               = 'Mystic''s Headband'
		$this.MapObjName         = 'mysticsheadband'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by mystics, aiding in meditation and enlightenment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
