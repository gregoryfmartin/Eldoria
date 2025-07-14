using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGNOMEGREAVES
#
###############################################################################

Class BEGnomeGreaves : BEGreaves {
	BEGnomeGreaves() : base() {
		$this.Name               = 'Gnome Greaves'
		$this.MapObjName         = 'gnomegreaves'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but sturdy greaves, crafted by gnomes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
