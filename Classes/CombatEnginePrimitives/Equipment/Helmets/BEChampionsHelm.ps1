using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CHAMPION'S HELM
#
###############################################################################

Class BEChampionsHelm : BEHelmet {
	BEChampionsHelm() : base() {
		$this.Name               = 'Champion''s Helm'
		$this.MapObjName         = 'championshelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grand helmet worn by champions, symbolizing their triumphs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
