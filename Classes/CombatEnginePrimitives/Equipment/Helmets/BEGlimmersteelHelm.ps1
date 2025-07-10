using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLIMMERSTEELHELM
#
###############################################################################

Class BEGlimmersteelHelm : BEHelmet {
	BEGlimmersteelHelm() : base() {
		$this.Name               = 'Glimmersteel Helm'
		$this.MapObjName         = 'glimmersteelhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made of glimmersteel, reflecting light and dazzling enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
