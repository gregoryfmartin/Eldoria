using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGARGOYLEBOOTS
#
###############################################################################

Class BEGargoyleBoots : BEBoots {
	BEGargoyleBoots() : base() {
		$this.Name               = 'Gargoyle Boots'
		$this.MapObjName         = 'gargoyleboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stone boots, offering immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
