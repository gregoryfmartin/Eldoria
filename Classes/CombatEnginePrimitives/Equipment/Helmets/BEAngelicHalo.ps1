using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ANGELIC HALO
#
###############################################################################

Class BEAngelicHalo : BEHelmet {
	BEAngelicHalo() : base() {
		$this.Name               = 'Angelic Halo'
		$this.MapObjName         = 'angelichalo'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luminous halo of pure light, granting divine blessings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
