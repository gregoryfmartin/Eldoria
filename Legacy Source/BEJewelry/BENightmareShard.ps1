using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTMARESHARD
#
###############################################################################

Class BENightmareShard : BEJewelry {
	BENightmareShard() : base() {
		$this.Name               = 'Nightmare Shard'
		$this.MapObjName         = 'nightmareshard'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A jagged shard that induces terrifying nightmares.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
