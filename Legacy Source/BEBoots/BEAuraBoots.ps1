using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAURABOOTS
#
###############################################################################

Class BEAuraBoots : BEBoots {
	BEAuraBoots() : base() {
		$this.Name               = 'Aura Boots'
		$this.MapObjName         = 'auraboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that emanate a protective aura.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
