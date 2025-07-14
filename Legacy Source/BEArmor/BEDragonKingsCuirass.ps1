using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONKINGSCUIRASS
#
###############################################################################

Class BEDragonKingsCuirass : BEArmor {
	BEDragonKingsCuirass() : base() {
		$this.Name               = 'Dragon King''s Cuirass'
		$this.MapObjName         = 'dragonkingscuirass'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The legendary cuirass of a dragon ruler, immensely powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
