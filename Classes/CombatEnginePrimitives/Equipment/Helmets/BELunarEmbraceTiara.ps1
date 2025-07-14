using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELUNAREMBRACETIARA
#
###############################################################################

Class BELunarEmbraceTiara : BEHelmet {
	BELunarEmbraceTiara() : base() {
		$this.Name               = 'Lunar Embrace Tiara'
		$this.MapObjName         = 'lunarembracetiara'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that glows with moonlight, enhancing nocturnal abilities and grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
