using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE KING'S CROWN
#
###############################################################################

Class BEKingsCrown : BEHelmet {
	BEKingsCrown() : base() {
		$this.Name               = 'King''s Crown'
		$this.MapObjName         = 'kingscrown'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A noble crown worn by kings, inspiring bravery in their subjects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
