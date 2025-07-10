using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIBRARIANSEYESHADE
#
###############################################################################

Class BELibrariansEyeshade : BEHelmet {
	BELibrariansEyeshade() : base() {
		$this.Name               = 'Librarian''s Eye-shade'
		$this.MapObjName         = 'librarianseyeshade'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An eye-shade that helps librarians focus on their reading.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
