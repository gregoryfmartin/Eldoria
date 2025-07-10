using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNPETALHANDGUARDSII
#
###############################################################################

Class BESunpetalHandguardsII : BEGauntlets {
	BESunpetalHandguardsII() : base() {
		$this.Name               = 'Sunpetal Handguards II'
		$this.MapObjName         = 'sunpetalhandguardsii'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More vibrant Sunpetal Handguards, enhanced healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
