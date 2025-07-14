using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMETEORITEFRAGMENT
#
###############################################################################

Class BEMeteoriteFragment : BEJewelry {
	BEMeteoriteFragment() : base() {
		$this.Name               = 'Meteorite Fragment'
		$this.MapObjName         = 'meteoritefragment'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough meteorite fragment, strangely heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
