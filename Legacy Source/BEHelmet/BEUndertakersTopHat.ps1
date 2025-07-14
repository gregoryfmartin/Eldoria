using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNDERTAKERSTOPHAT
#
###############################################################################

Class BEUndertakersTopHat : BEHelmet {
	BEUndertakersTopHat() : base() {
		$this.Name               = 'Undertaker''s Top Hat'
		$this.MapObjName         = 'undertakerstophat'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solemn top hat worn by undertakers, reflecting their profession.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
