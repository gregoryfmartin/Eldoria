using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESANCTUARYBOOTS
#
###############################################################################

Class BESanctuaryBoots : BEBoots {
	BESanctuaryBoots() : base() {
		$this.Name               = 'Sanctuary Boots'
		$this.MapObjName         = 'sanctuaryboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that offer a sense of peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
