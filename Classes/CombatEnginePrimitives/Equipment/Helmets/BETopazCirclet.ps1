using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETOPAZCIRCLET
#
###############################################################################

Class BETopazCirclet : BEHelmet {
	BETopazCirclet() : base() {
		$this.Name               = 'Topaz Circlet'
		$this.MapObjName         = 'topazcirclet'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with a golden topaz, enhancing agility and swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
