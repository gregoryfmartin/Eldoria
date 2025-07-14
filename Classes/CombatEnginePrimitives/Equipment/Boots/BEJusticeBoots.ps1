using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUSTICEBOOTS
#
###############################################################################

Class BEJusticeBoots : BEBoots {
	BEJusticeBoots() : base() {
		$this.Name               = 'Justice Boots'
		$this.MapObjName         = 'justiceboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering fairness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
