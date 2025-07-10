using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE PIRATE CAPTAIN'S TRICORNE
#
###############################################################################

Class BEPirateCaptainsTricorne : BEHelmet {
	BEPirateCaptainsTricorne() : base() {
		$this.Name               = 'Pirate Captain''s Tricorne'
		$this.MapObjName         = 'piratecaptainstricorne'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic pirate captain''s hat, inspiring fear and loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
