using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBROWNIESACORNCAP
#
###############################################################################

Class BEBrowniesAcornCap : BEHelmet {
	BEBrowniesAcornCap() : base() {
		$this.Name               = 'Brownie''s Acorn Cap'
		$this.MapObjName         = 'browniesacorncap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small cap made from an acorn, offering minor protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
