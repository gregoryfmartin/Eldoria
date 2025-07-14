using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEECHOINGCONCH
#
###############################################################################

Class BEEchoingConch : BEJewelry {
	BEEchoingConch() : base() {
		$this.Name               = 'Echoing Conch'
		$this.MapObjName         = 'echoingconch'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A conch shell that echoes faint sounds of the past.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
