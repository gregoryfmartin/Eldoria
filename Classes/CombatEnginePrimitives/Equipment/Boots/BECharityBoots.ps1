using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHARITYBOOTS
#
###############################################################################

Class BECharityBoots : BEBoots {
	BECharityBoots() : base() {
		$this.Name               = 'Charity Boots'
		$this.MapObjName         = 'charityboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that embody benevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
