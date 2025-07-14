using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHIEFSBANDANA
#
###############################################################################

Class BEThiefsBandana : BEHelmet {
	BEThiefsBandana() : base() {
		$this.Name               = 'Thief''s Bandana'
		$this.MapObjName         = 'thiefsbandana'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A discreet bandana that aids stealth and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
