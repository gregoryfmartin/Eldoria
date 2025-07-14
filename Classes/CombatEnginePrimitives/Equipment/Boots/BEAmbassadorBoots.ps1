using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAMBASSADORBOOTS
#
###############################################################################

Class BEAmbassadorBoots : BEBoots {
	BEAmbassadorBoots() : base() {
		$this.Name               = 'Ambassador Boots'
		$this.MapObjName         = 'ambassadorboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for high-ranking envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
