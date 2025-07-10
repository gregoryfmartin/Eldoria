using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINERSVEST
#
###############################################################################

Class BEMinersVest : BEArmor {
	BEMinersVest() : base() {
		$this.Name               = 'Miner''s Vest'
		$this.MapObjName         = 'minersvest'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick vest, offers protection against falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
