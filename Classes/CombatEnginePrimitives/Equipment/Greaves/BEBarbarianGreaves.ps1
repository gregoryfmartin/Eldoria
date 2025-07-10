using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANGREAVES
#
###############################################################################

Class BEBarbarianGreaves : BEGreaves {
	BEBarbarianGreaves() : base() {
		$this.Name               = 'Barbarian Greaves'
		$this.MapObjName         = 'barbariangreaves'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but effective greaves of a barbarian.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
