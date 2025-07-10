using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJESTERSHAT
#
###############################################################################

Class BEJestersHat : BEHelmet {
	BEJestersHat() : base() {
		$this.Name               = 'Jester''s Hat'
		$this.MapObjName         = 'jestershat'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful, three-pointed hat worn by jesters, spreading mirth.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
