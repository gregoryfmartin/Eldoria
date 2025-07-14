using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBAKERSTOQUE
#
###############################################################################

Class BEBakersToque : BEHelmet {
	BEBakersToque() : base() {
		$this.Name               = 'Baker''s Toque'
		$this.MapObjName         = 'bakerstoque'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tall white hat worn by bakers, protecting their hair and symbolizing their craft.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
