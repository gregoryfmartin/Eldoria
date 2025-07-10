using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DIPLOMAT'S HAT
#
###############################################################################

Class BEDiplomatsHat : BEHelmet {
	BEDiplomatsHat() : base() {
		$this.Name               = 'Diplomat''s Hat'
		$this.MapObjName         = 'diplomatshat'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A refined hat worn by diplomats, conveying respect and authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
