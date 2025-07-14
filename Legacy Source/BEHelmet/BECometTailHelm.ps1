using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMETTAILHELM
#
###############################################################################

Class BECometTailHelm : BEHelmet {
	BECometTailHelm() : base() {
		$this.Name               = 'Comet Tail Helm'
		$this.MapObjName         = 'comettailhelm'
		$this.PurchasePrice      = 3400
		$this.SellPrice          = 1700
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a streaking comet tail effect, enhancing speed and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
