using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFUNERALDIRECTORSBOWLERHAT
#
###############################################################################

Class BEFuneralDirectorsBowlerHat : BEHelmet {
	BEFuneralDirectorsBowlerHat() : base() {
		$this.Name               = 'Funeral Director''s Bowler Hat'
		$this.MapObjName         = 'funeraldirectorsbowlerhat'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formal bowler hat worn by funeral directors, conveying professionalism.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
