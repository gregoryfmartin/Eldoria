using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSCAP
#
###############################################################################

Class BEHuntersCap : BEHelmet {
	BEHuntersCap() : base() {
		$this.Name               = 'Hunter''s Cap'
		$this.MapObjName         = 'hunterscap'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap for hunters, designed for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
