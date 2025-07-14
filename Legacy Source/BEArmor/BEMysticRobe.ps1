using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICROBE
#
###############################################################################

Class BEMysticRobe : BEArmor {
	BEMysticRobe() : base() {
		$this.Name               = 'Mystic Robe'
		$this.MapObjName         = 'mysticrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe pulsating with arcane energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
