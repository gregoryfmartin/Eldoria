using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASTRALBOOTS
#
###############################################################################

Class BEAstralBoots : BEBoots {
	BEAstralBoots() : base() {
		$this.Name               = 'Astral Boots'
		$this.MapObjName         = 'astralboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 47
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that draw power from the stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
