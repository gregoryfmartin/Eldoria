using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYITURTLEBOOTS
#
###############################################################################

Class BEInfinityITurtleBoots : BEBoots {
    BEInfinityITurtleBoots() : base() {
		$this.Name               = 'Infinity I Turtle Boots'
		$this.MapObjName         = 'infinityiturtleboots'
		$this.PurchasePrice      = 370000
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Defense = 255
			[StatId]::MagicDefense = 255
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'They bounce you really high.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
    }
}
