using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONECUFFS
#
###############################################################################

Class BESunstoneCuffs : BEGauntlets {
	BESunstoneCuffs() : base() {
		$this.Name               = 'Sunstone Cuffs'
		$this.MapObjName         = 'sunstonecuffs'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs glowing with warm sunlight, providing healing and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
