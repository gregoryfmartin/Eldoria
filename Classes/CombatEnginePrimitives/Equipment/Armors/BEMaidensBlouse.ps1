using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMAIDENSBLOUSE
#
###############################################################################

Class BEMaidensBlouse : BEArmor {
	BEMaidensBlouse() : base() {
		$this.Name               = 'Maiden''s Blouse'
		$this.MapObjName         = 'maidensblouse'
		$this.PurchasePrice      = 75
		$this.SellPrice          = 38
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate blouse often worn by young women.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
