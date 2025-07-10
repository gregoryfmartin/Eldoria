using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOTANISTBOOTS
#
###############################################################################

Class BEBotanistBoots : BEBoots {
	BEBotanistBoots() : base() {
		$this.Name               = 'Botanist Boots'
		$this.MapObjName         = 'botanistboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for plant specialists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
