using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHIVISTPAULDRON
#
###############################################################################

Class BEArchivistPauldron : BEPauldron {
	BEArchivistPauldron() : base() {
		$this.Name               = 'Archivist Pauldron'
		$this.MapObjName         = 'archivistpauldron'
		$this.PurchasePrice      = 9650
		$this.SellPrice          = 4825
		$this.TargetStats        = @{
			[StatId]::Defense = 193
			[StatId]::MagicDefense = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Protects ancient knowledge and grants access to forgotten lore.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
