using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWISPWOODHELM
#
###############################################################################

Class BEWispwoodHelm : BEHelmet {
	BEWispwoodHelm() : base() {
		$this.Name               = 'Wispwood Helm'
		$this.MapObjName         = 'wispwoodhelm'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm made from wispwood, granting improved awareness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
