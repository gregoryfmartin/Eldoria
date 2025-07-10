using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKNIGHTSBASCINET
#
###############################################################################

Class BEKnightsBascinet : BEHelmet {
	BEKnightsBascinet() : base() {
		$this.Name               = 'Knight''s Bascinet'
		$this.MapObjName         = 'knightsbascinet'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic knight''s helmet with a pointed visor, offering good protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
