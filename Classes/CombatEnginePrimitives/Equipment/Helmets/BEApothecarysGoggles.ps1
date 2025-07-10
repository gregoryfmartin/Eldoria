using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOTHECARYSGOGGLES
#
###############################################################################

Class BEApothecarysGoggles : BEHelmet {
	BEApothecarysGoggles() : base() {
		$this.Name               = 'Apothecary''s Goggles'
		$this.MapObjName         = 'apothecarysgoggles'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Protective goggles worn by apothecaries, for handling volatile concoctions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
