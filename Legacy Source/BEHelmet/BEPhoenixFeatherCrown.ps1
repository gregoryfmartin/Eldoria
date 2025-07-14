using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFEATHERCROWN
#
###############################################################################

Class BEPhoenixFeatherCrown : BEHelmet {
	BEPhoenixFeatherCrown() : base() {
		$this.Name               = 'Phoenix Feather Crown'
		$this.MapObjName         = 'phoenixfeathercrown'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant crown adorned with phoenix feathers, granting regenerative powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
