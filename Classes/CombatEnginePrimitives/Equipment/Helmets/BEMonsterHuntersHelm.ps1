using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MONSTER HUNTER'S HELM
#
###############################################################################

Class BEMonsterHuntersHelm : BEHelmet {
	BEMonsterHuntersHelm() : base() {
		$this.Name               = 'Monster Hunter''s Helm'
		$this.MapObjName         = 'monsterhuntershelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A general-purpose helm for hunting all manner of monsters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
