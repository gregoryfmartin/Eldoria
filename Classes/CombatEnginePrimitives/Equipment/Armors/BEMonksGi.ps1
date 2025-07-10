using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKSGI
#
###############################################################################

Class BEMonksGi : BEArmor {
	BEMonksGi() : base() {
		$this.Name               = 'Monk''s Gi'
		$this.MapObjName         = 'monksgi'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, loose-fitting martial arts uniform.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
