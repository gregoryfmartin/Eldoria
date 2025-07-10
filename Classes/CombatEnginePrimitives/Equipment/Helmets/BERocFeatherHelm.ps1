using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROCFEATHERHELM
#
###############################################################################

Class BERocFeatherHelm : BEHelmet {
	BERocFeatherHelm() : base() {
		$this.Name               = 'Roc Feather Helm'
		$this.MapObjName         = 'rocfeatherhelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm adorned with roc feathers, granting keen eyesight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
