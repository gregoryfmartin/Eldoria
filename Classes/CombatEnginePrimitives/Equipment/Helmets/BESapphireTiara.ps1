using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SAPPHIRE TIARA
#
###############################################################################

Class BESapphireTiara : BEHelmet {
	BESapphireTiara() : base() {
		$this.Name               = 'Sapphire Tiara'
		$this.MapObjName         = 'sapphiretiara'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara with a brilliant sapphire, enhancing water and ice magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
