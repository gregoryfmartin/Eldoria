using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONQUERORSCROWN
#
###############################################################################

Class BEConquerorsCrown : BEHelmet {
	BEConquerorsCrown() : base() {
		$this.Name               = 'Conqueror''s Crown'
		$this.MapObjName         = 'conquerorscrown'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent crown worn by conquerors, inspiring loyalty and fear in their armies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
