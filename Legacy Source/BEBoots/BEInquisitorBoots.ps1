using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINQUISITORBOOTS
#
###############################################################################

Class BEInquisitorBoots : BEBoots {
	BEInquisitorBoots() : base() {
		$this.Name               = 'Inquisitor Boots'
		$this.MapObjName         = 'inquisitorboots'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who seek out heresy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
