using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SHERPERD'S WOOL CAP
#
###############################################################################

Class BEShepherdsWoolCap : BEHelmet {
	BEShepherdsWoolCap() : base() {
		$this.Name               = 'Shepherd''s Wool Cap'
		$this.MapObjName         = 'shepherdswoolcap'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple wool cap worn by shepherds, providing warmth.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
