using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJESTERSBELL
#
###############################################################################

Class BEJestersBell : BEJewelry {
	BEJestersBell() : base() {
		$this.Name               = 'Jester''s Bell'
		$this.MapObjName         = 'jestersbell'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, perpetually jingling bell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
