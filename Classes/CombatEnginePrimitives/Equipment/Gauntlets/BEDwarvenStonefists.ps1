using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENSTONEFISTS
#
###############################################################################

Class BEDwarvenStonefists : BEGauntlets {
	BEDwarvenStonefists() : base() {
		$this.Name               = 'Dwarven Stonefists'
		$this.MapObjName         = 'dwarvenstonefists'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stone-infused gauntlets, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
