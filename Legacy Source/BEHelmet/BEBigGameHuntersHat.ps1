using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBIGGAMEHUNTERSHAT
#
###############################################################################

Class BEBigGameHuntersHat : BEHelmet {
	BEBigGameHuntersHat() : base() {
		$this.Name               = 'Big Game Hunter''s Hat'
		$this.MapObjName         = 'biggamehuntershat'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A distinctive hat worn by big game hunters, indicating their prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
