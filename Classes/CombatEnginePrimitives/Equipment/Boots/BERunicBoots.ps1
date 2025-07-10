using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNICBOOTS
#
###############################################################################

Class BERunicBoots : BEBoots {
	BERunicBoots() : base() {
		$this.Name               = 'Runic Boots'
		$this.MapObjName         = 'runicboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots inscribed with ancient runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
