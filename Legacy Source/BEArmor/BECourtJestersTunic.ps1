using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOURTJESTERSTUNIC
#
###############################################################################

Class BECourtJestersTunic : BEArmor {
	BECourtJestersTunic() : base() {
		$this.Name               = 'Court Jester''s Tunic'
		$this.MapObjName         = 'courtjesterstunic'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brightly colored tunic, offers no protection, purely cosmetic.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
