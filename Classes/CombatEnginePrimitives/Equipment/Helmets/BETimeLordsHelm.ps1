using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIMELORDSHELM
#
###############################################################################

Class BETimeLordsHelm : BEHelmet {
	BETimeLordsHelm() : base() {
		$this.Name               = 'Time Lord''s Helm'
		$this.MapObjName         = 'timelordshelm'
		$this.PurchasePrice      = 15000
		$this.SellPrice          = 7500
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants absolute control over time itself, allowing reality rewriting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
