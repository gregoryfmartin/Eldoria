using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMPLATING
#
###############################################################################

Class BEGolemPlating : BEArmor {
	BEGolemPlating() : base() {
		$this.Name               = 'Golem Plating'
		$this.MapObjName         = 'golemplating'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sections of golem plating fashioned into a heavy torso armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
