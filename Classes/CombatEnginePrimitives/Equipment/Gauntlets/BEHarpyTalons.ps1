using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARPYTALONS
#
###############################################################################

Class BEHarpyTalons : BEGauntlets {
	BEHarpyTalons() : base() {
		$this.Name               = 'Harpy Talons'
		$this.MapObjName         = 'harpytalons'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light gauntlets with sharp tips, good for quick attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
