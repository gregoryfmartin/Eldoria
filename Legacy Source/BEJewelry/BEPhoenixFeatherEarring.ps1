using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFEATHEREARRING
#
###############################################################################

Class BEPhoenixFeatherEarring : BEJewelry {
	BEPhoenixFeatherEarring() : base() {
		$this.Name               = 'Phoenix Feather Earring'
		$this.MapObjName         = 'phoenixfeatherearring'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring with a vibrant phoenix feather, granting swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
