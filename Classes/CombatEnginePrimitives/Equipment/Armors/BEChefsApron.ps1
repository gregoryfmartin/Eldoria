using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHEFSAPRON
#
###############################################################################

Class BEChefsApron : BEArmor {
	BEChefsApron() : base() {
		$this.Name               = 'Chef''s Apron'
		$this.MapObjName         = 'chefsapron'
		$this.PurchasePrice      = 85
		$this.SellPrice          = 42
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A surprisingly durable apron, good for resisting minor damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
