using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERINGWOODSCAPE
#
###############################################################################

Class BEWhisperingWoodsCape : BECape {
	BEWhisperingWoodsCape() : base() {
		$this.Name               = 'Whispering Woods Cape'
		$this.MapObjName         = 'whisperingwoodscape'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape woven from ancient forest materials, attuned to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
