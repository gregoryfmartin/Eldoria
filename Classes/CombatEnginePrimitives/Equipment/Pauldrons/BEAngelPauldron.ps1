using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANGELPAULDRON
#
###############################################################################

Class BEAngelPauldron : BEPauldron {
	BEAngelPauldron() : base() {
		$this.Name               = 'Angel Pauldron'
		$this.MapObjName         = 'angelpauldron'
		$this.PurchasePrice      = 6150
		$this.SellPrice          = 3075
		$this.TargetStats        = @{
			[StatId]::Defense = 123
			[StatId]::MagicDefense = 46
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shines with divine light, warding off all evil and healing wounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
