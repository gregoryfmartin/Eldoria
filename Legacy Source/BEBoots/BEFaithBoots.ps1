using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAITHBOOTS
#
###############################################################################

Class BEFaithBoots : BEBoots {
	BEFaithBoots() : base() {
		$this.Name               = 'Faith Boots'
		$this.MapObjName         = 'faithboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering belief.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
