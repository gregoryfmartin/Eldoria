using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKYWALKERHELM
#
###############################################################################

Class BESkywalkerHelm : BEHelmet {
	BESkywalkerHelm() : base() {
		$this.Name               = 'Skywalker Helm'
		$this.MapObjName         = 'skywalkerhelm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight helm that seems to defy gravity, aiding in agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
