using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERETICSMARKHEADBAND
#
###############################################################################

Class BEHereticsMarkHeadband : BEHelmet {
	BEHereticsMarkHeadband() : base() {
		$this.Name               = 'Heretic''s Mark Headband'
		$this.MapObjName         = 'hereticsmarkheadband'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed headband that marks the wearer as a heretic.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
