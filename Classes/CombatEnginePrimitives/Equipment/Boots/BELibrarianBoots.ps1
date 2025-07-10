using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIBRARIANBOOTS
#
###############################################################################

Class BELibrarianBoots : BEBoots {
	BELibrarianBoots() : base() {
		$this.Name               = 'Librarian Boots'
		$this.MapObjName         = 'librarianboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for diligent keepers of knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
