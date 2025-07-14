using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARTIFICERSCROWN
#
###############################################################################

Class BEArtificersCrown : BEHelmet {
	BEArtificersCrown() : base() {
		$this.Name               = 'Artificer''s Crown'
		$this.MapObjName         = 'artificerscrown'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown worn by master artificers, greatly enhancing their creations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
