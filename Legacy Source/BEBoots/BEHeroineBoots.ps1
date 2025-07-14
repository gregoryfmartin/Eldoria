using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROINEBOOTS
#
###############################################################################

Class BEHeroineBoots : BEBoots {
	BEHeroineBoots() : base() {
		$this.Name               = 'Heroine Boots'
		$this.MapObjName         = 'heroineboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a celebrated female hero.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
