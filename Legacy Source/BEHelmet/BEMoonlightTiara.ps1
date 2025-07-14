using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONLIGHTTIARA
#
###############################################################################

Class BEMoonlightTiara : BEHelmet {
	BEMoonlightTiara() : base() {
		$this.Name               = 'Moonlight Tiara'
		$this.MapObjName         = 'moonlighttiara'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luminous tiara that glows with moonlight, enhancing nocturnal magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
