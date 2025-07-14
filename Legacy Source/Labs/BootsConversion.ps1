Class BELeatherBoots : BEBoots {
	BELeatherBoots() : base() {
		$this.Name               = 'Leather Boots'
		$this.MapObjName         = 'leatherboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic leather boots, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaddedBoots : BEBoots {
	BEPaddedBoots() : base() {
		$this.Name               = 'Padded Boots'
		$this.MapObjName         = 'paddedboots'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightly padded boots for comfortable movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzeBoots : BEBoots {
	BEBronzeBoots() : base() {
		$this.Name               = 'Bronze Boots'
		$this.MapObjName         = 'bronzeboots'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy bronze boots, providing decent foot protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronBoots : BEBoots {
	BEIronBoots() : base() {
		$this.Name               = 'Iron Boots'
		$this.MapObjName         = 'ironboots'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Common iron boots, robust and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelBoots : BEBoots {
	BESteelBoots() : base() {
		$this.Name               = 'Steel Boots'
		$this.MapObjName         = 'steelboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy steel boots, offering solid defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChainmailBoots : BEBoots {
	BEChainmailBoots() : base() {
		$this.Name               = 'Chainmail Boots'
		$this.MapObjName         = 'chainmailboots'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Flexible chainmail foot protection, good against piercing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlateBoots : BEBoots {
	BEPlateBoots() : base() {
		$this.Name               = 'Plate Boots'
		$this.MapObjName         = 'plateboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Full plate foot armor, excellent protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMithrilBoots : BEBoots {
	BEMithrilBoots() : base() {
		$this.Name               = 'Mithril Boots'
		$this.MapObjName         = 'mithrilboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from light and strong mithril.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantBoots : BEBoots {
	BEAdamantBoots() : base() {
		$this.Name               = 'Adamant Boots'
		$this.MapObjName         = 'adamantboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nearly impenetrable boots made from adamant ore.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonhideBoots : BEBoots {
	BEDragonhideBoots() : base() {
		$this.Name               = 'Dragonhide Boots'
		$this.MapObjName         = 'dragonhideboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from the tough hide of a dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenBoots : BEBoots {
	BEElvenBoots() : base() {
		$this.Name               = 'Elven Boots'
		$this.MapObjName         = 'elvenboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 20
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Graceful boots favored by elves, light and agile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDwarvenBoots : BEBoots {
	BEDwarvenBoots() : base() {
		$this.Name               = 'Dwarven Boots'
		$this.MapObjName         = 'dwarvenboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Robust boots forged by dwarven artisans.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowBoots : BEBoots {
	BEShadowBoots() : base() {
		$this.Name               = 'Shadow Boots'
		$this.MapObjName         = 'shadowboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 25
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots imbued with dark energies, granting stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEHolyBoots : BEBoots {
	BEHolyBoots() : base() {
		$this.Name               = 'Holy Boots'
		$this.MapObjName         = 'holyboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed boots that ward off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMysticBoots : BEBoots {
	BEMysticBoots() : base() {
		$this.Name               = 'Mystic Boots'
		$this.MapObjName         = 'mysticboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that enhance magical aptitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarriorBoots : BEBoots {
	BEWarriorBoots() : base() {
		$this.Name               = 'Warrior Boots'
		$this.MapObjName         = 'warriorboots'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard issue boots for a seasoned warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnightBoots : BEBoots {
	BEKnightBoots() : base() {
		$this.Name               = 'Knight Boots'
		$this.MapObjName         = 'knightboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for a noble knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESentinelBoots : BEBoots {
	BESentinelBoots() : base() {
		$this.Name               = 'Sentinel Boots'
		$this.MapObjName         = 'sentinelboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots designed for defensive stances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScoutBoots : BEBoots {
	BEScoutBoots() : base() {
		$this.Name               = 'Scout Boots'
		$this.MapObjName         = 'scoutboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
			[StatId]::Speed = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for quick movement and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERangerBoots : BEBoots {
	BERangerBoots() : base() {
		$this.Name               = 'Ranger Boots'
		$this.MapObjName         = 'rangerboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots suitable for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBerserkerBoots : BEBoots {
	BEBerserkerBoots() : base() {
		$this.Name               = 'Berserker Boots'
		$this.MapObjName         = 'berserkerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who fight with unrestrained fury.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPaladinBoots : BEBoots {
	BEPaladinBoots() : base() {
		$this.Name               = 'Paladin Boots'
		$this.MapObjName         = 'paladinboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a holy warrior, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESorcererBoots : BEBoots {
	BESorcererBoots() : base() {
		$this.Name               = 'Sorcerer Boots'
		$this.MapObjName         = 'sorcererboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots that aid in spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlockBoots : BEBoots {
	BEWarlockBoots() : base() {
		$this.Name               = 'Warlock Boots'
		$this.MapObjName         = 'warlockboots'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who dabble in dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdeptBoots : BEBoots {
	BEAdeptBoots() : base() {
		$this.Name               = 'Adept Boots'
		$this.MapObjName         = 'adeptboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by skilled practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGuardianBoots : BEBoots {
	BEGuardianBoots() : base() {
		$this.Name               = 'Guardian Boots'
		$this.MapObjName         = 'guardianboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed to protect the wearer at all costs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeroicBoots : BEBoots {
	BEHeroicBoots() : base() {
		$this.Name               = 'Heroic Boots'
		$this.MapObjName         = 'heroicboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by legendary heroes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEImperialBoots : BEBoots {
	BEImperialBoots() : base() {
		$this.Name               = 'Imperial Boots'
		$this.MapObjName         = 'imperialboots'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the imperial guard, highly polished.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoyalBoots : BEBoots {
	BERoyalBoots() : base() {
		$this.Name               = 'Royal Boots'
		$this.MapObjName         = 'royalboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for royalty, exquisitely crafted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelerBoots : BEBoots {
	BETravelerBoots() : base() {
		$this.Name               = 'Traveler Boots'
		$this.MapObjName         = 'travelerboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple and comfortable boots for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHunterBoots : BEBoots {
	BEHunterBoots() : base() {
		$this.Name               = 'Hunter Boots'
		$this.MapObjName         = 'hunterboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for tracking and hunting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMercenaryBoots : BEBoots {
	BEMercenaryBoots() : base() {
		$this.Name               = 'Mercenary Boots'
		$this.MapObjName         = 'mercenaryboots'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a hired blade, practical and durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGladiatorBoots : BEBoots {
	BEGladiatorBoots() : base() {
		$this.Name               = 'Gladiator Boots'
		$this.MapObjName         = 'gladiatorboots'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots worn by arena champions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBarbarianBoots : BEBoots {
	BEBarbarianBoots() : base() {
		$this.Name               = 'Barbarian Boots'
		$this.MapObjName         = 'barbarianboots'
		$this.PurchasePrice      = 440
		$this.SellPrice          = 220
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but effective boots of a barbarian.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDruidBoots : BEBoots {
	BEDruidBoots() : base() {
		$this.Name               = 'Druid Boots'
		$this.MapObjName         = 'druidboots'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from natural materials, attuned to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEClericBoots : BEBoots {
	BEClericBoots() : base() {
		$this.Name               = 'Cleric Boots'
		$this.MapObjName         = 'clericboots'
		$this.PurchasePrice      = 570
		$this.SellPrice          = 285
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots blessed by divine power, for healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMonkBoots : BEBoots {
	BEMonkBoots() : base() {
		$this.Name               = 'Monk Boots'
		$this.MapObjName         = 'monkboots'
		$this.PurchasePrice      = 330
		$this.SellPrice          = 165
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 14
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for martial arts practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESamuraiBoots : BEBoots {
	BESamuraiBoots() : base() {
		$this.Name               = 'Samurai Boots'
		$this.MapObjName         = 'samuraiboots'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 31
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a disciplined warrior from the East.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENinjaBoots : BEBoots {
	BENinjaBoots() : base() {
		$this.Name               = 'Ninja Boots'
		$this.MapObjName         = 'ninjaboots'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and silent boots for covert operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETemplarBoots : BEBoots {
	BETemplarBoots() : base() {
		$this.Name               = 'Templar Boots'
		$this.MapObjName         = 'templarboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Holy boots worn by zealous protectors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantedBoots : BEBoots {
	BEEnchantedBoots() : base() {
		$this.Name               = 'Enchanted Boots'
		$this.MapObjName         = 'enchantedboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots imbued with a minor enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystallineBoots : BEBoots {
	BECrystallineBoots() : base() {
		$this.Name               = 'Crystalline Boots'
		$this.MapObjName         = 'crystallineboots'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from durable crystals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanicBoots : BEBoots {
	BEVolcanicBoots() : base() {
		$this.Name               = 'Volcanic Boots'
		$this.MapObjName         = 'volcanicboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots forged near volcanic heat, resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanicBoots : BEBoots {
	BEOceanicBoots() : base() {
		$this.Name               = 'Oceanic Boots'
		$this.MapObjName         = 'oceanicboots'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots found in the depths of the ocean, resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestBoots : BEBoots {
	BEForestBoots() : base() {
		$this.Name               = 'Forest Boots'
		$this.MapObjName         = 'forestboots'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that blend with natural surroundings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertBoots : BEBoots {
	BEDesertBoots() : base() {
		$this.Name               = 'Desert Boots'
		$this.MapObjName         = 'desertboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots suitable for arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcticBoots : BEBoots {
	BEArcticBoots() : base() {
		$this.Name               = 'Arctic Boots'
		$this.MapObjName         = 'arcticboots'
		$this.PurchasePrice      = 440
		$this.SellPrice          = 220
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for cold climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallBoots : BEBoots {
	BEStarfallBoots() : base() {
		$this.Name               = 'Starfall Boots'
		$this.MapObjName         = 'starfallboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots said to be crafted from fallen stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunstoneBoots : BEBoots {
	BESunstoneBoots() : base() {
		$this.Name               = 'Sunstone Boots'
		$this.MapObjName         = 'sunstoneboots'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that shimmer with solar energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneBoots : BEBoots {
	BEMoonstoneBoots() : base() {
		$this.Name               = 'Moonstone Boots'
		$this.MapObjName         = 'moonstoneboots'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that glow with lunar power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherBoots : BEBoots {
	BEAetherBoots() : base() {
		$this.Name               = 'Aether Boots'
		$this.MapObjName         = 'aetherboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from another dimension, ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidBoots : BEBoots {
	BEVoidBoots() : base() {
		$this.Name               = 'Void Boots'
		$this.MapObjName         = 'voidboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that draw power from the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritBoots : BEBoots {
	BESpiritBoots() : base() {
		$this.Name               = 'Spirit Boots'
		$this.MapObjName         = 'spiritboots'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that resonate with spiritual energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncientBoots : BEBoots {
	BEAncientBoots() : base() {
		$this.Name               = 'Ancient Boots'
		$this.MapObjName         = 'ancientboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from a forgotten civilization.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELegendaryBoots : BEBoots {
	BELegendaryBoots() : base() {
		$this.Name               = 'Legendary Boots'
		$this.MapObjName         = 'legendaryboots'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots spoken of in ancient tales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGodlyBoots : BEBoots {
	BEGodlyBoots() : base() {
		$this.Name               = 'Godly Boots'
		$this.MapObjName         = 'godlyboots'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by deities, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApprenticeBoots : BEBoots {
	BEApprenticeBoots() : base() {
		$this.Name               = 'Apprentice Boots'
		$this.MapObjName         = 'apprenticeboots'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic boots for aspiring adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJourneymanBoots : BEBoots {
	BEJourneymanBoots() : base() {
		$this.Name               = 'Journeyman Boots'
		$this.MapObjName         = 'journeymanboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those gaining experience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMasterBoots : BEBoots {
	BEMasterBoots() : base() {
		$this.Name               = 'Master Boots'
		$this.MapObjName         = 'masterboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by true masters of their craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrandmasterBoots : BEBoots {
	BEGrandmasterBoots() : base() {
		$this.Name               = 'Grandmaster Boots'
		$this.MapObjName         = 'grandmasterboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unparalleled skill and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVanguardBoots : BEBoots {
	BEVanguardBoots() : base() {
		$this.Name               = 'Vanguard Boots'
		$this.MapObjName         = 'vanguardboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for the front lines of battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEReconBoots : BEBoots {
	BEReconBoots() : base() {
		$this.Name               = 'Recon Boots'
		$this.MapObjName         = 'reconboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 8
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for reconnaissance missions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECommandoBoots : BEBoots {
	BECommandoBoots() : base() {
		$this.Name               = 'Commando Boots'
		$this.MapObjName         = 'commandoboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for elite fighting units.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPathfinderBoots : BEBoots {
	BEPathfinderBoots() : base() {
		$this.Name               = 'Pathfinder Boots'
		$this.MapObjName         = 'pathfinderboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for charting unknown territories.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWandererBoots : BEBoots {
	BEWandererBoots() : base() {
		$this.Name               = 'Wanderer Boots'
		$this.MapObjName         = 'wandererboots'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 5
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for eternal travelers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENomadBoots : BEBoots {
	BENomadBoots() : base() {
		$this.Name               = 'Nomad Boots'
		$this.MapObjName         = 'nomadboots'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 6
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who live on the move.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPilgrimBoots : BEBoots {
	BEPilgrimBoots() : base() {
		$this.Name               = 'Pilgrim Boots'
		$this.MapObjName         = 'pilgrimboots'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for spiritual journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrusaderBoots : BEBoots {
	BECrusaderBoots() : base() {
		$this.Name               = 'Crusader Boots'
		$this.MapObjName         = 'crusaderboots'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a holy warrior on a quest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEInquisitorBoots : BEBoots {
	BEInquisitorBoots() : base() {
		$this.Name               = 'Inquisitor Boots'
		$this.MapObjName         = 'inquisitorboots'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who seek out heresy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEZealotBoots : BEBoots {
	BEZealotBoots() : base() {
		$this.Name               = 'Zealot Boots'
		$this.MapObjName         = 'zealotboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering devotion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEFanaticBoots : BEBoots {
	BEFanaticBoots() : base() {
		$this.Name               = 'Fanatic Boots'
		$this.MapObjName         = 'fanaticboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of extreme fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESentryBoots : BEBoots {
	BESentryBoots() : base() {
		$this.Name               = 'Sentry Boots'
		$this.MapObjName         = 'sentryboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for watchful guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWatchmanBoots : BEBoots {
	BEWatchmanBoots() : base() {
		$this.Name               = 'Watchman Boots'
		$this.MapObjName         = 'watchmanboots'
		$this.PurchasePrice      = 630
		$this.SellPrice          = 315
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for night patrols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMilitiaBoots : BEBoots {
	BEMilitiaBoots() : base() {
		$this.Name               = 'Militia Boots'
		$this.MapObjName         = 'militiaboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for civilian defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEConscriptBoots : BEBoots {
	BEConscriptBoots() : base() {
		$this.Name               = 'Conscript Boots'
		$this.MapObjName         = 'conscriptboots'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic boots for newly drafted soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOfficerBoots : BEBoots {
	BEOfficerBoots() : base() {
		$this.Name               = 'Officer Boots'
		$this.MapObjName         = 'officerboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by military officers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECommanderBoots : BEBoots {
	BECommanderBoots() : base() {
		$this.Name               = 'Commander Boots'
		$this.MapObjName         = 'commanderboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a battle hardened commander.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGeneralBoots : BEBoots {
	BEGeneralBoots() : base() {
		$this.Name               = 'General Boots'
		$this.MapObjName         = 'generalboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for a military general.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmperorBoots : BEBoots {
	BEEmperorBoots() : base() {
		$this.Name               = 'Emperor Boots'
		$this.MapObjName         = 'emperorboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undisputed ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmpressBoots : BEBoots {
	BEEmpressBoots() : base() {
		$this.Name               = 'Empress Boots'
		$this.MapObjName         = 'empressboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful female ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

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

Class BEChampionBoots : BEBoots {
	BEChampionBoots() : base() {
		$this.Name               = 'Champion Boots'
		$this.MapObjName         = 'championboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undisputed champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEVictorBoots : BEBoots {
	BEVictorBoots() : base() {
		$this.Name               = 'Victor Boots'
		$this.MapObjName         = 'victorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by those who claim victory.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETriumphBoots : BEBoots {
	BETriumphBoots() : base() {
		$this.Name               = 'Triumph Boots'
		$this.MapObjName         = 'triumphboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots signifying great success.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAuraBoots : BEBoots {
	BEAuraBoots() : base() {
		$this.Name               = 'Aura Boots'
		$this.MapObjName         = 'auraboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that emanate a protective aura.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESanctuaryBoots : BEBoots {
	BESanctuaryBoots() : base() {
		$this.Name               = 'Sanctuary Boots'
		$this.MapObjName         = 'sanctuaryboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that offer a sense of peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESeraphBoots : BEBoots {
	BESeraphBoots() : base() {
		$this.Name               = 'Seraph Boots'
		$this.MapObjName         = 'seraphboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 57
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of angelic origin.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECherubBoots : BEBoots {
	BECherubBoots() : base() {
		$this.Name               = 'Cherub Boots'
		$this.MapObjName         = 'cherubboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 35
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and protective boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEArchangelBoots : BEBoots {
	BEArchangelBoots() : base() {
		$this.Name               = 'Archangel Boots'
		$this.MapObjName         = 'archangelboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the highest order of angels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDemonBoots : BEBoots {
	BEDemonBoots() : base() {
		$this.Name               = 'Demon Boots'
		$this.MapObjName         = 'demonboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with demonic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFiendBoots : BEBoots {
	BEFiendBoots() : base() {
		$this.Name               = 'Fiend Boots'
		$this.MapObjName         = 'fiendboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a malevolent spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEImpBoots : BEBoots {
	BEImpBoots() : base() {
		$this.Name               = 'Imp Boots'
		$this.MapObjName         = 'impboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but surprisingly tough boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinBoots : BEBoots {
	BEGoblinBoots() : base() {
		$this.Name               = 'Goblin Boots'
		$this.MapObjName         = 'goblinboots'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude boots taken from goblins.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrcishBoots : BEBoots {
	BEOrcishBoots() : base() {
		$this.Name               = 'Orcish Boots'
		$this.MapObjName         = 'orcishboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and brutal boots of orcs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOgreBoots : BEBoots {
	BEOgreBoots() : base() {
		$this.Name               = 'Ogre Boots'
		$this.MapObjName         = 'ogreboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive boots for immense creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGiantBoots : BEBoots {
	BEGiantBoots() : base() {
		$this.Name               = 'Giant Boots'
		$this.MapObjName         = 'giantboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots sized for colossal beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETitanBoots : BEBoots {
	BETitanBoots() : base() {
		$this.Name               = 'Titan Boots'
		$this.MapObjName         = 'titanboots'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 67
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of legendary titans, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonlordBoots : BEBoots {
	BEDragonlordBoots() : base() {
		$this.Name               = 'Dragonlord Boots'
		$this.MapObjName         = 'dragonlordboots'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by a dragonlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWyvernBoots : BEBoots {
	BEWyvernBoots() : base() {
		$this.Name               = 'Wyvern Boots'
		$this.MapObjName         = 'wyvernboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from wyvern scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixBoots : BEBoots {
	BEPhoenixBoots() : base() {
		$this.Name               = 'Phoenix Boots'
		$this.MapObjName         = 'phoenixboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that glow with fiery essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinBoots : BEBoots {
	BEGriffinBoots() : base() {
		$this.Name               = 'Griffin Boots'
		$this.MapObjName         = 'griffinboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that grant swiftness and grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUnicornBoots : BEBoots {
	BEUnicornBoots() : base() {
		$this.Name               = 'Unicorn Boots'
		$this.MapObjName         = 'unicornboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pure boots, associated with healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPegasusBoots : BEBoots {
	BEPegasusBoots() : base() {
		$this.Name               = 'Pegasus Boots'
		$this.MapObjName         = 'pegasusboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that feel weightless.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHarpyBoots : BEBoots {
	BEHarpyBoots() : base() {
		$this.Name               = 'Harpy Boots'
		$this.MapObjName         = 'harpyboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that aid in agile aerial combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESphinxBoots : BEBoots {
	BESphinxBoots() : base() {
		$this.Name               = 'Sphinx Boots'
		$this.MapObjName         = 'sphinxboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of ancient wisdom and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBasiliskBoots : BEBoots {
	BEBasiliskBoots() : base() {
		$this.Name               = 'Basilisk Boots'
		$this.MapObjName         = 'basiliskboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from basilisk hide, resistant to petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHydraBoots : BEBoots {
	BEHydraBoots() : base() {
		$this.Name               = 'Hydra Boots'
		$this.MapObjName         = 'hydraboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of multi-headed beasts, regenerating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKrakenBoots : BEBoots {
	BEKrakenBoots() : base() {
		$this.Name               = 'Kraken Boots'
		$this.MapObjName         = 'krakenboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from the depths, granting water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinotaurBoots : BEBoots {
	BEMinotaurBoots() : base() {
		$this.Name               = 'Minotaur Boots'
		$this.MapObjName         = 'minotaurboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of brute strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECentaurBoots : BEBoots {
	BECentaurBoots() : base() {
		$this.Name               = 'Centaur Boots'
		$this.MapObjName         = 'centaurboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for equestrian warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGorgonBoots : BEBoots {
	BEGorgonBoots() : base() {
		$this.Name               = 'Gorgon Boots'
		$this.MapObjName         = 'gorgonboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots offering protection from petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWerewolfBoots : BEBoots {
	BEWerewolfBoots() : base() {
		$this.Name               = 'Werewolf Boots'
		$this.MapObjName         = 'werewolfboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a shapeshifter, enhances agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEVampireBoots : BEBoots {
	BEVampireBoots() : base() {
		$this.Name               = 'Vampire Boots'
		$this.MapObjName         = 'vampireboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that drain life from foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZombieBoots : BEBoots {
	BEZombieBoots() : base() {
		$this.Name               = 'Zombie Boots'
		$this.MapObjName         = 'zombieboots'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rotting boots, barely functional.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESkeletonBoots : BEBoots {
	BESkeletonBoots() : base() {
		$this.Name               = 'Skeleton Boots'
		$this.MapObjName         = 'skeletonboots'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bony boots, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGhostBoots : BEBoots {
	BEGhostBoots() : base() {
		$this.Name               = 'Ghost Boots'
		$this.MapObjName         = 'ghostboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ethereal boots, difficult to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpecterBoots : BEBoots {
	BESpecterBoots() : base() {
		$this.Name               = 'Specter Boots'
		$this.MapObjName         = 'specterboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful phantom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELichBoots : BEBoots {
	BELichBoots() : base() {
		$this.Name               = 'Lich Boots'
		$this.MapObjName         = 'lichboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undead sorcerer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMummyBoots : BEBoots {
	BEMummyBoots() : base() {
		$this.Name               = 'Mummy Boots'
		$this.MapObjName         = 'mummyboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bandaged boots, ancient and cursed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGargoyleBoots : BEBoots {
	BEGargoyleBoots() : base() {
		$this.Name               = 'Gargoyle Boots'
		$this.MapObjName         = 'gargoyleboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stone boots, offering immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemBoots : BEBoots {
	BEGolemBoots() : base() {
		$this.Name               = 'Golem Boots'
		$this.MapObjName         = 'golemboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from enchanted stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAutomatonBoots : BEBoots {
	BEAutomatonBoots() : base() {
		$this.Name               = 'Automaton Boots'
		$this.MapObjName         = 'automatonboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Mechanical boots, precisely engineered.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClockworkBoots : BEBoots {
	BEClockworkBoots() : base() {
		$this.Name               = 'Clockwork Boots'
		$this.MapObjName         = 'clockworkboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots with intricate clockwork mechanisms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteamBoots : BEBoots {
	BESteamBoots() : base() {
		$this.Name               = 'Steam Boots'
		$this.MapObjName         = 'steamboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots powered by steam, heavy but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagitechBoots : BEBoots {
	BEMagitechBoots() : base() {
		$this.Name               = 'Magitech Boots'
		$this.MapObjName         = 'magitechboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots combining magic and technology.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneBoots : BEBoots {
	BEArcaneBoots() : base() {
		$this.Name               = 'Arcane Boots'
		$this.MapObjName         = 'arcaneboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with raw arcane power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealBoots : BEBoots {
	BEEtherealBoots() : base() {
		$this.Name               = 'Ethereal Boots'
		$this.MapObjName         = 'etherealboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 43
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots existing between realms, difficult to perceive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralBoots : BEBoots {
	BEAstralBoots() : base() {
		$this.Name               = 'Astral Boots'
		$this.MapObjName         = 'astralboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 47
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that draw power from the stars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicBoots : BEBoots {
	BECosmicBoots() : base() {
		$this.Name               = 'Cosmic Boots'
		$this.MapObjName         = 'cosmicboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the cosmos, vast and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENebulaBoots : BEBoots {
	BENebulaBoots() : base() {
		$this.Name               = 'Nebula Boots'
		$this.MapObjName         = 'nebulaboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots shimmering with cosmic dust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGalacticBoots : BEBoots {
	BEGalacticBoots() : base() {
		$this.Name               = 'Galactic Boots'
		$this.MapObjName         = 'galacticboots'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 53
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from beyond the galaxy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunicBoots : BEBoots {
	BERunicBoots() : base() {
		$this.Name               = 'Runic Boots'
		$this.MapObjName         = 'runicboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots inscribed with ancient runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlyphBoots : BEBoots {
	BEGlyphBoots() : base() {
		$this.Name               = 'Glyph Boots'
		$this.MapObjName         = 'glyphboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots adorned with powerful magical symbols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESigilBoots : BEBoots {
	BESigilBoots() : base() {
		$this.Name               = 'Sigil Boots'
		$this.MapObjName         = 'sigilboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots bearing potent magical sigils.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECabalBoots : BEBoots {
	BECabalBoots() : base() {
		$this.Name               = 'Cabal Boots'
		$this.MapObjName         = 'cabalboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a secret magical society.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECultistBoots : BEBoots {
	BECultistBoots() : base() {
		$this.Name               = 'Cultist Boots'
		$this.MapObjName         = 'cultistboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by a dark cult.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEHereticBoots : BEBoots {
	BEHereticBoots() : base() {
		$this.Name               = 'Heretic Boots'
		$this.MapObjName         = 'hereticboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of those who defy dogma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEApostateBoots : BEBoots {
	BEApostateBoots() : base() {
		$this.Name               = 'Apostate Boots'
		$this.MapObjName         = 'apostateboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one who has renounced their faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERebelBoots : BEBoots {
	BERebelBoots() : base() {
		$this.Name               = 'Rebel Boots'
		$this.MapObjName         = 'rebelboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of resistance fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOutlawBoots : BEBoots {
	BEOutlawBoots() : base() {
		$this.Name               = 'Outlaw Boots'
		$this.MapObjName         = 'outlawboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those living outside the law.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBanditBoots : BEBoots {
	BEBanditBoots() : base() {
		$this.Name               = 'Bandit Boots'
		$this.MapObjName         = 'banditboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots favored by brigands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThiefBoots : BEBoots {
	BEThiefBoots() : base() {
		$this.Name               = 'Thief Boots'
		$this.MapObjName         = 'thiefboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for stealthy operatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERogueBoots : BEBoots {
	BERogueBoots() : base() {
		$this.Name               = 'Rogue Boots'
		$this.MapObjName         = 'rogueboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for cunning and agile adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAssassinBoots : BEBoots {
	BEAssassinBoots() : base() {
		$this.Name               = 'Assassin Boots'
		$this.MapObjName         = 'assassinboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for silent kills.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExecutionerBoots : BEBoots {
	BEExecutionerBoots() : base() {
		$this.Name               = 'Executioner Boots'
		$this.MapObjName         = 'executionerboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots for those who carry out sentences.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETorturerBoots : BEBoots {
	BETorturerBoots() : base() {
		$this.Name               = 'Torturer Boots'
		$this.MapObjName         = 'torturerboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of those who inflict pain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESlayerBoots : BEBoots {
	BESlayerBoots() : base() {
		$this.Name               = 'Slayer Boots'
		$this.MapObjName         = 'slayerboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a monster hunter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVanquisherBoots : BEBoots {
	BEVanquisherBoots() : base() {
		$this.Name               = 'Vanquisher Boots'
		$this.MapObjName         = 'vanquisherboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one who utterly defeats their foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEConquerorBoots : BEBoots {
	BEConquerorBoots() : base() {
		$this.Name               = 'Conqueror Boots'
		$this.MapObjName         = 'conquerorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a victorious leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETyrantBoots : BEBoots {
	BETyrantBoots() : base() {
		$this.Name               = 'Tyrant Boots'
		$this.MapObjName         = 'tyrantboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an oppressive ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDespotBoots : BEBoots {
	BEDespotBoots() : base() {
		$this.Name               = 'Despot Boots'
		$this.MapObjName         = 'despotboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an absolute ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOverlordBoots : BEBoots {
	BEOverlordBoots() : base() {
		$this.Name               = 'Overlord Boots'
		$this.MapObjName         = 'overlordboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a supreme master.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWarlordBoots : BEBoots {
	BEWarlordBoots() : base() {
		$this.Name               = 'Warlord Boots'
		$this.MapObjName         = 'warlordboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful military leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEChieftainBoots : BEBoots {
	BEChieftainBoots() : base() {
		$this.Name               = 'Chieftain Boots'
		$this.MapObjName         = 'chieftainboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a tribal leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEShamanBoots : BEBoots {
	BEShamanBoots() : base() {
		$this.Name               = 'Shaman Boots'
		$this.MapObjName         = 'shamanboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a spiritual guide.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOracleBoots : BEBoots {
	BEOracleBoots() : base() {
		$this.Name               = 'Oracle Boots'
		$this.MapObjName         = 'oracleboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that enhance prophetic visions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESeerBoots : BEBoots {
	BESeerBoots() : base() {
		$this.Name               = 'Seer Boots'
		$this.MapObjName         = 'seerboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that reveal hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEProphetBoots : BEBoots {
	BEProphetBoots() : base() {
		$this.Name               = 'Prophet Boots'
		$this.MapObjName         = 'prophetboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a divine messenger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESageBoots : BEBoots {
	BESageBoots() : base() {
		$this.Name               = 'Sage Boots'
		$this.MapObjName         = 'sageboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of profound wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScholarBoots : BEBoots {
	BEScholarBoots() : base() {
		$this.Name               = 'Scholar Boots'
		$this.MapObjName         = 'scholarboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by academic scholars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELibrarianBoots : BEBoots {
	BELibrarianBoots() : base() {
		$this.Name               = 'Librarian Boots'
		$this.MapObjName         = 'librarianboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for diligent keepers of knowledge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHistorianBoots : BEBoots {
	BEHistorianBoots() : base() {
		$this.Name               = 'Historian Boots'
		$this.MapObjName         = 'historianboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who study the past.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArchivistBoots : BEBoots {
	BEArchivistBoots() : base() {
		$this.Name               = 'Archivist Boots'
		$this.MapObjName         = 'archivistboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for protectors of ancient records.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtisanBoots : BEBoots {
	BEArtisanBoots() : base() {
		$this.Name               = 'Artisan Boots'
		$this.MapObjName         = 'artisanboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by skilled craftspeople.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEngineerBoots : BEBoots {
	BEEngineerBoots() : base() {
		$this.Name               = 'Engineer Boots'
		$this.MapObjName         = 'engineerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of mechanical innovators.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInventorBoots : BEBoots {
	BEInventorBoots() : base() {
		$this.Name               = 'Inventor Boots'
		$this.MapObjName         = 'inventorboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for creative minds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistBoots : BEBoots {
	BEAlchemistBoots() : base() {
		$this.Name               = 'Alchemist Boots'
		$this.MapObjName         = 'alchemistboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for those who transmute elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChemistBoots : BEBoots {
	BEChemistBoots() : base() {
		$this.Name               = 'Chemist Boots'
		$this.MapObjName         = 'chemistboots'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for scientific experimenters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBotanistBoots : BEBoots {
	BEBotanistBoots() : base() {
		$this.Name               = 'Botanist Boots'
		$this.MapObjName         = 'botanistboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for plant specialists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZoologistBoots : BEBoots {
	BEZoologistBoots() : base() {
		$this.Name               = 'Zoologist Boots'
		$this.MapObjName         = 'zoologistboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for animal researchers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGeologistBoots : BEBoots {
	BEGeologistBoots() : base() {
		$this.Name               = 'Geologist Boots'
		$this.MapObjName         = 'geologistboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for earth scientists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstronomerBoots : BEBoots {
	BEAstronomerBoots() : base() {
		$this.Name               = 'Astronomer Boots'
		$this.MapObjName         = 'astronomerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for star gazers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhilosopherBoots : BEBoots {
	BEPhilosopherBoots() : base() {
		$this.Name               = 'Philosopher Boots'
		$this.MapObjName         = 'philosopherboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for deep thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDiplomatBoots : BEBoots {
	BEDiplomatBoots() : base() {
		$this.Name               = 'Diplomat Boots'
		$this.MapObjName         = 'diplomatboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for negotiators and envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMediatorBoots : BEBoots {
	BEMediatorBoots() : base() {
		$this.Name               = 'Mediator Boots'
		$this.MapObjName         = 'mediatorboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for resolving conflicts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmissaryBoots : BEBoots {
	BEEmissaryBoots() : base() {
		$this.Name               = 'Emissary Boots'
		$this.MapObjName         = 'emissaryboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for special representatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmbassadorBoots : BEBoots {
	BEAmbassadorBoots() : base() {
		$this.Name               = 'Ambassador Boots'
		$this.MapObjName         = 'ambassadorboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for high-ranking envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESenatorBoots : BEBoots {
	BESenatorBoots() : base() {
		$this.Name               = 'Senator Boots'
		$this.MapObjName         = 'senatorboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a governmental official.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagistrateBoots : BEBoots {
	BEMagistrateBoots() : base() {
		$this.Name               = 'Magistrate Boots'
		$this.MapObjName         = 'magistrateboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a civil officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJudgeBoots : BEBoots {
	BEJudgeBoots() : base() {
		$this.Name               = 'Judge Boots'
		$this.MapObjName         = 'judgeboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a judicial authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESheriffBoots : BEBoots {
	BESheriffBoots() : base() {
		$this.Name               = 'Sheriff Boots'
		$this.MapObjName         = 'sheriffboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a law enforcer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMarshalBoots : BEBoots {
	BEMarshalBoots() : base() {
		$this.Name               = 'Marshal Boots'
		$this.MapObjName         = 'marshalboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a high-ranking law officer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEInvestigatorBoots : BEBoots {
	BEInvestigatorBoots() : base() {
		$this.Name               = 'Investigator Boots'
		$this.MapObjName         = 'investigatorboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for detectives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAnalystBoots : BEBoots {
	BEAnalystBoots() : base() {
		$this.Name               = 'Analyst Boots'
		$this.MapObjName         = 'analystboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for data examination.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForensicBoots : BEBoots {
	BEForensicBoots() : base() {
		$this.Name               = 'Forensic Boots'
		$this.MapObjName         = 'forensicboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for crime scene analysis.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETacticianBoots : BEBoots {
	BETacticianBoots() : base() {
		$this.Name               = 'Tactician Boots'
		$this.MapObjName         = 'tacticianboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for strategic thinkers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStrategistBoots : BEBoots {
	BEStrategistBoots() : base() {
		$this.Name               = 'Strategist Boots'
		$this.MapObjName         = 'strategistboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for grand scale planning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELogisticsBoots : BEBoots {
	BELogisticsBoots() : base() {
		$this.Name               = 'Logistics Boots'
		$this.MapObjName         = 'logisticsboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for supply management.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERecruiterBoots : BEBoots {
	BERecruiterBoots() : base() {
		$this.Name               = 'Recruiter Boots'
		$this.MapObjName         = 'recruiterboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for enlisting new members.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETrainerBoots : BEBoots {
	BETrainerBoots() : base() {
		$this.Name               = 'Trainer Boots'
		$this.MapObjName         = 'trainerboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for skill development.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMentorBoots : BEBoots {
	BEMentorBoots() : base() {
		$this.Name               = 'Mentor Boots'
		$this.MapObjName         = 'mentorboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for guiding others.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInstructorBoots : BEBoots {
	BEInstructorBoots() : base() {
		$this.Name               = 'Instructor Boots'
		$this.MapObjName         = 'instructorboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for teaching new techniques.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECoachBoots : BEBoots {
	BECoachBoots() : base() {
		$this.Name               = 'Coach Boots'
		$this.MapObjName         = 'coachboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for athletic guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEProspectorBoots : BEBoots {
	BEProspectorBoots() : base() {
		$this.Name               = 'Prospector Boots'
		$this.MapObjName         = 'prospectorboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for mineral seekers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinerBoots : BEBoots {
	BEMinerBoots() : base() {
		$this.Name               = 'Miner Boots'
		$this.MapObjName         = 'minerboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for underground excavation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEQuarrymanBoots : BEBoots {
	BEQuarrymanBoots() : base() {
		$this.Name               = 'Quarryman Boots'
		$this.MapObjName         = 'quarrymanboots'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for stone extraction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExcavatorBoots : BEBoots {
	BEExcavatorBoots() : base() {
		$this.Name               = 'Excavator Boots'
		$this.MapObjName         = 'excavatorboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for deep digging.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDelverBoots : BEBoots {
	BEDelverBoots() : base() {
		$this.Name               = 'Delver Boots'
		$this.MapObjName         = 'delverboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for exploring subterranean depths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpeleologistBoots : BEBoots {
	BESpeleologistBoots() : base() {
		$this.Name               = 'Speleologist Boots'
		$this.MapObjName         = 'speleologistboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for cave explorers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECavernBoots : BEBoots {
	BECavernBoots() : base() {
		$this.Name               = 'Cavern Boots'
		$this.MapObjName         = 'cavernboots'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for damp cave environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrottoBoots : BEBoots {
	BEGrottoBoots() : base() {
		$this.Name               = 'Grotto Boots'
		$this.MapObjName         = 'grottoboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for small cave systems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESubterraneanBoots : BEBoots {
	BESubterraneanBoots() : base() {
		$this.Name               = 'Subterranean Boots'
		$this.MapObjName         = 'subterraneanboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for underground travel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEUnderdarkBoots : BEBoots {
	BEUnderdarkBoots() : base() {
		$this.Name               = 'Underdark Boots'
		$this.MapObjName         = 'underdarkboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for the deep and dangerous underground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalBoots : BEBoots {
	BEAbyssalBoots() : base() {
		$this.Name               = 'Abyssal Boots'
		$this.MapObjName         = 'abyssalboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from the deepest chasms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernalBoots : BEBoots {
	BEInfernalBoots() : base() {
		$this.Name               = 'Infernal Boots'
		$this.MapObjName         = 'infernalboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots forged in the fires of hell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDemonicBoots : BEBoots {
	BEDemonicBoots() : base() {
		$this.Name               = 'Demonic Boots'
		$this.MapObjName         = 'demonicboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots infused with the essence of demons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFallenBoots : BEBoots {
	BEFallenBoots() : base() {
		$this.Name               = 'Fallen Boots'
		$this.MapObjName         = 'fallenboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a corrupted warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECorruptedBoots : BEBoots {
	BECorruptedBoots() : base() {
		$this.Name               = 'Corrupted Boots'
		$this.MapObjName         = 'corruptedboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots twisted by dark forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlightedBoots : BEBoots {
	BEBlightedBoots() : base() {
		$this.Name               = 'Blighted Boots'
		$this.MapObjName         = 'blightedboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots afflicted by a terrible curse.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlaguedBoots : BEBoots {
	BEPlaguedBoots() : base() {
		$this.Name               = 'Plagued Boots'
		$this.MapObjName         = 'plaguedboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots spreading disease and decay.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecroticBoots : BEBoots {
	BENecroticBoots() : base() {
		$this.Name               = 'Necrotic Boots'
		$this.MapObjName         = 'necroticboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots linked to death magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERevenantBoots : BEBoots {
	BERevenantBoots() : base() {
		$this.Name               = 'Revenant Boots'
		$this.MapObjName         = 'revenantboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one returned from the grave.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPhantomBoots : BEBoots {
	BEPhantomBoots() : base() {
		$this.Name               = 'Phantom Boots'
		$this.MapObjName         = 'phantomboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an elusive spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadeBoots : BEBoots {
	BEShadeBoots() : base() {
		$this.Name               = 'Shade Boots'
		$this.MapObjName         = 'shadeboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a shadowy entity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWraithBoots : BEBoots {
	BEWraithBoots() : base() {
		$this.Name               = 'Wraith Boots'
		$this.MapObjName         = 'wraithboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a malevolent specter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBansheeBoots : BEBoots {
	BEBansheeBoots() : base() {
		$this.Name               = 'Banshee Boots'
		$this.MapObjName         = 'bansheeboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that emit a mournful wail.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESuccubusBoots : BEBoots {
	BESuccubusBoots() : base() {
		$this.Name               = 'Succubus Boots'
		$this.MapObjName         = 'succubusboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a seductive demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEIncubusBoots : BEBoots {
	BEIncubusBoots() : base() {
		$this.Name               = 'Incubus Boots'
		$this.MapObjName         = 'incubusboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a charming demon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESirenBoots : BEBoots {
	BESirenBoots() : base() {
		$this.Name               = 'Siren Boots'
		$this.MapObjName         = 'sirenboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that lure sailors to their doom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDryadBoots : BEBoots {
	BEDryadBoots() : base() {
		$this.Name               = 'Dryad Boots'
		$this.MapObjName         = 'dryadboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from living wood, attuned to forests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENymphBoots : BEBoots {
	BENymphBoots() : base() {
		$this.Name               = 'Nymph Boots'
		$this.MapObjName         = 'nymphboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a beautiful nature spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESylphBoots : BEBoots {
	BESylphBoots() : base() {
		$this.Name               = 'Sylph Boots'
		$this.MapObjName         = 'sylphboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots of an air spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEUndineBoots : BEBoots {
	BEUndineBoots() : base() {
		$this.Name               = 'Undine Boots'
		$this.MapObjName         = 'undineboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a water spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESalamanderBoots : BEBoots {
	BESalamanderBoots() : base() {
		$this.Name               = 'Salamander Boots'
		$this.MapObjName         = 'salamanderboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a fire spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGnomeBoots : BEBoots {
	BEGnomeBoots() : base() {
		$this.Name               = 'Gnome Boots'
		$this.MapObjName         = 'gnomeboots'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Small but sturdy boots, crafted by gnomes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPixieBoots : BEBoots {
	BEPixieBoots() : base() {
		$this.Name               = 'Pixie Boots'
		$this.MapObjName         = 'pixieboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Tiny and almost weightless boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEFairyBoots : BEBoots {
	BEFairyBoots() : base() {
		$this.Name               = 'Fairy Boots'
		$this.MapObjName         = 'fairyboots'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Delicate and enchanting boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpriteBoots : BEBoots {
	BESpriteBoots() : base() {
		$this.Name               = 'Sprite Boots'
		$this.MapObjName         = 'spriteboots'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nimble boots of a playful spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BELeprechaunBoots : BEBoots {
	BELeprechaunBoots() : base() {
		$this.Name               = 'Leprechaun Boots'
		$this.MapObjName         = 'leprechaunboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that bring good fortune.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGoblinoidBoots : BEBoots {
	BEGoblinoidBoots() : base() {
		$this.Name               = 'Goblinoid Boots'
		$this.MapObjName         = 'goblinoidboots'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots favored by various goblinoid races.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKoboldBoots : BEBoots {
	BEKoboldBoots() : base() {
		$this.Name               = 'Kobold Boots'
		$this.MapObjName         = 'koboldboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude boots of kobolds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGnollBoots : BEBoots {
	BEGnollBoots() : base() {
		$this.Name               = 'Gnoll Boots'
		$this.MapObjName         = 'gnollboots'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough boots of hyena folk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBugbearBoots : BEBoots {
	BEBugbearBoots() : base() {
		$this.Name               = 'Bugbear Boots'
		$this.MapObjName         = 'bugbearboots'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots of bugbears.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOgreMageBoots : BEBoots {
	BEOgreMageBoots() : base() {
		$this.Name               = 'Ogre Mage Boots'
		$this.MapObjName         = 'ogremageboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful ogre mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BETrollBoots : BEBoots {
	BETrollBoots() : base() {
		$this.Name               = 'Troll Boots'
		$this.MapObjName         = 'trollboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots with regenerative properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEBeastBoots : BEBoots {
	BEBeastBoots() : base() {
		$this.Name               = 'Beast Boots'
		$this.MapObjName         = 'beastboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from monstrous beast hides.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHunterKillerBoots : BEBoots {
	BEHunterKillerBoots() : base() {
		$this.Name               = 'Hunter Killer Boots'
		$this.MapObjName         = 'hunterkillerboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for tracking and eliminating targets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEExecutionerBoots : BEBoots {
	BEExecutionerBoots() : base() {
		$this.Name               = 'Executioner Boots'
		$this.MapObjName         = 'executionerboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for swift and brutal justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPunisherBoots : BEBoots {
	BEPunisherBoots() : base() {
		$this.Name               = 'Punisher Boots'
		$this.MapObjName         = 'punisherboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of relentless retribution.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAvengerBoots : BEBoots {
	BEAvengerBoots() : base() {
		$this.Name               = 'Avenger Boots'
		$this.MapObjName         = 'avengerboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of righteous vengeance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERedeemerBoots : BEBoots {
	BERedeemerBoots() : base() {
		$this.Name               = 'Redeemer Boots'
		$this.MapObjName         = 'redeemerboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that bring salvation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEVindicatorBoots : BEBoots {
	BEVindicatorBoots() : base() {
		$this.Name               = 'Vindicator Boots'
		$this.MapObjName         = 'vindicatorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of justified defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGloryBoots : BEBoots {
	BEGloryBoots() : base() {
		$this.Name               = 'Glory Boots'
		$this.MapObjName         = 'gloryboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots signifying great honor and fame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEValorBoots : BEBoots {
	BEValorBoots() : base() {
		$this.Name               = 'Valor Boots'
		$this.MapObjName         = 'valorboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots embodying courage and bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChivalryBoots : BEBoots {
	BEChivalryBoots() : base() {
		$this.Name               = 'Chivalry Boots'
		$this.MapObjName         = 'chivalryboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots upholding the ideals of knighthood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEHonorBoots : BEBoots {
	BEHonorBoots() : base() {
		$this.Name               = 'Honor Boots'
		$this.MapObjName         = 'honorboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots symbolizing integrity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEJusticeBoots : BEBoots {
	BEJusticeBoots() : base() {
		$this.Name               = 'Justice Boots'
		$this.MapObjName         = 'justiceboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering fairness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERighteousBoots : BEBoots {
	BERighteousBoots() : base() {
		$this.Name               = 'Righteous Boots'
		$this.MapObjName         = 'righteousboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of moral rectitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVirtueBoots : BEBoots {
	BEVirtueBoots() : base() {
		$this.Name               = 'Virtue Boots'
		$this.MapObjName         = 'virtueboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots representing moral excellence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPurityBoots : BEBoots {
	BEPurityBoots() : base() {
		$this.Name               = 'Purity Boots'
		$this.MapObjName         = 'purityboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of untainted essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEInnocenceBoots : BEBoots {
	BEInnocenceBoots() : base() {
		$this.Name               = 'Innocence Boots'
		$this.MapObjName         = 'innocenceboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a pure heart.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEHopeBoots : BEBoots {
	BEHopeBoots() : base() {
		$this.Name               = 'Hope Boots'
		$this.MapObjName         = 'hopeboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that inspire optimism.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFaithBoots : BEBoots {
	BEFaithBoots() : base() {
		$this.Name               = 'Faith Boots'
		$this.MapObjName         = 'faithboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering belief.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECharityBoots : BEBoots {
	BECharityBoots() : base() {
		$this.Name               = 'Charity Boots'
		$this.MapObjName         = 'charityboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that embody benevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECourageBoots : BEBoots {
	BECourageBoots() : base() {
		$this.Name               = 'Courage Boots'
		$this.MapObjName         = 'courageboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that instill bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWisdomBoots : BEBoots {
	BEWisdomBoots() : base() {
		$this.Name               = 'Wisdom Boots'
		$this.MapObjName         = 'wisdomboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of profound insight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnowledgeBoots : BEBoots {
	BEKnowledgeBoots() : base() {
		$this.Name               = 'Knowledge Boots'
		$this.MapObjName         = 'knowledgeboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that hold vast information.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETruthBoots : BEBoots {
	BETruthBoots() : base() {
		$this.Name               = 'Truth Boots'
		$this.MapObjName         = 'truthboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that reveal falsehoods.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDisciplineBoots : BEBoots {
	BEDisciplineBoots() : base() {
		$this.Name               = 'Discipline Boots'
		$this.MapObjName         = 'disciplineboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that promote self-control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPatienceBoots : BEBoots {
	BEPatienceBoots() : base() {
		$this.Name               = 'Patience Boots'
		$this.MapObjName         = 'patienceboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that foster endurance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPerseveranceBoots : BEBoots {
	BEPerseveranceBoots() : base() {
		$this.Name               = 'Perseverance Boots'
		$this.MapObjName         = 'perseveranceboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that encourage persistence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

