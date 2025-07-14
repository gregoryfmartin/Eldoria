using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRUTHBOOTS
#
###############################################################################

Class BETruthBoots : BEBoots {
	BETruthBoots() : base() {
		$this.Name               = 'Truth Boots'
		$this.MapObjName         = 'truthboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that reveal falsehoods.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
