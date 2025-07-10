using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNLITCAPE
#
###############################################################################

Class BESunlitCape : BECape {
	BESunlitCape() : base() {
		$this.Name               = 'Sunlit Cape'
		$this.MapObjName         = 'sunlitcape'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that glows faintly with solar energy, inspiring hope.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
