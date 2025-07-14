using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNPETALHANDGUARDS
#
###############################################################################

Class BESunpetalHandguards : BEGauntlets {
	BESunpetalHandguards() : base() {
		$this.Name               = 'Sunpetal Handguards'
		$this.MapObjName         = 'sunpetalhandguards'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 40
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards made from sun-kissed petals, vibrant and delicate.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
