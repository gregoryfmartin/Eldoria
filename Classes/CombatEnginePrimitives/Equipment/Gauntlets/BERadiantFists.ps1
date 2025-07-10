using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERADIANTFISTS
#
###############################################################################

Class BERadiantFists : BEGauntlets {
	BERadiantFists() : base() {
		$this.Name               = 'Radiant Fists'
		$this.MapObjName         = 'radiantfists'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists that glow with holy light, scorching evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
