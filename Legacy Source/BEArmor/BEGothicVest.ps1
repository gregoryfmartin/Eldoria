using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOTHICVEST
#
###############################################################################

Class BEGothicVest : BEArmor {
	BEGothicVest() : base() {
		$this.Name               = 'Gothic Vest'
		$this.MapObjName         = 'gothicvest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, layered vest with ornate buckles, offers good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
