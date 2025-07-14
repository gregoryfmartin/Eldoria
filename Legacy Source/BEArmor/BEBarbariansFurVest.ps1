using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANSFURVEST
#
###############################################################################

Class BEBarbariansFurVest : BEArmor {
	BEBarbariansFurVest() : base() {
		$this.Name               = 'Barbarian''s Fur Vest'
		$this.MapObjName         = 'barbariansfurvest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged vest made of thick fur, offers warmth and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
