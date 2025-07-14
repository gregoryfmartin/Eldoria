using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIVINATIONORBHELM
#
###############################################################################

Class BEDivinationOrbHelm : BEHelmet {
	BEDivinationOrbHelm() : base() {
		$this.Name               = 'Divination Orb Helm'
		$this.MapObjName         = 'divinationorbhelm'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a scrying orb, aiding in divination.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
