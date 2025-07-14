using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMETEORSHOWERFRAGMENT
#
###############################################################################

Class BEMeteorShowerFragment : BEJewelry {
	BEMeteorShowerFragment() : base() {
		$this.Name               = 'Meteor Shower Fragment'
		$this.MapObjName         = 'meteorshowerfragment'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment from a spectacular meteor shower.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
