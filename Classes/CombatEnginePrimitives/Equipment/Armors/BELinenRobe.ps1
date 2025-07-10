using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELINENROBE
#
###############################################################################

Class BELinenRobe : BEArmor {
	BELinenRobe() : base() {
		$this.Name               = 'Linen Robe'
		$this.MapObjName         = 'linenrobe'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A loose-fitting robe suitable for mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
