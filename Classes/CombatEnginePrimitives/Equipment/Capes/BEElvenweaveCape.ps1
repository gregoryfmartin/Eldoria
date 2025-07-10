using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENWEAVECAPE
#
###############################################################################

Class BEElvenweaveCape : BECape {
	BEElvenweaveCape() : base() {
		$this.Name               = 'Elvenweave Cape'
		$this.MapObjName         = 'elvenweavecape'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely woven cape, light and graceful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
