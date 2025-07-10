using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERSHEADPIECE
#
###############################################################################

Class BEBerserkersHeadpiece : BEHelmet {
	BEBerserkersHeadpiece() : base() {
		$this.Name               = 'Berserker''s Headpiece'
		$this.MapObjName         = 'berserkersheadpiece'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brutal headpiece that amplifies a warrior''s raw strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
