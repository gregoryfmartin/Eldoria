using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHIVISTBOOTS
#
###############################################################################

Class BEArchivistBoots : BEBoots {
	BEArchivistBoots() : base() {
		$this.Name               = 'Archivist Boots'
		$this.MapObjName         = 'archivistboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for protectors of ancient records.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
