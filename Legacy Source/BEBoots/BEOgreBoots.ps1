using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREBOOTS
#
###############################################################################

Class BEOgreBoots : BEBoots {
	BEOgreBoots() : base() {
		$this.Name               = 'Ogre Boots'
		$this.MapObjName         = 'ogreboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive boots for immense creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
