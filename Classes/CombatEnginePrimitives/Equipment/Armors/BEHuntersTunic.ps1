using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERSTUNIC
#
###############################################################################

Class BEHuntersTunic : BEArmor {
	BEHuntersTunic() : base() {
		$this.Name               = 'Hunter''s Tunic'
		$this.MapObjName         = 'hunterstunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged tunic, ideal for tracking and stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
