using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOSTATEBOOTS
#
###############################################################################

Class BEApostateBoots : BEBoots {
	BEApostateBoots() : base() {
		$this.Name               = 'Apostate Boots'
		$this.MapObjName         = 'apostateboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one who has renounced their faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
