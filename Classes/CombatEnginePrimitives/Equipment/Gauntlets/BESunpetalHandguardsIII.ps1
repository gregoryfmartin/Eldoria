using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNPETALHANDGUARDSIII
#
###############################################################################

Class BESunpetalHandguardsIII : BEGauntlets {
	BESunpetalHandguardsIII() : base() {
		$this.Name               = 'Sunpetal Handguards III'
		$this.MapObjName         = 'sunpetalhandguardsiii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 50
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Sunpetal Handguards, vibrant and supremely healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
