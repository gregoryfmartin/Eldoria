using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWINTERMAIDENSROBE
#
###############################################################################

Class BEWinterMaidensRobe : BEArmor {
	BEWinterMaidensRobe() : base() {
		$this.Name               = 'Winter Maiden''s Robe'
		$this.MapObjName         = 'wintermaidensrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that emanates a chilling aura, providing strong cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
