using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONBOOTS
#
###############################################################################

Class BEDemonBoots : BEBoots {
	BEDemonBoots() : base() {
		$this.Name               = 'Demon Boots'
		$this.MapObjName         = 'demonboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with demonic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
