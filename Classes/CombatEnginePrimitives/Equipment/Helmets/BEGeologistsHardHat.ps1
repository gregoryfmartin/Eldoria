using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GEOLOGIST'S HARD HAT
#
###############################################################################

Class BEGeologistsHardHat : BEHelmet {
	BEGeologistsHardHat() : base() {
		$this.Name               = 'Geologist''s Hard Hat'
		$this.MapObjName         = 'geologistshardhat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hard hat used by geologists, protecting from falling rocks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
