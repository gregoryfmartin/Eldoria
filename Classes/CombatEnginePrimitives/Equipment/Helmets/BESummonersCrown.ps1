7using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SUMMONER'S CROWN
#
###############################################################################

Class BESummonersCrown : BEHelmet {
	BESummonersCrown() : base() {
		$this.Name               = 'Summoner''s Crown'
		$this.MapObjName         = 'summonerscrown'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown that amplifies summoning magic, allowing for more powerful summons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
