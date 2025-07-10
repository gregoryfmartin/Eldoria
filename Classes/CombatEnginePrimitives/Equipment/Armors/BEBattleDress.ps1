using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEDRESS
#
###############################################################################

Class BEBattleDress : BEArmor {
	BEBattleDress() : base() {
		$this.Name               = 'Battle Dress'
		$this.MapObjName         = 'battledress'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A functional dress designed for combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
