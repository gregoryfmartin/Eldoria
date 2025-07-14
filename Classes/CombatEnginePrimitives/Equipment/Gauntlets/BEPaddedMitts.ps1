using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPADDEDMITTS
#
###############################################################################

Class BEPaddedMitts : BEGauntlets {
	BEPaddedMitts() : base() {
		$this.Name               = 'Padded Mitts'
		$this.MapObjName         = 'paddedmitts'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thickly padded gloves, offering surprising magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
