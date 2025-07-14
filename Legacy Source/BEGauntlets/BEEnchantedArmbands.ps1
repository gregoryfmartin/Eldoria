using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTEDARMBANDS
#
###############################################################################

Class BEEnchantedArmbands : BEGauntlets {
	BEEnchantedArmbands() : base() {
		$this.Name               = 'Enchanted Armbands'
		$this.MapObjName         = 'enchantedarmbands'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armbands pulsating with magical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
