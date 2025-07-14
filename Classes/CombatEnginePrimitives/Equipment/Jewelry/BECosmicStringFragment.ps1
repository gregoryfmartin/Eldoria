using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICSTRINGFRAGMENT
#
###############################################################################

Class BECosmicStringFragment : BEJewelry {
	BECosmicStringFragment() : base() {
		$this.Name               = 'Cosmic String Fragment'
		$this.MapObjName         = 'cosmicstringfragment'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Accuracy = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of an infinitely thin cosmic string.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
