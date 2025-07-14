using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHIVISTGREAVES
#
###############################################################################

Class BEArchivistGreaves : BEGreaves {
	BEArchivistGreaves() : base() {
		$this.Name               = 'Archivist Greaves'
		$this.MapObjName         = 'archivistgreaves'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for protectors of ancient records.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
