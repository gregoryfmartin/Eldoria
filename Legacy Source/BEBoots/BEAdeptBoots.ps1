using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADEPTBOOTS
#
###############################################################################

Class BEAdeptBoots : BEBoots {
	BEAdeptBoots() : base() {
		$this.Name               = 'Adept Boots'
		$this.MapObjName         = 'adeptboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by skilled practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
