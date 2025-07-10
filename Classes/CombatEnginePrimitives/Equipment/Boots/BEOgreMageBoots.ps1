using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREMAGEBOOTS
#
###############################################################################

Class BEOgreMageBoots : BEBoots {
	BEOgreMageBoots() : base() {
		$this.Name               = 'Ogre Mage Boots'
		$this.MapObjName         = 'ogremageboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful ogre mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
