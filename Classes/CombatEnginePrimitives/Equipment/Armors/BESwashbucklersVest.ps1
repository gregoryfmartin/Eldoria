using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESWASHBUCKLERSVEST
#
###############################################################################

Class BESwashbucklersVest : BEArmor {
	BESwashbucklersVest() : base() {
		$this.Name               = 'Swashbuckler''s Vest'
		$this.MapObjName         = 'swashbucklersvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with agility and charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
