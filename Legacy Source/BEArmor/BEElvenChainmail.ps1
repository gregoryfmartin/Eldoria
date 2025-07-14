using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENCHAINMAIL
#
###############################################################################

Class BEElvenChainmail : BEArmor {
	BEElvenChainmail() : base() {
		$this.Name               = 'Elven Chainmail'
		$this.MapObjName         = 'elvenchainmail'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Delicately crafted chainmail, light and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
