using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEPRECHAUNBOOTS
#
###############################################################################

Class BELeprechaunBoots : BEBoots {
	BELeprechaunBoots() : base() {
		$this.Name               = 'Leprechaun Boots'
		$this.MapObjName         = 'leprechaunboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that bring good fortune.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
