using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCANEBOOTS
#
###############################################################################

Class BEArcaneBoots : BEBoots {
	BEArcaneBoots() : base() {
		$this.Name               = 'Arcane Boots'
		$this.MapObjName         = 'arcaneboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with raw arcane power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
