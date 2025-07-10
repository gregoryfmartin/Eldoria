using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIBRARIANGREAVES
#
###############################################################################

Class BELibrarianGreaves : BEGreaves {
	BELibrarianGreaves() : base() {
		$this.Name               = 'Librarian Greaves'
		$this.MapObjName         = 'librariangreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for diligent keepers of knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
