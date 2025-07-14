using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEAMVALVEPIN
#
###############################################################################

Class BESteamValvePin : BEJewelry {
	BESteamValvePin() : base() {
		$this.Name               = 'Steam Valve Pin'
		$this.MapObjName         = 'steamvalvepin'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin shaped like a tiny steam valve, for mechanical control.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
