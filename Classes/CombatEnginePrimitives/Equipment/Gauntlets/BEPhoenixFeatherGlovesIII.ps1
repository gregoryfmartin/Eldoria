using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFEATHERGLOVESIII
#
###############################################################################

Class BEPhoenixFeatherGlovesIII : BEGauntlets {
	BEPhoenixFeatherGlovesIII() : base() {
		$this.Name               = 'Phoenix Feather Gloves III'
		$this.MapObjName         = 'phoenixfeatherglovesiii'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Phoenix Feather Gloves, supreme healing and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
