using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHBOOTS
#
###############################################################################

Class BESeraphBoots : BEBoots {
	BESeraphBoots() : base() {
		$this.Name               = 'Seraph Boots'
		$this.MapObjName         = 'seraphboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 57
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of angelic origin.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
