using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGNOMEBOOTS
#
###############################################################################

Class BEGnomeBoots : BEBoots {
	BEGnomeBoots() : base() {
		$this.Name               = 'Gnome Boots'
		$this.MapObjName         = 'gnomeboots'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but sturdy boots, crafted by gnomes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
