using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAETHERROBE
#
###############################################################################

Class BEAetherRobe : BEArmor {
	BEAetherRobe() : base() {
		$this.Name               = 'Aether Robe'
		$this.MapObjName         = 'aetherrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent robe that seems to shift with air currents, very light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
