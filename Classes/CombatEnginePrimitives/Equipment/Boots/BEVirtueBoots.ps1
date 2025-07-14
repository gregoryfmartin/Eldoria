using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVIRTUEBOOTS
#
###############################################################################

Class BEVirtueBoots : BEBoots {
	BEVirtueBoots() : base() {
		$this.Name               = 'Virtue Boots'
		$this.MapObjName         = 'virtueboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots representing moral excellence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
