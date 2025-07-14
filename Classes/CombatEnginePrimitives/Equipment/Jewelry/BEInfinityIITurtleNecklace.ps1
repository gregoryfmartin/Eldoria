using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYIITURTLENECKLACE
#
###############################################################################

Class BEInfinityIITurtleNecklace : BEJewelry {
    BEInfinityIITurtleNecklace() : base() {
		$this.Name               = 'Infinity II Turtle Necklace'
		$this.MapObjName         = 'infinityiiturtlenecklace'
		$this.PurchasePrice      = 240000
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Speed = 250
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Because mom will like it if you wear it. And it''s littered with glitter!'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
    }
}
