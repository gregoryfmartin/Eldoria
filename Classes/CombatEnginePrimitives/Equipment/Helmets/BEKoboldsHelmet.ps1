using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE KOBOLDS HELMET
#
###############################################################################

Class BEKoboldsHelmet : BEHelmet {
	BEKoboldsHelmet() : base() {
		$this.Name               = 'Kobold''s Helmet'
		$this.MapObjName         = 'koboldshelmet'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, spiky helmet worn by kobolds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
