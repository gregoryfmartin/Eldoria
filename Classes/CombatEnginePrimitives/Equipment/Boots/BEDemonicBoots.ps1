using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONICBOOTS
#
###############################################################################

Class BEDemonicBoots : BEBoots {
	BEDemonicBoots() : base() {
		$this.Name               = 'Demonic Boots'
		$this.MapObjName         = 'demonicboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with the essence of demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
