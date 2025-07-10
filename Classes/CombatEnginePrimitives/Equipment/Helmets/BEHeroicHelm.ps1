using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROICHELM
#
###############################################################################

Class BEHeroicHelm : BEHelmet {
	BEHeroicHelm() : base() {
		$this.Name               = 'Heroic Helm'
		$this.MapObjName         = 'heroichelm'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of ancient heroes, inspiring allies and striking fear in foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
