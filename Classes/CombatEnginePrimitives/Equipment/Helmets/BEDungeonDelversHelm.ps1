using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDUNGEONDELVERSHELM
#
###############################################################################

Class BEDungeonDelversHelm : BEHelmet {
	BEDungeonDelversHelm() : base() {
		$this.Name               = 'Dungeon Delver''s Helm'
		$this.MapObjName         = 'dungeondelvershelm'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust helm for dungeon delvers, protecting against traps.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
