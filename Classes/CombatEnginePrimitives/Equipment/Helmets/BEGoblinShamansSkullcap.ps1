using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINSHAMANSSKULLCAP
#
###############################################################################

Class BEGoblinShamansSkullcap : BEHelmet {
	BEGoblinShamansSkullcap() : base() {
		$this.Name               = 'Goblin Shaman''s Skullcap'
		$this.MapObjName         = 'goblinshamansskullcap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude skullcap adorned with goblin shaman trinkets, enhancing their rudimentary magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
