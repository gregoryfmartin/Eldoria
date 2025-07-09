using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ANTI MATTER HELM
#
###############################################################################

Class BEAntiMatterHelm : BEHelmet {
	BEAntiMatterHelm() : base() {
		$this.Name               = 'Anti-Matter Helm'
		$this.MapObjName         = 'antimatterhelm'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm crafted from anti-matter, highly destructive but dangerous to wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
