using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORMONKSFISTCHARM
#
###############################################################################

Class BEWarriorMonksFistCharm : BEJewelry {
	BEWarriorMonksFistCharm() : base() {
		$this.Name               = 'Warrior Monk''s Fist Charm'
		$this.MapObjName         = 'warriormonksfistcharm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm shaped like a clenched fist, for martial discipline.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
