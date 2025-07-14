using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLERICSCUFFS
#
###############################################################################

Class BEClericsCuffs : BEGauntlets {
	BEClericsCuffs() : base() {
		$this.Name               = 'Cleric''s Cuffs'
		$this.MapObjName         = 'clericscuffs'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple cuffs worn by clerics, aiding in divine magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
