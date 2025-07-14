using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWHUNTRESSSVEST
#
###############################################################################

Class BEShadowHuntresssVest : BEArmor {
	BEShadowHuntresssVest() : base() {
		$this.Name               = 'Shadow Huntress''s Vest'
		$this.MapObjName         = 'shadowhuntresssvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark vest optimized for stealth and ranged attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
