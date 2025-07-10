using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FLORIST'S GARLAND
#
###############################################################################

Class BEFloristsGarland : BEHelmet {
	BEFloristsGarland() : base() {
		$this.Name               = 'Florist''s Garland'
		$this.MapObjName         = 'floristsgarland'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate garland of flowers worn by florists, imbued with subtle nature magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
