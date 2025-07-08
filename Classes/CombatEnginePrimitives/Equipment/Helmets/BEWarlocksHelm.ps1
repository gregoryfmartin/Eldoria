using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WARLOCKS HELM
#
###############################################################################

Class BEWarlocksHelm : BEHelmet {
	BEWarlocksHelm() : base() {
		$this.Name               = 'Warlock''s Helm'
		$this.MapObjName         = 'warlockshelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A menacing helm favored by warlocks, amplifying their dark powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
