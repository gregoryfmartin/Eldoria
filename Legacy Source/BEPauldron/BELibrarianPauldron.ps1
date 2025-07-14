using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIBRARIANPAULDRON
#
###############################################################################

Class BELibrarianPauldron : BEPauldron {
	BELibrarianPauldron() : base() {
		$this.Name               = 'Librarian Pauldron'
		$this.MapObjName         = 'librarianpauldron'
		$this.PurchasePrice      = 9700
		$this.SellPrice          = 4850
		$this.TargetStats        = @{
			[StatId]::Defense = 194
			[StatId]::MagicDefense = 86
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for quick access to vast amounts of information.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
