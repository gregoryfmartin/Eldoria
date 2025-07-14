using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERSSHROUDHELM
#
###############################################################################

Class BESpectersShroudHelm : BEHelmet {
	BESpectersShroudHelm() : base() {
		$this.Name               = 'Specter''s Shroud Helm'
		$this.MapObjName         = 'spectersshroudhelm'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ghostly helm that allows the wearer to phase through solid objects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
