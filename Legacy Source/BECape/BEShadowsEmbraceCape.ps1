using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWSEMBRACECAPE
#
###############################################################################

Class BEShadowsEmbraceCape : BECape {
	BEShadowsEmbraceCape() : base() {
		$this.Name               = 'Shadows Embrace Cape'
		$this.MapObjName         = 'shadowsembracecape'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Speed = 3
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that seems to absorb light, aiding in stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
