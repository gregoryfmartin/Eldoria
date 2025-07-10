using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMULTIVERSEKEY
#
###############################################################################

Class BEMultiverseKey : BEJewelry {
	BEMultiverseKey() : base() {
		$this.Name               = 'Multiverse Key'
		$this.MapObjName         = 'multiversekey'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A key rumored to unlock doors between dimensions.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
