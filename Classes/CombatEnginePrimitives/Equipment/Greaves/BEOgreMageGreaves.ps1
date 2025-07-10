using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREMAGEGREAVES
#
###############################################################################

Class BEOgreMageGreaves : BEGreaves {
	BEOgreMageGreaves() : base() {
		$this.Name               = 'Ogre Mage Greaves'
		$this.MapObjName         = 'ogremagegreaves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a powerful ogre mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
