using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LEATHER CAP
#
###############################################################################

Class BELeatherCap : BEHelmet {
	BELeatherCap() : base() {
		$this.Name               = 'Leather Cap'
		$this.MapObjName         = 'leathercap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cap made from hardened leather, offering basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
