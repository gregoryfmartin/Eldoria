using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGEODEFRAGMENT
#
###############################################################################

Class BEGeodeFragment : BEJewelry {
	BEGeodeFragment() : base() {
		$this.Name               = 'Geode Fragment'
		$this.MapObjName         = 'geodefragment'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough geode fragment, sparkling with hidden crystals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
