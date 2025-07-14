using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINEHELM
#
###############################################################################

Class BEDivineHelm : BEHelmet {
	BEDivineHelm() : base() {
		$this.Name               = 'Divine Helm'
		$this.MapObjName         = 'divinehelm'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of divine origin, granting godly powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
