using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAMURAIBOOTS
#
###############################################################################

Class BESamuraiBoots : BEBoots {
	BESamuraiBoots() : base() {
		$this.Name               = 'Samurai Boots'
		$this.MapObjName         = 'samuraiboots'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 31
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a disciplined warrior from the East.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
