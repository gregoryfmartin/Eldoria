using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSBRACERS
#
###############################################################################

Class BEZealotsBracers : BEGauntlets {
	BEZealotsBracers() : base() {
		$this.Name               = 'Zealot''s Bracers'
		$this.MapObjName         = 'zealotsbracers'
		$this.PurchasePrice      = 790
		$this.SellPrice          = 395
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers of a fanatical warrior, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
