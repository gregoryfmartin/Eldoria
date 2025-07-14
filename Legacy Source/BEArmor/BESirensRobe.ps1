using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIRENSROBE
#
###############################################################################

Class BESirensRobe : BEArmor {
	BESirensRobe() : base() {
		$this.Name               = 'Siren''s Robe'
		$this.MapObjName         = 'sirensrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering robe that enthralls those nearby, enhancing charm magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
