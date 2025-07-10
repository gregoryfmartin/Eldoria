using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTBOOTS
#
###############################################################################

Class BEAdamantBoots : BEBoots {
	BEAdamantBoots() : base() {
		$this.Name               = 'Adamant Boots'
		$this.MapObjName         = 'adamantboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nearly impenetrable boots made from adamant ore.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
