using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINSPOTHELM
#
###############################################################################

Class BEGoblinsPotHelm : BEHelmet {
	BEGoblinsPotHelm() : base() {
		$this.Name               = 'Goblin''s Pot Helm'
		$this.MapObjName         = 'goblinspothelm'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A makeshift helmet fashioned from a cooking pot, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
