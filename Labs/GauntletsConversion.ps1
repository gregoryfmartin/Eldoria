Class BEIronGauntlets : BEGauntlets {
	BEIronGauntlets() : base() {
		$this.Name               = 'Iron Gauntlets'
		$this.MapObjName         = 'irongauntlets'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard blacksmith-forged gauntlets, offering basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherGauntlets : BEGauntlets {
	BELeatherGauntlets() : base() {
		$this.Name               = 'Leather Gauntlets'
		$this.MapObjName         = 'leathergauntlets'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 4
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight leather gloves, offering dexterity with minimal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzeFists : BEGauntlets {
	BEBronzeFists() : base() {
		$this.Name               = 'Bronze Fists'
		$this.MapObjName         = 'bronzefists'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but sturdy bronze gauntlets, heavy and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESteelGauntlets : BEGauntlets {
	BESteelGauntlets() : base() {
		$this.Name               = 'Steel Gauntlets'
		$this.MapObjName         = 'steelgauntlets'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced steel gauntlets, a common choice for adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaddedMitts : BEGauntlets {
	BEPaddedMitts() : base() {
		$this.Name               = 'Padded Mitts'
		$this.MapObjName         = 'paddedmitts'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thickly padded gloves, offering surprising magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEHuntersGrips : BEGauntlets {
	BEHuntersGrips() : base() {
		$this.Name               = 'Hunter''s Grips'
		$this.MapObjName         = 'huntersgrips'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 5
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Agile gauntlets favored by hunters, enhancing precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarriorsGauntlets : BEGauntlets {
	BEWarriorsGauntlets() : base() {
		$this.Name               = 'Warrior''s Gauntlets'
		$this.MapObjName         = 'warriorsgauntlets'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Solid gauntlets for frontline fighters, focusing on physical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESorcerersBands : BEGauntlets {
	BESorcerersBands() : base() {
		$this.Name               = 'Sorcerer''s Bands'
		$this.MapObjName         = 'sorcerersbands'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enchanted wristbands, amplifying magical potency.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChainmailGauntlets : BEGauntlets {
	BEChainmailGauntlets() : base() {
		$this.Name               = 'Chainmail Gauntlets'
		$this.MapObjName         = 'chainmailgauntlets'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Flexible chainmail providing good all-around protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThiefsGloves : BEGauntlets {
	BEThiefsGloves() : base() {
		$this.Name               = 'Thief''s Gloves'
		$this.MapObjName         = 'thiefsgloves'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 6
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thin, dark gloves used for stealth and quick movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESentinelGauntlets : BEGauntlets {
	BESentinelGauntlets() : base() {
		$this.Name               = 'Sentinel Gauntlets'
		$this.MapObjName         = 'sentinelgauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy duty gauntlets for guardians, built for endurance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMysticHandguards : BEGauntlets {
	BEMysticHandguards() : base() {
		$this.Name               = 'Mystic Handguards'
		$this.MapObjName         = 'mystichandguards'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with faint arcane energy, boosting magic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGuardCaptainGauntlets : BEGauntlets {
	BEGuardCaptainGauntlets() : base() {
		$this.Name               = 'Guard Captain Gauntlets'
		$this.MapObjName         = 'guardcaptaingauntlets'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by experienced guards, providing reliable defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBerserkersFists : BEGauntlets {
	BEBerserkersFists() : base() {
		$this.Name               = 'Berserker''s Fists'
		$this.MapObjName         = 'berserkersfists'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 2
			[StatId]::Accuracy = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude, spiked gauntlets for aggressive combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEArchersBracers : BEGauntlets {
	BEArchersBracers() : base() {
		$this.Name               = 'Archer''s Bracers'
		$this.MapObjName         = 'archersbracers'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 4
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and flexible bracers for archers, aiding aim.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHolyGauntlets : BEGauntlets {
	BEHolyGauntlets() : base() {
		$this.Name               = 'Holy Gauntlets'
		$this.MapObjName         = 'holygauntlets'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed gauntlets, offering protection against dark forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowGrips : BEGauntlets {
	BEShadowGrips() : base() {
		$this.Name               = 'Shadow Grips'
		$this.MapObjName         = 'shadowgrips'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, lightweight gloves for those who operate in shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnightsGauntlets : BEGauntlets {
	BEKnightsGauntlets() : base() {
		$this.Name               = 'Knight''s Gauntlets'
		$this.MapObjName         = 'knightsgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Polished and robust gauntlets, fit for a knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEClericsCuffs : BEGauntlets {
	BEClericsCuffs() : base() {
		$this.Name               = 'Cleric''s Cuffs'
		$this.MapObjName         = 'clericscuffs'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple cuffs worn by clerics, aiding in divine magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDraconianClaws : BEGauntlets {
	BEDraconianClaws() : base() {
		$this.Name               = 'Draconian Claws'
		$this.MapObjName         = 'draconianclaws'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from dragon scales, exceptionally strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenWeaveGloves : BEGauntlets {
	BEElvenWeaveGloves() : base() {
		$this.Name               = 'Elven Weave Gloves'
		$this.MapObjName         = 'elvenweavegloves'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Intricately woven gloves, light and magically resistant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDwarvenStonefists : BEGauntlets {
	BEDwarvenStonefists() : base() {
		$this.Name               = 'Dwarven Stonefists'
		$this.MapObjName         = 'dwarvenstonefists'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stone-infused gauntlets, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantedArmbands : BEGauntlets {
	BEEnchantedArmbands() : base() {
		$this.Name               = 'Enchanted Armbands'
		$this.MapObjName         = 'enchantedarmbands'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armbands pulsating with magical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGladiatorsGauntlets : BEGauntlets {
	BEGladiatorsGauntlets() : base() {
		$this.Name               = 'Gladiator''s Gauntlets'
		$this.MapObjName         = 'gladiatorsgauntlets'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough yet effective gauntlets for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEApprenticesMitts : BEGauntlets {
	BEApprenticesMitts() : base() {
		$this.Name               = 'Apprentice''s Mitts'
		$this.MapObjName         = 'apprenticesmitts'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic gloves for a budding spellcaster.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelersGloves : BEGauntlets {
	BETravelersGloves() : base() {
		$this.Name               = 'Traveler''s Gloves'
		$this.MapObjName         = 'travelersgloves'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple, comfortable gloves for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrusadersGauntlets : BEGauntlets {
	BECrusadersGauntlets() : base() {
		$this.Name               = 'Crusader''s Gauntlets'
		$this.MapObjName         = 'crusadersgauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, ornate gauntlets for a holy warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMoonlitBands : BEGauntlets {
	BEMoonlitBands() : base() {
		$this.Name               = 'Moonlit Bands'
		$this.MapObjName         = 'moonlitbands'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silken bands that shimmer with lunar light, boosting mystical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVeteransGrips : BEGauntlets {
	BEVeteransGrips() : base() {
		$this.Name               = 'Veteran''s Grips'
		$this.MapObjName         = 'veteransgrips'
		$this.PurchasePrice      = 410
		$this.SellPrice          = 205
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Well-worn gauntlets of an experienced fighter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernClaws : BEGauntlets {
	BEWyvernClaws() : base() {
		$this.Name               = 'Wyvern Claws'
		$this.MapObjName         = 'wyvernclaws'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with wyvern talons, sharp and intimidating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECelestialGauntlets : BEGauntlets {
	BECelestialGauntlets() : base() {
		$this.Name               = 'Celestial Gauntlets'
		$this.MapObjName         = 'celestialgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be forged from starlight, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlocksWraps : BEGauntlets {
	BEWarlocksWraps() : base() {
		$this.Name               = 'Warlock''s Wraps'
		$this.MapObjName         = 'warlockswraps'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark wraps enhancing destructive magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPaladinsVambraces : BEGauntlets {
	BEPaladinsVambraces() : base() {
		$this.Name               = 'Paladin''s Vambraces'
		$this.MapObjName         = 'paladinsvambraces'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Polished vambraces of a sworn protector.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritWovenGloves : BEGauntlets {
	BESpiritWovenGloves() : base() {
		$this.Name               = 'Spirit Woven Gloves'
		$this.MapObjName         = 'spiritwovengloves'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with spectral threads, offering ethereal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarkIronGauntlets : BEGauntlets {
	BEDarkIronGauntlets() : base() {
		$this.Name               = 'Dark Iron Gauntlets'
		$this.MapObjName         = 'darkirongauntlets'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from dark iron, ominous and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOraclesHandguards : BEGauntlets {
	BEOraclesHandguards() : base() {
		$this.Name               = 'Oracle''s Handguards'
		$this.MapObjName         = 'oracleshandguards'
		$this.PurchasePrice      = 540
		$this.SellPrice          = 270
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 27
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards that hum with prophetic energy, aiding foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERoyalGauntlets : BEGauntlets {
	BERoyalGauntlets() : base() {
		$this.Name               = 'Royal Gauntlets'
		$this.MapObjName         = 'royalgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Finely crafted gauntlets, fit for royalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAssassinsClaws : BEGauntlets {
	BEAssassinsClaws() : base() {
		$this.Name               = 'Assassin''s Claws'
		$this.MapObjName         = 'assassinsclaws'
		$this.PurchasePrice      = 340
		$this.SellPrice          = 170
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 9
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sleek, sharp gauntlets designed for quick strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansFists : BEGauntlets {
	BETitansFists() : base() {
		$this.Name               = 'Titan''s Fists'
		$this.MapObjName         = 'titansfists'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets rumored to be from a giant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPhoenixGloves : BEGauntlets {
	BEPhoenixGloves() : base() {
		$this.Name               = 'Phoenix Gloves'
		$this.MapObjName         = 'phoenixgloves'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves said to be touched by a phoenix, offering fiery defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAbyssalGauntlets : BEGauntlets {
	BEAbyssalGauntlets() : base() {
		$this.Name               = 'Abyssal Gauntlets'
		$this.MapObjName         = 'abyssalgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the depths, reeking of darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunesmithsGauntlets : BEGauntlets {
	BERunesmithsGauntlets() : base() {
		$this.Name               = 'Runesmith''s Gauntlets'
		$this.MapObjName         = 'runesmithsgauntlets'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets inscribed with powerful runes, enhancing craftsmanship and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHarpyTalons : BEGauntlets {
	BEHarpyTalons() : base() {
		$this.Name               = 'Harpy Talons'
		$this.MapObjName         = 'harpytalons'
		$this.PurchasePrice      = 390
		$this.SellPrice          = 195
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light gauntlets with sharp tips, good for quick attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGorgonsGrip : BEGauntlets {
	BEGorgonsGrip() : base() {
		$this.Name               = 'Gorgon''s Grip'
		$this.MapObjName         = 'gorgonsgrip'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Petrifying gauntlets that can turn foes to stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertNomadGloves : BEGauntlets {
	BEDesertNomadGloves() : base() {
		$this.Name               = 'Desert Nomad Gloves'
		$this.MapObjName         = 'desertnomadgloves'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 5
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dust-resistant gloves for arid environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostbiteGauntlets : BEGauntlets {
	BEFrostbiteGauntlets() : base() {
		$this.Name               = 'Frostbite Gauntlets'
		$this.MapObjName         = 'frostbitegauntlets'
		$this.PurchasePrice      = 760
		$this.SellPrice          = 380
		$this.TargetStats        = @{
			[StatId]::Defense = 34
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating chilling energy, freezing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESunstoneCuffs : BEGauntlets {
	BESunstoneCuffs() : base() {
		$this.Name               = 'Sunstone Cuffs'
		$this.MapObjName         = 'sunstonecuffs'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs glowing with warm sunlight, providing healing and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBeastkinGauntlets : BEGauntlets {
	BEBeastkinGauntlets() : base() {
		$this.Name               = 'Beastkin Gauntlets'
		$this.MapObjName         = 'beastkingauntlets'
		$this.PurchasePrice      = 430
		$this.SellPrice          = 215
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from tough beast hide, wild and untamed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemGauntlets : BEGauntlets {
	BEGolemGauntlets() : base() {
		$this.Name               = 'Golem Gauntlets'
		$this.MapObjName         = 'golemgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, stone-like gauntlets, nearly indestructible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShamansHandwraps : BEGauntlets {
	BEShamansHandwraps() : base() {
		$this.Name               = 'Shaman''s Handwraps'
		$this.MapObjName         = 'shamanshandwraps'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple wraps used in rituals, channeling natural magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrGloves : BEGauntlets {
	BEZephyrGloves() : base() {
		$this.Name               = 'Zephyr Gloves'
		$this.MapObjName         = 'zephyrgloves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves light as air, granting incredible speed and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampiresEmbrace : BEGauntlets {
	BEVampiresEmbrace() : base() {
		$this.Name               = 'Vampire''s Embrace'
		$this.MapObjName         = 'vampiresembrace'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to drain life from enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreadnoughtGauntlets : BEGauntlets {
	BEDreadnoughtGauntlets() : base() {
		$this.Name               = 'Dreadnought Gauntlets'
		$this.MapObjName         = 'dreadnoughtgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive, intimidating gauntlets for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFaerieSilkGloves : BEGauntlets {
	BEFaerieSilkGloves() : base() {
		$this.Name               = 'Faerie Silk Gloves'
		$this.MapObjName         = 'faeriesilkgloves'
		$this.PurchasePrice      = 560
		$this.SellPrice          = 280
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from mystical faerie silk, incredibly soft yet protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESavageGauntlets : BEGauntlets {
	BESavageGauntlets() : base() {
		$this.Name               = 'Savage Gauntlets'
		$this.MapObjName         = 'savagegauntlets'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brutal, unrefined gauntlets for savage warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStormcallerBands : BEGauntlets {
	BEStormcallerBands() : base() {
		$this.Name               = 'Stormcaller Bands'
		$this.MapObjName         = 'stormcallerbands'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands crackling with elemental energy, summoning lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidGauntlets : BEGauntlets {
	BEVoidGauntlets() : base() {
		$this.Name               = 'Void Gauntlets'
		$this.MapObjName         = 'voidgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the void, absorbing magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineAegis : BEGauntlets {
	BEDivineAegis() : base() {
		$this.Name               = 'Divine Aegis'
		$this.MapObjName         = 'divineaegis'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets offering supreme divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernoFists : BEGauntlets {
	BEInfernoFists() : base() {
		$this.Name               = 'Inferno Fists'
		$this.MapObjName         = 'infernofists'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets ablaze with eternal flames, burning all who touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESeraphicMitts : BEGauntlets {
	BESeraphicMitts() : base() {
		$this.Name               = 'Seraphic Mitts'
		$this.MapObjName         = 'seraphicmitts'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feather-light mitts of angelic origin, offering celestial defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBarbariansCuffs : BEGauntlets {
	BEBarbariansCuffs() : base() {
		$this.Name               = 'Barbarian''s Cuffs'
		$this.MapObjName         = 'barbarianscuffs'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough, leather cuffs for a primal warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERunepowderGauntlets : BEGauntlets {
	BERunepowderGauntlets() : base() {
		$this.Name               = 'Runepowder Gauntlets'
		$this.MapObjName         = 'runepowdergauntlets'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with explosive runepowder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialHandguards : BEGauntlets {
	BEGlacialHandguards() : base() {
		$this.Name               = 'Glacial Handguards'
		$this.MapObjName         = 'glacialhandguards'
		$this.PurchasePrice      = 740
		$this.SellPrice          = 370
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards emitting an icy aura, slowing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonGauntlets : BEGauntlets {
	BECrimsonGauntlets() : base() {
		$this.Name               = 'Crimson Gauntlets'
		$this.MapObjName         = 'crimsongauntlets'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blood-stained gauntlets of a ruthless warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmeraldBands : BEGauntlets {
	BEEmeraldBands() : base() {
		$this.Name               = 'Emerald Bands'
		$this.MapObjName         = 'emeraldbands'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands gleaming with verdant energy, restoring vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEObsidianFists : BEGauntlets {
	BEObsidianFists() : base() {
		$this.Name               = 'Obsidian Fists'
		$this.MapObjName         = 'obsidianfists'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from volcanic obsidian, sharp and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpecterGloves : BEGauntlets {
	BESpecterGloves() : base() {
		$this.Name               = 'Specter Gloves'
		$this.MapObjName         = 'spectergloves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing passage through solid objects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGloomGauntlets : BEGauntlets {
	BEGloomGauntlets() : base() {
		$this.Name               = 'Gloom Gauntlets'
		$this.MapObjName         = 'gloomgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to absorb light and hope.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsBracers : BEGauntlets {
	BEZealotsBracers() : base() {
		$this.Name               = 'Zealot''s Bracers'
		$this.MapObjName         = 'zealotsbracers'
		$this.PurchasePrice      = 790
		$this.SellPrice          = 395
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers of a fanatical warrior, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEChronoCuffs : BEGauntlets {
	BEChronoCuffs() : base() {
		$this.Name               = 'Chrono Cuffs'
		$this.MapObjName         = 'chronocuffs'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs that subtly manipulate time, improving reaction speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancersGrips : BEGauntlets {
	BENecromancersGrips() : base() {
		$this.Name               = 'Necromancer''s Grips'
		$this.MapObjName         = 'necromancersgrips'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that draw power from the deceased.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemiteGauntlets : BEGauntlets {
	BEGolemiteGauntlets() : base() {
		$this.Name               = 'Golemite Gauntlets'
		$this.MapObjName         = 'golemitegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets made from animated stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverleafGloves : BEGauntlets {
	BESilverleafGloves() : base() {
		$this.Name               = 'Silverleaf Gloves'
		$this.MapObjName         = 'silverleafgloves'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from mystical silverleaf, light and protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpikedGauntlets : BEGauntlets {
	BESpikedGauntlets() : base() {
		$this.Name               = 'Spiked Gauntlets'
		$this.MapObjName         = 'spikedgauntlets'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets with sharp spikes for offensive maneuvers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherialBands : BEGauntlets {
	BEAetherialBands() : base() {
		$this.Name               = 'Aetherial Bands'
		$this.MapObjName         = 'aetherialbands'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands pulsating with pure magical essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyrmhideGauntlets : BEGauntlets {
	BEWyrmhideGauntlets() : base() {
		$this.Name               = 'Wyrmhide Gauntlets'
		$this.MapObjName         = 'wyrmhidegauntlets'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 31
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the tough hide of a lesser wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneguardGauntlets : BEGauntlets {
	BEStoneguardGauntlets() : base() {
		$this.Name               = 'Stoneguard Gauntlets'
		$this.MapObjName         = 'stoneguardgauntlets'
		$this.PurchasePrice      = 670
		$this.SellPrice          = 335
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets reinforced with elemental earth, sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOceanicGauntlets : BEGauntlets {
	BEOceanicGauntlets() : base() {
		$this.Name               = 'Oceanic Gauntlets'
		$this.MapObjName         = 'oceanicgauntlets'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets smelling of the sea, aiding in water spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBlazefireGauntlets : BEGauntlets {
	BEBlazefireGauntlets() : base() {
		$this.Name               = 'Blazefire Gauntlets'
		$this.MapObjName         = 'blazefiregauntlets'
		$this.PurchasePrice      = 930
		$this.SellPrice          = 465
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating intense heat, burning enemies on contact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELunarGauntlets : BEGauntlets {
	BELunarGauntlets() : base() {
		$this.Name               = 'Lunar Gauntlets'
		$this.MapObjName         = 'lunargauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 28
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that glow with soft moonlight, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESolarBracers : BEGauntlets {
	BESolarBracers() : base() {
		$this.Name               = 'Solar Bracers'
		$this.MapObjName         = 'solarbracers'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers that pulse with sun''s energy, healing allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVanguardGauntlets : BEGauntlets {
	BEVanguardGauntlets() : base() {
		$this.Name               = 'Vanguard Gauntlets'
		$this.MapObjName         = 'vanguardgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The first line of defense, heavy and reliable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStormforgedFists : BEGauntlets {
	BEStormforgedFists() : base() {
		$this.Name               = 'Stormforged Fists'
		$this.MapObjName         = 'stormforgedfists'
		$this.PurchasePrice      = 960
		$this.SellPrice          = 480
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged in a thunderstorm, crackling with power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotGauntlets : BEGauntlets {
	BEZealotGauntlets() : base() {
		$this.Name               = 'Zealot Gauntlets'
		$this.MapObjName         = 'zealotgauntlets'
		$this.PurchasePrice      = 1020
		$this.SellPrice          = 510
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ornately decorated gauntlets, inspiring divine fury.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEShadowstitchGloves : BEGauntlets {
	BEShadowstitchGloves() : base() {
		$this.Name               = 'Shadowstitch Gloves'
		$this.MapObjName         = 'shadowstitchgloves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves sewn from threads of shadow, providing stealth and agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncientRuneGauntlets : BEGauntlets {
	BEAncientRuneGauntlets() : base() {
		$this.Name               = 'Ancient Rune Gauntlets'
		$this.MapObjName         = 'ancientrunegauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets covered in ancient, forgotten runes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodboundGauntlets : BEGauntlets {
	BEBloodboundGauntlets() : base() {
		$this.Name               = 'Bloodbound Gauntlets'
		$this.MapObjName         = 'bloodboundgauntlets'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that empower the wearer with every wound taken.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarlightGauntlets : BEGauntlets {
	BEStarlightGauntlets() : base() {
		$this.Name               = 'Starlight Gauntlets'
		$this.MapObjName         = 'starlightgauntlets'
		$this.PurchasePrice      = 1080
		$this.SellPrice          = 540
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 36
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets shimmering with starlight, offering celestial guidance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrystalineGauntlets : BEGauntlets {
	BECrystalineGauntlets() : base() {
		$this.Name               = 'Crystaline Gauntlets'
		$this.MapObjName         = 'crystalinegauntlets'
		$this.PurchasePrice      = 910
		$this.SellPrice          = 455
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets formed from pure crystal, fragile yet powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravehandGloves : BEGauntlets {
	BEGravehandGloves() : base() {
		$this.Name               = 'Gravehand Gloves'
		$this.MapObjName         = 'gravehandgloves'
		$this.PurchasePrice      = 770
		$this.SellPrice          = 385
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that chill to the touch, connected to the underworld.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonhideGauntlets : BEGauntlets {
	BEDragonhideGauntlets() : base() {
		$this.Name               = 'Dragonhide Gauntlets'
		$this.MapObjName         = 'dragonhidegauntlets'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from the hide of a mature dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDreamweaverBands : BEGauntlets {
	BEDreamweaverBands() : base() {
		$this.Name               = 'Dreamweaver Bands'
		$this.MapObjName         = 'dreamweaverbands'
		$this.PurchasePrice      = 830
		$this.SellPrice          = 415
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that allow the wearer to influence dreams and minds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEIroncladGauntlets : BEGauntlets {
	BEIroncladGauntlets() : base() {
		$this.Name               = 'Ironclad Gauntlets'
		$this.MapObjName         = 'ironcladgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Exceptionally sturdy gauntlets, heavy but impenetrable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulforgedGauntlets : BEGauntlets {
	BESoulforgedGauntlets() : base() {
		$this.Name               = 'Soulforged Gauntlets'
		$this.MapObjName         = 'soulforgedgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a captured soul, granting dark power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAngelicGauntlets : BEGauntlets {
	BEAngelicGauntlets() : base() {
		$this.Name               = 'Angelic Gauntlets'
		$this.MapObjName         = 'angelicgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the heavens, radiating purity and light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDemonicClaws : BEGauntlets {
	BEDemonicClaws() : base() {
		$this.Name               = 'Demonic Claws'
		$this.MapObjName         = 'demonicclaws'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vicious gauntlets from the fiery pits, dripping with malice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEbonGauntlets : BEGauntlets {
	BEEbonGauntlets() : base() {
		$this.Name               = 'Ebon Gauntlets'
		$this.MapObjName         = 'ebongauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from solidified darkness, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BERadiantFists : BEGauntlets {
	BERadiantFists() : base() {
		$this.Name               = 'Radiant Fists'
		$this.MapObjName         = 'radiantfists'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists that glow with holy light, scorching evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVoidforgedGauntlets : BEGauntlets {
	BEVoidforgedGauntlets() : base() {
		$this.Name               = 'Voidforged Gauntlets'
		$this.MapObjName         = 'voidforgedgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted in the heart of the void, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMythrilGauntlets : BEGauntlets {
	BEMythrilGauntlets() : base() {
		$this.Name               = 'Mythril Gauntlets'
		$this.MapObjName         = 'mythrilgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of legendary mythril, light yet incredibly strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantiteGauntlets : BEGauntlets {
	BEAdamantiteGauntlets() : base() {
		$this.Name               = 'Adamantite Gauntlets'
		$this.MapObjName         = 'adamantitegauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of the hardest known metal, virtually unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlimmeringGauntlets : BEGauntlets {
	BEGlimmeringGauntlets() : base() {
		$this.Name               = 'Glimmering Gauntlets'
		$this.MapObjName         = 'glimmeringgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that sparkle with a faint, magical light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStonehideGloves : BEGauntlets {
	BEStonehideGloves() : base() {
		$this.Name               = 'Stonehide Gloves'
		$this.MapObjName         = 'stonehidegloves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from petrified animal hide, surprisingly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilentWraps : BEGauntlets {
	BESilentWraps() : base() {
		$this.Name               = 'Silent Wraps'
		$this.MapObjName         = 'silentwraps'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 7
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Soft wraps for quiet movement, favored by scouts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyrmfangGauntlets : BEGauntlets {
	BEWyrmfangGauntlets() : base() {
		$this.Name               = 'Wyrmfang Gauntlets'
		$this.MapObjName         = 'wyrmfanggauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets tipped with the fangs of a juvenile wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWhisperwindBands : BEGauntlets {
	BEWhisperwindBands() : base() {
		$this.Name               = 'Whisperwind Bands'
		$this.MapObjName         = 'whisperwindbands'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 23
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that carry the faintest whispers, granting keen senses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOgreGauntlets : BEGauntlets {
	BEOgreGauntlets() : base() {
		$this.Name               = 'Ogre Gauntlets'
		$this.MapObjName         = 'ogregauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude and massive gauntlets, for the strongest warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDryadsEmbrace : BEGauntlets {
	BEDryadsEmbrace() : base() {
		$this.Name               = 'Dryad''s Embrace'
		$this.MapObjName         = 'dryadsembrace'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with living vines, connected to nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEForgeheartGauntlets : BEGauntlets {
	BEForgeheartGauntlets() : base() {
		$this.Name               = 'Forgeheart Gauntlets'
		$this.MapObjName         = 'forgeheartgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from a master smith''s forge, enduring and hot.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStonetoothFists : BEGauntlets {
	BEStonetoothFists() : base() {
		$this.Name               = 'Stonetooth Fists'
		$this.MapObjName         = 'stonetoothfists'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with jagged, stone-like knuckles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDeepwoodGrips : BEGauntlets {
	BEDeepwoodGrips() : base() {
		$this.Name               = 'Deepwood Grips'
		$this.MapObjName         = 'deepwoodgrips'
		$this.PurchasePrice      = 360
		$this.SellPrice          = 180
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from ancient forest materials, blending with shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialSphereGauntlets : BEGauntlets {
	BECelestialSphereGauntlets() : base() {
		$this.Name               = 'Celestial Sphere Gauntlets'
		$this.MapObjName         = 'celestialspheregauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with miniature celestial spheres, aiding astral magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowbinderGauntlets : BEGauntlets {
	BEShadowbinderGauntlets() : base() {
		$this.Name               = 'Shadowbinder Gauntlets'
		$this.MapObjName         = 'shadowbindergauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to control shadows, binding foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDrakeskinGauntlets : BEGauntlets {
	BEDrakeskinGauntlets() : base() {
		$this.Name               = 'Drakeskin Gauntlets'
		$this.MapObjName         = 'drakeskingauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the durable hide of a drake.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEChitinousGauntlets : BEGauntlets {
	BEChitinousGauntlets() : base() {
		$this.Name               = 'Chitinous Gauntlets'
		$this.MapObjName         = 'chitinousgauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from hardened insect chitin, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVikingsBracers : BEGauntlets {
	BEVikingsBracers() : base() {
		$this.Name               = 'Viking''s Bracers'
		$this.MapObjName         = 'vikingsbracers'
		$this.PurchasePrice      = 330
		$this.SellPrice          = 165
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy bracers for a seafaring warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESirensGloves : BEGauntlets {
	BESirensGloves() : base() {
		$this.Name               = 'Siren''s Gloves'
		$this.MapObjName         = 'sirensgloves'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with a captivating aura, charming adversaries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGargoyleGauntlets : BEGauntlets {
	BEGargoyleGauntlets() : base() {
		$this.Name               = 'Gargoyle Gauntlets'
		$this.MapObjName         = 'gargoylegauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets resembling gargoyle claws, stony and imposing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReapersGrasp : BEGauntlets {
	BEReapersGrasp() : base() {
		$this.Name               = 'Reaper''s Grasp'
		$this.MapObjName         = 'reapersgrasp'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that chill the soul, wielding spectral power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenGauntlets : BEGauntlets {
	BESunkenGauntlets() : base() {
		$this.Name               = 'Sunken Gauntlets'
		$this.MapObjName         = 'sunkengauntlets'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Barnacle-encrusted gauntlets from a forgotten wreck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETempestFists : BEGauntlets {
	BETempestFists() : base() {
		$this.Name               = 'Tempest Fists'
		$this.MapObjName         = 'tempestfists'
		$this.PurchasePrice      = 970
		$this.SellPrice          = 485
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists crackling with the raw energy of a storm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWispweaveGloves : BEGauntlets {
	BEWispweaveGloves() : base() {
		$this.Name               = 'Wispweave Gloves'
		$this.MapObjName         = 'wispweavegloves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 32
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made of ethereal wisp material, nearly invisible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BENomadsGauntlets : BEGauntlets {
	BENomadsGauntlets() : base() {
		$this.Name               = 'Nomad''s Gauntlets'
		$this.MapObjName         = 'nomadsgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Practical and robust gauntlets for a wanderer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAshwoodGauntlets : BEGauntlets {
	BEAshwoodGauntlets() : base() {
		$this.Name               = 'Ashwood Gauntlets'
		$this.MapObjName         = 'ashwoodgauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from ancient ashwood, light and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodsteelGauntlets : BEGauntlets {
	BEBloodsteelGauntlets() : base() {
		$this.Name               = 'Bloodsteel Gauntlets'
		$this.MapObjName         = 'bloodsteelgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged with blood ritual, dark and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarfallGauntlets : BEGauntlets {
	BEStarfallGauntlets() : base() {
		$this.Name               = 'Starfall Gauntlets'
		$this.MapObjName         = 'starfallgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fallen star fragments, radiating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOraclesTouch : BEGauntlets {
	BEOraclesTouch() : base() {
		$this.Name               = 'Oracle''s Touch'
		$this.MapObjName         = 'oraclestouch'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 36
			[StatId]::Accuracy = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing brief glimpses into the future, improving reaction.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGriffinRidersGauntlets : BEGauntlets {
	BEGriffinRidersGauntlets() : base() {
		$this.Name               = 'Griffin Rider''s Gauntlets'
		$this.MapObjName         = 'griffinridersgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aerodynamic gauntlets for those who ride the skies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOnyxFists : BEGauntlets {
	BEOnyxFists() : base() {
		$this.Name               = 'Onyx Fists'
		$this.MapObjName         = 'onyxfists'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from dark onyx, absorbing negative energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrweaveGauntlets : BEGauntlets {
	BEZephyrweaveGauntlets() : base() {
		$this.Name               = 'Zephyrweave Gauntlets'
		$this.MapObjName         = 'zephyrweavegauntlets'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 27
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets woven from enchanted air, granting swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECragskinGauntlets : BEGauntlets {
	BECragskinGauntlets() : base() {
		$this.Name               = 'Cragskin Gauntlets'
		$this.MapObjName         = 'cragskingauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from hardened mountain hide, durable and rugged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMysticSentinelGauntlets : BEGauntlets {
	BEMysticSentinelGauntlets() : base() {
		$this.Name               = 'Mystic Sentinel Gauntlets'
		$this.MapObjName         = 'mysticsentinelgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of an ancient order, protecting magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEInfernalGrips : BEGauntlets {
	BEInfernalGrips() : base() {
		$this.Name               = 'Infernal Grips'
		$this.MapObjName         = 'infernalgrips'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that burn with a malevolent fire, searing enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAegisGauntlets : BEGauntlets {
	BEAegisGauntlets() : base() {
		$this.Name               = 'Aegis Gauntlets'
		$this.MapObjName         = 'aegisgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an invisible shield, deflecting attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidcallersCuffs : BEGauntlets {
	BEVoidcallersCuffs() : base() {
		$this.Name               = 'Voidcaller''s Cuffs'
		$this.MapObjName         = 'voidcallerscuffs'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs that resonate with the void, amplifying dark spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravewardGauntlets : BEGauntlets {
	BEGravewardGauntlets() : base() {
		$this.Name               = 'Graveward Gauntlets'
		$this.MapObjName         = 'gravewardgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a silent guardian, protecting sacred grounds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECelestialHandguards : BEGauntlets {
	BECelestialHandguards() : base() {
		$this.Name               = 'Celestial Handguards'
		$this.MapObjName         = 'celestialhandguards'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards of celestial origin, radiating divine light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEElderwoodGauntlets : BEGauntlets {
	BEElderwoodGauntlets() : base() {
		$this.Name               = 'Elderwood Gauntlets'
		$this.MapObjName         = 'elderwoodgauntlets'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from ancient, sentient wood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStonefleshGauntlets : BEGauntlets {
	BEStonefleshGauntlets() : base() {
		$this.Name               = 'Stoneflesh Gauntlets'
		$this.MapObjName         = 'stonefleshgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to turn skin to stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESunblessedGauntlets : BEGauntlets {
	BESunblessedGauntlets() : base() {
		$this.Name               = 'Sunblessed Gauntlets'
		$this.MapObjName         = 'sunblessedgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with the sun''s warmth, healing allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowfangGloves : BEGauntlets {
	BEShadowfangGloves() : base() {
		$this.Name               = 'Shadowfang Gloves'
		$this.MapObjName         = 'shadowfanggloves'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with retractable shadow claws, for stealthy strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernscaleGauntlets : BEGauntlets {
	BEWyvernscaleGauntlets() : base() {
		$this.Name               = 'Wyvernscale Gauntlets'
		$this.MapObjName         = 'wyvernscalegauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from the scales of a full-grown wyvern.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStormbreakerGauntlets : BEGauntlets {
	BEStormbreakerGauntlets() : base() {
		$this.Name               = 'Stormbreaker Gauntlets'
		$this.MapObjName         = 'stormbreakergauntlets'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that can channel and disperse stormy energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFeywildGloves : BEGauntlets {
	BEFeywildGloves() : base() {
		$this.Name               = 'Feywild Gloves'
		$this.MapObjName         = 'feywildgloves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 38
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves touched by the Feywild, shimmering with magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAbyssalMawGauntlets : BEGauntlets {
	BEAbyssalMawGauntlets() : base() {
		$this.Name               = 'Abyssal Maw Gauntlets'
		$this.MapObjName         = 'abyssalmawgauntlets'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets resembling a gaping maw, crushing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarforgedGauntlets : BEGauntlets {
	BEStarforgedGauntlets() : base() {
		$this.Name               = 'Starforged Gauntlets'
		$this.MapObjName         = 'starforgedgauntlets'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged under a specific constellation, granting luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonlordsGauntlets : BEGauntlets {
	BEDragonlordsGauntlets() : base() {
		$this.Name               = 'Dragonlord''s Gauntlets'
		$this.MapObjName         = 'dragonlordsgauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 88
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a dragonlord, of immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritwalkerGloves : BEGauntlets {
	BESpiritwalkerGloves() : base() {
		$this.Name               = 'Spiritwalker Gloves'
		$this.MapObjName         = 'spiritwalkergloves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that allow brief interaction with spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENetheriteGauntlets : BEGauntlets {
	BENetheriteGauntlets() : base() {
		$this.Name               = 'Netherite Gauntlets'
		$this.MapObjName         = 'netheritegauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 92
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from a rare, volatile metal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneWeaveGloves : BEGauntlets {
	BEArcaneWeaveGloves() : base() {
		$this.Name               = 'Arcane Weave Gloves'
		$this.MapObjName         = 'arcaneweavegloves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves intricately woven with arcane threads, enhancing spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEColossusGauntlets : BEGauntlets {
	BEColossusGauntlets() : base() {
		$this.Name               = 'Colossus Gauntlets'
		$this.MapObjName         = 'colossusgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 98
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets for a champion, empowering strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEChronoFluxGauntlets : BEGauntlets {
	BEChronoFluxGauntlets() : base() {
		$this.Name               = 'Chrono Flux Gauntlets'
		$this.MapObjName         = 'chronofluxgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that bend time, granting rapid movements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidShroudGauntlets : BEGauntlets {
	BEVoidShroudGauntlets() : base() {
		$this.Name               = 'Void Shroud Gauntlets'
		$this.MapObjName         = 'voidshroudgauntlets'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that appear to fade in and out of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELionheartGauntlets : BEGauntlets {
	BELionheartGauntlets() : base() {
		$this.Name               = 'Lionheart Gauntlets'
		$this.MapObjName         = 'lionheartgauntlets'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets bearing the symbol of a lion, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEValkyriesVambraces : BEGauntlets {
	BEValkyriesVambraces() : base() {
		$this.Name               = 'Valkyrie''s Vambraces'
		$this.MapObjName         = 'valkyriesvambraces'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces adorned with wings, lighter than air yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESerpentScaleGauntlets : BEGauntlets {
	BESerpentScaleGauntlets() : base() {
		$this.Name               = 'Serpent Scale Gauntlets'
		$this.MapObjName         = 'serpentscalegauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from large serpent scales, flexible and tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemHandguards : BEGauntlets {
	BEGolemHandguards() : base() {
		$this.Name               = 'Golem Handguards'
		$this.MapObjName         = 'golemhandguards'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards of an ancient golem, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMoonpetalGloves : BEGauntlets {
	BEMoonpetalGloves() : base() {
		$this.Name               = 'Moonpetal Gloves'
		$this.MapObjName         = 'moonpetalgloves'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from moonlit petals, soft and magically potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECenturionGauntlets : BEGauntlets {
	BECenturionGauntlets() : base() {
		$this.Name               = 'Centurion Gauntlets'
		$this.MapObjName         = 'centuriongauntlets'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, practical gauntlets for a seasoned soldier.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpellboundGauntlets : BEGauntlets {
	BESpellboundGauntlets() : base() {
		$this.Name               = 'Spellbound Gauntlets'
		$this.MapObjName         = 'spellboundgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a powerful, protective spell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronGuardGauntlets : BEGauntlets {
	BEIronGuardGauntlets() : base() {
		$this.Name               = 'Iron Guard Gauntlets'
		$this.MapObjName         = 'ironguardgauntlets'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced iron gauntlets, preferred by city guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoughspunGrips : BEGauntlets {
	BERoughspunGrips() : base() {
		$this.Name               = 'Roughspun Grips'
		$this.MapObjName         = 'roughspungrips'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude, but surprisingly durable gloves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrigandsBracers : BEGauntlets {
	BEBrigandsBracers() : base() {
		$this.Name               = 'Brigand''s Bracers'
		$this.MapObjName         = 'brigandsbracers'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple bracers, often found on bandits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsMitts : BEGauntlets {
	BEZealotsMitts() : base() {
		$this.Name               = 'Zealot''s Mitts'
		$this.MapObjName         = 'zealotsmitts'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light mitts for a quick, devoted follower.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilkenGloves : BEGauntlets {
	BESilkenGloves() : base() {
		$this.Name               = 'Silken Gloves'
		$this.MapObjName         = 'silkengloves'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Soft, elegant gloves offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEApprenticesGauntlets : BEGauntlets {
	BEApprenticesGauntlets() : base() {
		$this.Name               = 'Apprentice''s Gauntlets'
		$this.MapObjName         = 'apprenticesgauntlets'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic gauntlets for those learning the craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWanderersCuffs : BEGauntlets {
	BEWanderersCuffs() : base() {
		$this.Name               = 'Wanderer''s Cuffs'
		$this.MapObjName         = 'wandererscuffs'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Durable cuffs for endless travels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFabledGauntlets : BEGauntlets {
	BEFabledGauntlets() : base() {
		$this.Name               = 'Fabled Gauntlets'
		$this.MapObjName         = 'fabledgauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets spoken of in legends, their power growing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrimskullGauntlets : BEGauntlets {
	BEGrimskullGauntlets() : base() {
		$this.Name               = 'Grimskull Gauntlets'
		$this.MapObjName         = 'grimskullgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with skulls, intimidating and dark.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECrystalweaveGloves : BEGauntlets {
	BECrystalweaveGloves() : base() {
		$this.Name               = 'Crystalweave Gloves'
		$this.MapObjName         = 'crystalweavegloves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with fine crystal threads, enhancing focus.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDragonswornGauntlets : BEGauntlets {
	BEDragonswornGauntlets() : base() {
		$this.Name               = 'Dragonsworn Gauntlets'
		$this.MapObjName         = 'dragonsworngauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of those who pledge loyalty to dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternalFlameGauntlets : BEGauntlets {
	BEEternalFlameGauntlets() : base() {
		$this.Name               = 'Eternal Flame Gauntlets'
		$this.MapObjName         = 'eternalflamegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets burning with a non-consuming flame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhispersteelGauntlets : BEGauntlets {
	BEWhispersteelGauntlets() : base() {
		$this.Name               = 'Whispersteel Gauntlets'
		$this.MapObjName         = 'whispersteelgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of a silent, shadowy metal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneskinGrips : BEGauntlets {
	BEStoneskinGrips() : base() {
		$this.Name               = 'Stoneskin Grips'
		$this.MapObjName         = 'stoneskingrips'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that harden the skin, making it resistant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGoddesssHandguards : BEGauntlets {
	BEGoddesssHandguards() : base() {
		$this.Name               = 'Goddess''s Handguards'
		$this.MapObjName         = 'goddessshandguards'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards said to be touched by a deity, offering ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEChampionsGauntlets : BEGauntlets {
	BEChampionsGauntlets() : base() {
		$this.Name               = 'Champion''s Gauntlets'
		$this.MapObjName         = 'championsgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a legendary champion, imbued with their might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWraithtouchGloves : BEGauntlets {
	BEWraithtouchGloves() : base() {
		$this.Name               = 'Wraithtouch Gloves'
		$this.MapObjName         = 'wraithtouchgloves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that pass through enemies, leaving a chilling effect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitanforgedGauntlets : BEGauntlets {
	BETitanforgedGauntlets() : base() {
		$this.Name               = 'Titanforged Gauntlets'
		$this.MapObjName         = 'titanforgedgauntlets'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged in a titan''s forge, immense and heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEtherealBands : BEGauntlets {
	BEEtherealBands() : base() {
		$this.Name               = 'Ethereal Bands'
		$this.MapObjName         = 'etherealbands'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands composed of pure ether, granting magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlademasterGauntlets : BEGauntlets {
	BEBlademasterGauntlets() : base() {
		$this.Name               = 'Blademaster Gauntlets'
		$this.MapObjName         = 'blademastergauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets designed for precision and offensive strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOathswornGauntlets : BEGauntlets {
	BEOathswornGauntlets() : base() {
		$this.Name               = 'Oathsworn Gauntlets'
		$this.MapObjName         = 'oathsworngauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a sworn knight, unbreakable in their resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverlightGloves : BEGauntlets {
	BESilverlightGloves() : base() {
		$this.Name               = 'Silverlight Gloves'
		$this.MapObjName         = 'silverlightgloves'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that emanate a faint silver light, revealing hidden paths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGuardiansGrip : BEGauntlets {
	BEGuardiansGrip() : base() {
		$this.Name               = 'Guardian''s Grip'
		$this.MapObjName         = 'guardiansgrip'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A firm grip for protecting others.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticRelicGauntlets : BEGauntlets {
	BEMysticRelicGauntlets() : base() {
		$this.Name               = 'Mystic Relic Gauntlets'
		$this.MapObjName         = 'mysticrelicgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from a forgotten civilization, holding ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowdancerGloves : BEGauntlets {
	BEShadowdancerGloves() : base() {
		$this.Name               = 'Shadowdancer Gloves'
		$this.MapObjName         = 'shadowdancergloves'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 18
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing swift, silent movement through shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBattlewornGauntlets : BEGauntlets {
	BEBattlewornGauntlets() : base() {
		$this.Name               = 'Battleworn Gauntlets'
		$this.MapObjName         = 'battleworngauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that have seen countless battles, scarred but strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritboundGauntlets : BEGauntlets {
	BESpiritboundGauntlets() : base() {
		$this.Name               = 'Spiritbound Gauntlets'
		$this.MapObjName         = 'spiritboundgauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that link to a spirit, enhancing defense and magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomousGrips : BEGauntlets {
	BEVenomousGrips() : base() {
		$this.Name               = 'Venomous Grips'
		$this.MapObjName         = 'venomousgrips'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets dripping with faint poison, for subtle attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsFists : BEGauntlets {
	BEZealotsFists() : base() {
		$this.Name               = 'Zealot''s Fists'
		$this.MapObjName         = 'zealotsfists'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists of a righteous warrior, imbued with fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmeraldScaleGauntlets : BEGauntlets {
	BEEmeraldScaleGauntlets() : base() {
		$this.Name               = 'Emerald Scale Gauntlets'
		$this.MapObjName         = 'emeraldscalegauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from vibrant green dragon scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostWeaverGloves : BEGauntlets {
	BEFrostWeaverGloves() : base() {
		$this.Name               = 'Frost Weaver Gloves'
		$this.MapObjName         = 'frostweavergloves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that manipulate ice, weaving chilling spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOnyxClawGauntlets : BEGauntlets {
	BEOnyxClawGauntlets() : base() {
		$this.Name               = 'Onyx Claw Gauntlets'
		$this.MapObjName         = 'onyxclawgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with sharp onyx claws, for piercing attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarshardGauntlets : BEGauntlets {
	BEStarshardGauntlets() : base() {
		$this.Name               = 'Starshard Gauntlets'
		$this.MapObjName         = 'starshardgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fragments of fallen stars, radiating cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneBracers : BEGauntlets {
	BEMoonstoneBracers() : base() {
		$this.Name               = 'Moonstone Bracers'
		$this.MapObjName         = 'moonstonebracers'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 38
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers glowing with soft moonstone, aiding nocturnal endeavors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBlazeCoreGauntlets : BEGauntlets {
	BEBlazeCoreGauntlets() : base() {
		$this.Name               = 'Blaze Core Gauntlets'
		$this.MapObjName         = 'blazecoregauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an internal core of fire, burning steadily.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENightfallGauntlets : BEGauntlets {
	BENightfallGauntlets() : base() {
		$this.Name               = 'Nightfall Gauntlets'
		$this.MapObjName         = 'nightfallgauntlets'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that absorb surrounding light, cloaking the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncientSteelGauntlets : BEGauntlets {
	BEAncientSteelGauntlets() : base() {
		$this.Name               = 'Ancient Steel Gauntlets'
		$this.MapObjName         = 'ancientsteelgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of incredibly old, resilient steel.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineEssenceGauntlets : BEGauntlets {
	BEDivineEssenceGauntlets() : base() {
		$this.Name               = 'Divine Essence Gauntlets'
		$this.MapObjName         = 'divineessencegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets pulsating with pure divine essence, warding off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidShardGloves : BEGauntlets {
	BEVoidShardGloves() : base() {
		$this.Name               = 'Void Shard Gloves'
		$this.MapObjName         = 'voidshardgloves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves containing fragments of the void, disorienting foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonGuardGauntlets : BEGauntlets {
	BECrimsonGuardGauntlets() : base() {
		$this.Name               = 'Crimson Guard Gauntlets'
		$this.MapObjName         = 'crimsonguardgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a crimson guard, stained by many battles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantresssBands : BEGauntlets {
	BEEnchantresssBands() : base() {
		$this.Name               = 'Enchantress''s Bands'
		$this.MapObjName         = 'enchantresssbands'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands for a powerful enchantress, boosting all magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERuneforgedGauntlets : BEGauntlets {
	BERuneforgedGauntlets() : base() {
		$this.Name               = 'Runeforged Gauntlets'
		$this.MapObjName         = 'runeforgedgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged with powerful runes, radiating mystical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindGauntlets : BEGauntlets {
	BEWhisperwindGauntlets() : base() {
		$this.Name               = 'Whisperwind Gauntlets'
		$this.MapObjName         = 'whisperwindgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 20
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets light as a breeze, granting unparalleled agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthshakerGauntlets : BEGauntlets {
	BEEarthshakerGauntlets() : base() {
		$this.Name               = 'Earthshaker Gauntlets'
		$this.MapObjName         = 'earthshakergauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that can cause minor tremors with each strike.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESoulfireGrips : BEGauntlets {
	BESoulfireGrips() : base() {
		$this.Name               = 'Soulfire Grips'
		$this.MapObjName         = 'soulfiregrips'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that burn with ethereal flame, searing spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonheartGauntlets : BEGauntlets {
	BEDragonheartGauntlets() : base() {
		$this.Name               = 'Dragonheart Gauntlets'
		$this.MapObjName         = 'dragonheartgauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets from the heart of a dragon, radiating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialTearGauntlets : BEGauntlets {
	BECelestialTearGauntlets() : base() {
		$this.Name               = 'Celestial Tear Gauntlets'
		$this.MapObjName         = 'celestialteargauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be formed from a fallen star''s tear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPlateGauntlets : BEGauntlets {
	BEAbyssalPlateGauntlets() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets'
		$this.MapObjName         = 'abyssalplategauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy gauntlets from the deepest abyss, extremely resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFeatherGloves : BEGauntlets {
	BEPhoenixFeatherGloves() : base() {
		$this.Name               = 'Phoenix Feather Gloves'
		$this.MapObjName         = 'phoenixfeathergloves'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with phoenix feathers, offering light and healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarlordsGauntlets : BEGauntlets {
	BEWarlordsGauntlets() : base() {
		$this.Name               = 'Warlord''s Gauntlets'
		$this.MapObjName         = 'warlordsgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fearsome warlord, commanding respect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDreamsteelGauntlets : BEGauntlets {
	BEDreamsteelGauntlets() : base() {
		$this.Name               = 'Dreamsteel Gauntlets'
		$this.MapObjName         = 'dreamsteelgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from solidified dreams, both light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidstoneGauntlets : BEGauntlets {
	BEVoidstoneGauntlets() : base() {
		$this.Name               = 'Voidstone Gauntlets'
		$this.MapObjName         = 'voidstonegauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of voidstone, absorbing all magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunpetalHandguards : BEGauntlets {
	BESunpetalHandguards() : base() {
		$this.Name               = 'Sunpetal Handguards'
		$this.MapObjName         = 'sunpetalhandguards'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 40
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards made from sun-kissed petals, vibrant and delicate.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrimsonIronGauntlets : BEGauntlets {
	BECrimsonIronGauntlets() : base() {
		$this.Name               = 'Crimson Iron Gauntlets'
		$this.MapObjName         = 'crimsonirongauntlets'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets dyed crimson, symbolizing ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWovenVineGloves : BEGauntlets {
	BEWovenVineGloves() : base() {
		$this.Name               = 'Woven Vine Gloves'
		$this.MapObjName         = 'wovenvinegloves'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from strong, flexible vines.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneSplinterGauntlets : BEGauntlets {
	BEStoneSplinterGauntlets() : base() {
		$this.Name               = 'Stone Splinter Gauntlets'
		$this.MapObjName         = 'stonesplintergauntlets'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets reinforced with sharp stone splinters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeather-BoundGauntlets : BEGauntlets {
	BELeatherBoundGauntlets() : base() {
		$this.Name               = 'Leather-Bound Gauntlets'
		$this.MapObjName         = 'leatherboundgauntlets'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets reinforced with metal bands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelersBracers : BEGauntlets {
	BETravelersBracers() : base() {
		$this.Name               = 'Traveler''s Bracers'
		$this.MapObjName         = 'travelersbracers'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Comfortable bracers for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESimpleIronGauntlets : BEGauntlets {
	BESimpleIronGauntlets() : base() {
		$this.Name               = 'Simple Iron Gauntlets'
		$this.MapObjName         = 'simpleirongauntlets'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic, unadorned iron gauntlets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaddedIronGauntlets : BEGauntlets {
	BEPaddedIronGauntlets() : base() {
		$this.Name               = 'Padded Iron Gauntlets'
		$this.MapObjName         = 'paddedirongauntlets'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets with padded interior for comfort.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStuddedLeatherGauntlets : BEGauntlets {
	BEStuddedLeatherGauntlets() : base() {
		$this.Name               = 'Studded Leather Gauntlets'
		$this.MapObjName         = 'studdedleathergauntlets'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets with small metal studs for added defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBone-PlatedGauntlets : BEGauntlets {
	BEBonePlatedGauntlets() : base() {
		$this.Name               = 'Bone-Plated Gauntlets'
		$this.MapObjName         = 'boneplatedgauntlets'
		$this.PurchasePrice      = 210
		$this.SellPrice          = 105
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from hardened animal bones.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScaleMailGauntlets : BEGauntlets {
	BEScaleMailGauntlets() : base() {
		$this.Name               = 'Scale Mail Gauntlets'
		$this.MapObjName         = 'scalemailgauntlets'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets composed of overlapping metal scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHardenedLeatherGloves : BEGauntlets {
	BEHardenedLeatherGloves() : base() {
		$this.Name               = 'Hardened Leather Gloves'
		$this.MapObjName         = 'hardenedleathergloves'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves of exceptionally tough, treated leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForgedSteelGauntlets : BEGauntlets {
	BEForgedSteelGauntlets() : base() {
		$this.Name               = 'Forged Steel Gauntlets'
		$this.MapObjName         = 'forgedsteelgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Expertly forged steel gauntlets, balanced for battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReinforcedMitts : BEGauntlets {
	BEReinforcedMitts() : base() {
		$this.Name               = 'Reinforced Mitts'
		$this.MapObjName         = 'reinforcedmitts'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Mitts with extra padding, offering more protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoldiersGauntlets : BEGauntlets {
	BESoldiersGauntlets() : base() {
		$this.Name               = 'Soldier''s Gauntlets'
		$this.MapObjName         = 'soldiersgauntlets'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard issue gauntlets for army soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAcolytesBands : BEGauntlets {
	BEAcolytesBands() : base() {
		$this.Name               = 'Acolyte''s Bands'
		$this.MapObjName         = 'acolytesbands'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple bands for a magical apprentice, aiding their studies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMaraudersGrips : BEGauntlets {
	BEMaraudersGrips() : base() {
		$this.Name               = 'Marauder''s Grips'
		$this.MapObjName         = 'maraudersgrips'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough grips favored by raiders, for brutal attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverthreadGloves : BEGauntlets {
	BESilverthreadGloves() : base() {
		$this.Name               = 'Silverthread Gloves'
		$this.MapObjName         = 'silverthreadgloves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with fine silver thread, light and defensive against dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBarbariansClaws : BEGauntlets {
	BEBarbariansClaws() : base() {
		$this.Name               = 'Barbarian''s Claws'
		$this.MapObjName         = 'barbariansclaws'
		$this.PurchasePrice      = 290
		$this.SellPrice          = 145
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude gauntlets with sharpened edges, for close combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESquiresGauntlets : BEGauntlets {
	BESquiresGauntlets() : base() {
		$this.Name               = 'Squire''s Gauntlets'
		$this.MapObjName         = 'squiresgauntlets'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets for a young knight in training.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFightersCuffs : BEGauntlets {
	BEFightersCuffs() : base() {
		$this.Name               = 'Fighter''s Cuffs'
		$this.MapObjName         = 'fighterscuffs'
		$this.PurchasePrice      = 270
		$this.SellPrice          = 135
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Strong cuffs for brawlers and melee combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpellbindersGloves : BEGauntlets {
	BESpellbindersGloves() : base() {
		$this.Name               = 'Spellbinder''s Gloves'
		$this.MapObjName         = 'spellbindersgloves'
		$this.PurchasePrice      = 360
		$this.SellPrice          = 180
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves designed to assist in the casting of complex spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERangersBracers : BEGauntlets {
	BERangersBracers() : base() {
		$this.Name               = 'Ranger''s Bracers'
		$this.MapObjName         = 'rangersbracers'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 8
			[StatId]::Accuracy = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light bracers for those who roam the wilderness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeavyIronGauntlets : BEGauntlets {
	BEHeavyIronGauntlets() : base() {
		$this.Name               = 'Heavy Iron Gauntlets'
		$this.MapObjName         = 'heavyirongauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Very thick iron gauntlets, slow but incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMysticLeatherGauntlets : BEGauntlets {
	BEMysticLeatherGauntlets() : base() {
		$this.Name               = 'Mystic Leather Gauntlets'
		$this.MapObjName         = 'mysticleathergauntlets'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather gauntlets infused with minor protective charms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarmastersGauntlets : BEGauntlets {
	BEWarmastersGauntlets() : base() {
		$this.Name               = 'Warmaster''s Gauntlets'
		$this.MapObjName         = 'warmastersgauntlets'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a battle-hardened commander, commanding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEForestGuardianGloves : BEGauntlets {
	BEForestGuardianGloves() : base() {
		$this.Name               = 'Forest Guardian Gloves'
		$this.MapObjName         = 'forestguardiangloves'
		$this.PurchasePrice      = 310
		$this.SellPrice          = 155
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from forest materials, blending with nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneGauntlets : BEGauntlets {
	BEStoneGauntlets() : base() {
		$this.Name               = 'Stone Gauntlets'
		$this.MapObjName         = 'stonegauntlets'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 21
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from solid stone, heavy and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFrostwornGrips : BEGauntlets {
	BEFrostwornGrips() : base() {
		$this.Name               = 'Frostworn Grips'
		$this.MapObjName         = 'frostworngrips'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that retain a chilling touch from icy encounters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenSilverGauntlets : BEGauntlets {
	BESunkenSilverGauntlets() : base() {
		$this.Name               = 'Sunken Silver Gauntlets'
		$this.MapObjName         = 'sunkensilvergauntlets'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silver gauntlets recovered from a sunken ship, glimmering.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowscaleGloves : BEGauntlets {
	BEShadowscaleGloves() : base() {
		$this.Name               = 'Shadowscale Gloves'
		$this.MapObjName         = 'shadowscalegloves'
		$this.PurchasePrice      = 430
		$this.SellPrice          = 215
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 16
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from the scales of a shadowy creature, light and elusive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnight-ErrantGauntlets : BEGauntlets {
	BEKnightErrantGauntlets() : base() {
		$this.Name               = 'Knight-Errant Gauntlets'
		$this.MapObjName         = 'knighterrantgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a wandering knight, reliable and well-kept.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPriestesssCuffs : BEGauntlets {
	BEPriestesssCuffs() : base() {
		$this.Name               = 'Priestess''s Cuffs'
		$this.MapObjName         = 'priestessscuffs'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs worn by priestesses, aiding in benevolent magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDrakehideGloves : BEGauntlets {
	BEDrakehideGloves() : base() {
		$this.Name               = 'Drakehide Gloves'
		$this.MapObjName         = 'drakehidegloves'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made from the hide of a young drake, flexible and tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertScavengerGrips : BEGauntlets {
	BEDesertScavengerGrips() : base() {
		$this.Name               = 'Desert Scavenger Grips'
		$this.MapObjName         = 'desertscavengergrips'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 3
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Makeshift grips used by desert scavengers, rugged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormchaserGauntlets : BEGauntlets {
	BEStormchaserGauntlets() : base() {
		$this.Name               = 'Stormchaser Gauntlets'
		$this.MapObjName         = 'stormchasergauntlets'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets designed to withstand and channel lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMoonfallBands : BEGauntlets {
	BEMoonfallBands() : base() {
		$this.Name               = 'Moonfall Bands'
		$this.MapObjName         = 'moonfallbands'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that softly glow, absorbing lunar energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGrizzledVeteransGauntlets : BEGauntlets {
	BEGrizzledVeteransGauntlets() : base() {
		$this.Name               = 'Grizzled Veteran''s Gauntlets'
		$this.MapObjName         = 'grizzledveteransgauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a truly ancient warrior, scarred and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAetherialGauntlets : BEGauntlets {
	BEAetherialGauntlets() : base() {
		$this.Name               = 'Aetherial Gauntlets'
		$this.MapObjName         = 'aetherialgauntlets'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with faint Aether, granting resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlazeforgedGrips : BEGauntlets {
	BEBlazeforgedGrips() : base() {
		$this.Name               = 'Blazeforged Grips'
		$this.MapObjName         = 'blazeforgedgrips'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips heated in intense flames, maintaining their warmth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDeepruneGauntlets : BEGauntlets {
	BEDeepruneGauntlets() : base() {
		$this.Name               = 'Deeprune Gauntlets'
		$this.MapObjName         = 'deeprunegauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with deeply etched runes, enhancing their power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritwalkerHandguards : BEGauntlets {
	BESpiritwalkerHandguards() : base() {
		$this.Name               = 'Spiritwalker Handguards'
		$this.MapObjName         = 'spiritwalkerhandguards'
		$this.PurchasePrice      = 540
		$this.SellPrice          = 270
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards aiding those who commune with spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronboundGauntlets : BEGauntlets {
	BEIronboundGauntlets() : base() {
		$this.Name               = 'Ironbound Gauntlets'
		$this.MapObjName         = 'ironboundgauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets tightly bound with iron strips, very durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernTailGauntlets : BEGauntlets {
	BEWyvernTailGauntlets() : base() {
		$this.Name               = 'Wyvern Tail Gauntlets'
		$this.MapObjName         = 'wyverntailgauntlets'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 10
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets ending in a segmented wyvern tail, for agile strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunfireGloves : BEGauntlets {
	BESunfireGloves() : base() {
		$this.Name               = 'Sunfire Gloves'
		$this.MapObjName         = 'sunfiregloves'
		$this.PurchasePrice      = 510
		$this.SellPrice          = 255
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that radiate soft warmth, comforting and protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBarbarianKingGauntlets : BEGauntlets {
	BEBarbarianKingGauntlets() : base() {
		$this.Name               = 'Barbarian King Gauntlets'
		$this.MapObjName         = 'barbariankinggauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a tribal leader, raw and powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEShadeclothGloves : BEGauntlets {
	BEShadeclothGloves() : base() {
		$this.Name               = 'Shadecloth Gloves'
		$this.MapObjName         = 'shadeclothgloves'
		$this.PurchasePrice      = 470
		$this.SellPrice          = 235
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 19
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves made of cloth spun from shadows, very stealthy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalSoulGauntlets : BEGauntlets {
	BECrystalSoulGauntlets() : base() {
		$this.Name               = 'Crystal Soul Gauntlets'
		$this.MapObjName         = 'crystalsoulgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with a small crystal, reflecting magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoliathGauntlets : BEGauntlets {
	BEGoliathGauntlets() : base() {
		$this.Name               = 'Goliath Gauntlets'
		$this.MapObjName         = 'goliathgauntlets'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets designed for a giant''s strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEOraclesVisions : BEGauntlets {
	BEOraclesVisions() : base() {
		$this.Name               = 'Oracle''s Visions'
		$this.MapObjName         = 'oraclesvisions'
		$this.PurchasePrice      = 630
		$this.SellPrice          = 315
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that briefly glimpse the future, boosting evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrimsonDeathGauntlets : BEGauntlets {
	BECrimsonDeathGauntlets() : base() {
		$this.Name               = 'Crimson Death Gauntlets'
		$this.MapObjName         = 'crimsondeathgauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a formidable executioner, stained red.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStormheartGauntlets : BEGauntlets {
	BEStormheartGauntlets() : base() {
		$this.Name               = 'Stormheart Gauntlets'
		$this.MapObjName         = 'stormheartgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to beat with a storm''s heart, powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEldritchBands : BEGauntlets {
	BEEldritchBands() : base() {
		$this.Name               = 'Eldritch Bands'
		$this.MapObjName         = 'eldritchbands'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands pulsing with otherworldly energy, dangerous yet powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialSpikeGauntlets : BEGauntlets {
	BEGlacialSpikeGauntlets() : base() {
		$this.Name               = 'Glacial Spike Gauntlets'
		$this.MapObjName         = 'glacialspikegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with sharp ice spikes, chilling to touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECelestialTouchGloves : BEGauntlets {
	BECelestialTouchGloves() : base() {
		$this.Name               = 'Celestial Touch Gloves'
		$this.MapObjName         = 'celestialtouchgloves'
		$this.PurchasePrice      = 820
		$this.SellPrice          = 410
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that feel like a gentle touch from the heavens.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAbyssalCoreGauntlets : BEGauntlets {
	BEAbyssalCoreGauntlets() : base() {
		$this.Name               = 'Abyssal Core Gauntlets'
		$this.MapObjName         = 'abyssalcoregauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with a core of abyssal energy, consuming magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERuneboundGauntlets : BEGauntlets {
	BERuneboundGauntlets() : base() {
		$this.Name               = 'Runebound Gauntlets'
		$this.MapObjName         = 'runeboundgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets strongly bound by ancient runes, powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulsteelGauntlets : BEGauntlets {
	BESoulsteelGauntlets() : base() {
		$this.Name               = 'Soulsteel Gauntlets'
		$this.MapObjName         = 'soulsteelgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets forged from purified souls, radiant and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonKingGauntlets : BEGauntlets {
	BEDragonKingGauntlets() : base() {
		$this.Name               = 'Dragon King Gauntlets'
		$this.MapObjName         = 'dragonkinggauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets fit for a true dragon king, absolute power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPhoenixSoulGauntlets : BEGauntlets {
	BEPhoenixSoulGauntlets() : base() {
		$this.Name               = 'Phoenix Soul Gauntlets'
		$this.MapObjName         = 'phoenixsoulgauntlets'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with the spirit of a phoenix, granting rebirth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitanbloodGauntlets : BEGauntlets {
	BETitanbloodGauntlets() : base() {
		$this.Name               = 'Titanblood Gauntlets'
		$this.MapObjName         = 'titanbloodgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets stained with titan blood, granting immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarlightWeaveGloves : BEGauntlets {
	BEStarlightWeaveGloves() : base() {
		$this.Name               = 'Starlight Weave Gloves'
		$this.MapObjName         = 'starlightweavegloves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from starlight, shimmering and ethereal.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVoidShroudedGauntlets : BEGauntlets {
	BEVoidShroudedGauntlets() : base() {
		$this.Name               = 'Void Shrouded Gauntlets'
		$this.MapObjName         = 'voidshroudedgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets entirely cloaked in void energy, hard to perceive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHolyVambraces : BEGauntlets {
	BEHolyVambraces() : base() {
		$this.Name               = 'Holy Vambraces'
		$this.MapObjName         = 'holyvambraces'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces blessed by sacred rites, warding off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInfernoCoreGauntlets : BEGauntlets {
	BEInfernoCoreGauntlets() : base() {
		$this.Name               = 'Inferno Core Gauntlets'
		$this.MapObjName         = 'infernocoregauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with a perpetual internal flame, burning hot.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESeraphimsEmbrace : BEGauntlets {
	BESeraphimsEmbrace() : base() {
		$this.Name               = 'Seraphim''s Embrace'
		$this.MapObjName         = 'seraphimsembrace'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feathery gloves that feel like an angelic embrace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDreadskullGauntlets : BEGauntlets {
	BEDreadskullGauntlets() : base() {
		$this.Name               = 'Dreadskull Gauntlets'
		$this.MapObjName         = 'dreadskullgauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets shaped like skulls, exuding fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAstralGauntlets : BEGauntlets {
	BEAstralGauntlets() : base() {
		$this.Name               = 'Astral Gauntlets'
		$this.MapObjName         = 'astralgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets connected to the astral plane, enhancing spiritual power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOnyxHeartGauntlets : BEGauntlets {
	BEOnyxHeartGauntlets() : base() {
		$this.Name               = 'Onyx Heart Gauntlets'
		$this.MapObjName         = 'onyxheartgauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with an onyx core, drawing dark energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrSoulGauntlets : BEGauntlets {
	BEZephyrSoulGauntlets() : base() {
		$this.Name               = 'Zephyr Soul Gauntlets'
		$this.MapObjName         = 'zephyrsoulgauntlets'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with the soul of the wind, incredibly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthboundGauntlets : BEGauntlets {
	BEEarthboundGauntlets() : base() {
		$this.Name               = 'Earthbound Gauntlets'
		$this.MapObjName         = 'earthboundgauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets rooted to the earth, granting stability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BELunarEclipseGauntlets : BEGauntlets {
	BELunarEclipseGauntlets() : base() {
		$this.Name               = 'Lunar Eclipse Gauntlets'
		$this.MapObjName         = 'lunareclipsegauntlets'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 68
			[StatId]::MagicDefense = 32
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that dim the light around them, aiding stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESolarFlareGauntlets : BEGauntlets {
	BESolarFlareGauntlets() : base() {
		$this.Name               = 'Solar Flare Gauntlets'
		$this.MapObjName         = 'solarflaregauntlets'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that periodically unleash bursts of sunlight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEAbyssalHandguards : BEGauntlets {
	BEAbyssalHandguards() : base() {
		$this.Name               = 'Abyssal Handguards'
		$this.MapObjName         = 'abyssalhandguards'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 98
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Handguards from the deepest, darkest pits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineAegisGloves : BEGauntlets {
	BEDivineAegisGloves() : base() {
		$this.Name               = 'Divine Aegis Gloves'
		$this.MapObjName         = 'divineaegisgloves'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that provide an invisible shield, divinely powered.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGrimstoneGauntlets : BEGauntlets {
	BEGrimstoneGauntlets() : base() {
		$this.Name               = 'Grimstone Gauntlets'
		$this.MapObjName         = 'grimstonegauntlets'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets carved from cursed stone, heavy and menacing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEbonShadowGauntlets : BEGauntlets {
	BEEbonShadowGauntlets() : base() {
		$this.Name               = 'Ebon Shadow Gauntlets'
		$this.MapObjName         = 'ebonshadowgauntlets'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that melt into shadows, making the wearer unseen.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMythrilWeaveGloves : BEGauntlets {
	BEMythrilWeaveGloves() : base() {
		$this.Name               = 'Mythril Weave Gloves'
		$this.MapObjName         = 'mythrilweavegloves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from fine mythril, light and extremely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantiteFistGauntlets : BEGauntlets {
	BEAdamantiteFistGauntlets() : base() {
		$this.Name               = 'Adamantite Fist Gauntlets'
		$this.MapObjName         = 'adamantitefistgauntlets'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of pure adamantite, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECelestialZenithGauntlets : BEGauntlets {
	BECelestialZenithGauntlets() : base() {
		$this.Name               = 'Celestial Zenith Gauntlets'
		$this.MapObjName         = 'celestialzenithgauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that draw power from the highest heavens.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidHeartGauntlets : BEGauntlets {
	BEVoidHeartGauntlets() : base() {
		$this.Name               = 'Void Heart Gauntlets'
		$this.MapObjName         = 'voidheartgauntlets'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that house a fragment of the void, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonsBreathGauntlets : BEGauntlets {
	BEDragonsBreathGauntlets() : base() {
		$this.Name               = 'Dragon''s Breath Gauntlets'
		$this.MapObjName         = 'dragonsbreathgauntlets'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a dragon''s fiery breath.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfireGauntlets : BEGauntlets {
	BEStarfireGauntlets() : base() {
		$this.Name               = 'Starfire Gauntlets'
		$this.MapObjName         = 'starfiregauntlets'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 115
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets glowing with cosmic fire, scorching foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETrueDivineGauntlets : BEGauntlets {
	BETrueDivineGauntlets() : base() {
		$this.Name               = 'True Divine Gauntlets'
		$this.MapObjName         = 'truedivinegauntlets'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 120
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be worn by gods, ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulEaterGauntlets : BEGauntlets {
	BESoulEaterGauntlets() : base() {
		$this.Name               = 'Soul Eater Gauntlets'
		$this.MapObjName         = 'souleatergauntlets'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::Defense = 125
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that devour the souls of defeated enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWorldshaperGauntlets : BEGauntlets {
	BEWorldshaperGauntlets() : base() {
		$this.Name               = 'Worldshaper Gauntlets'
		$this.MapObjName         = 'worldshapergauntlets'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 130
			[StatId]::MagicDefense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that hum with world-shaping energy, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenKingsGauntlets : BEGauntlets {
	BESunkenKingsGauntlets() : base() {
		$this.Name               = 'Sunken King''s Gauntlets'
		$this.MapObjName         = 'sunkenkingsgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a forgotten underwater king, granting aquatic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritGuardianGauntlets : BEGauntlets {
	BESpiritGuardianGauntlets() : base() {
		$this.Name               = 'Spirit Guardian Gauntlets'
		$this.MapObjName         = 'spiritguardiangauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with ancient guardian spirits, protecting all.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindGauntletsII : BEGauntlets {
	BEWhisperwindGauntletsII() : base() {
		$this.Name               = 'Whisperwind Gauntlets II'
		$this.MapObjName         = 'whisperwindgauntletsii'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Whisperwind Gauntlets, even swifter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonFuryGauntlets : BEGauntlets {
	BECrimsonFuryGauntlets() : base() {
		$this.Name               = 'Crimson Fury Gauntlets'
		$this.MapObjName         = 'crimsonfurygauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that boil with controlled rage, increasing strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmeraldSoulGauntlets : BEGauntlets {
	BEEmeraldSoulGauntlets() : base() {
		$this.Name               = 'Emerald Soul Gauntlets'
		$this.MapObjName         = 'emeraldsoulgauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets pulsating with emerald energy, enhancing vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOnyxShadowGauntlets : BEGauntlets {
	BEOnyxShadowGauntlets() : base() {
		$this.Name               = 'Onyx Shadow Gauntlets'
		$this.MapObjName         = 'onyxshadowgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of pure shadow, absorbing all light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallGauntletsII : BEGauntlets {
	BEStarfallGauntletsII() : base() {
		$this.Name               = 'Starfall Gauntlets II'
		$this.MapObjName         = 'starfallgauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Starfall Gauntlets, stronger cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneEclipseGauntlets : BEGauntlets {
	BEMoonstoneEclipseGauntlets() : base() {
		$this.Name               = 'Moonstone Eclipse Gauntlets'
		$this.MapObjName         = 'moonstoneeclipsegauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 40
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers that absorb moonlight, enhancing night vision and stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBlazecoreGauntletsII : BEGauntlets {
	BEBlazecoreGauntletsII() : base() {
		$this.Name               = 'Blazecore Gauntlets II'
		$this.MapObjName         = 'blazecoregauntletsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Blazecore Gauntlets, hotter and more resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENightfallGauntletsII : BEGauntlets {
	BENightfallGauntletsII() : base() {
		$this.Name               = 'Nightfall Gauntlets II'
		$this.MapObjName         = 'nightfallgauntletsii'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Nightfall Gauntlets, deeper shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncientSteelGauntletsII : BEGauntlets {
	BEAncientSteelGauntletsII() : base() {
		$this.Name               = 'Ancient Steel Gauntlets II'
		$this.MapObjName         = 'ancientsteelgauntletsii'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further reinforced Ancient Steel Gauntlets, nearly unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineRadianceGauntlets : BEGauntlets {
	BEDivineRadianceGauntlets() : base() {
		$this.Name               = 'Divine Radiance Gauntlets'
		$this.MapObjName         = 'divineradiancegauntlets'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets emanating intense divine light, scorching foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidShardGauntletsII : BEGauntlets {
	BEVoidShardGauntletsII() : base() {
		$this.Name               = 'Void Shard Gauntlets II'
		$this.MapObjName         = 'voidshardgauntletsii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Void Shard Gauntlets, stronger disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonGuardGauntletsII : BEGauntlets {
	BECrimsonGuardGauntletsII() : base() {
		$this.Name               = 'Crimson Guard Gauntlets II'
		$this.MapObjName         = 'crimsonguardgauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Superior Crimson Guard Gauntlets, even more ferocious.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantresssEmbrace : BEGauntlets {
	BEEnchantresssEmbrace() : base() {
		$this.Name               = 'Enchantress''s Embrace'
		$this.MapObjName         = 'enchantresssembrace'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Advanced bands for a master enchantress, supreme magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERuneforgedGauntletsII : BEGauntlets {
	BERuneforgedGauntletsII() : base() {
		$this.Name               = 'Runeforged Gauntlets II'
		$this.MapObjName         = 'runeforgedgauntletsii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Runeforged Gauntlets, stronger mystical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthshakerGauntletsII : BEGauntlets {
	BEEarthshakerGauntletsII() : base() {
		$this.Name               = 'Earthshaker Gauntlets II'
		$this.MapObjName         = 'earthshakergauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Earthshaker Gauntlets, causing stronger tremors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESoulfireGripsII : BEGauntlets {
	BESoulfireGripsII() : base() {
		$this.Name               = 'Soulfire Grips II'
		$this.MapObjName         = 'soulfiregripsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Soulfire Grips, searing spirits with greater intensity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonheartGauntletsII : BEGauntlets {
	BEDragonheartGauntletsII() : base() {
		$this.Name               = 'Dragonheart Gauntlets II'
		$this.MapObjName         = 'dragonheartgauntletsii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating even greater draconic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialTearGauntletsII : BEGauntlets {
	BECelestialTearGauntletsII() : base() {
		$this.Name               = 'Celestial Tear Gauntlets II'
		$this.MapObjName         = 'celestialteargauntletsii'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Celestial Tear Gauntlets, drawing more cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPlateGauntletsII : BEGauntlets {
	BEAbyssalPlateGauntletsII() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets II'
		$this.MapObjName         = 'abyssalplategauntletsii'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further hardened Abyssal Plate Gauntlets, incredibly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFeatherGlovesII : BEGauntlets {
	BEPhoenixFeatherGlovesII() : base() {
		$this.Name               = 'Phoenix Feather Gloves II'
		$this.MapObjName         = 'phoenixfeatherglovesii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More protective Phoenix Feather Gloves, enhanced healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarlordsFuryGauntlets : BEGauntlets {
	BEWarlordsFuryGauntlets() : base() {
		$this.Name               = 'Warlord''s Fury Gauntlets'
		$this.MapObjName         = 'warlordsfurygauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets boiling with warlord''s fury, inspiring fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDreamsteelGauntletsII : BEGauntlets {
	BEDreamsteelGauntletsII() : base() {
		$this.Name               = 'Dreamsteel Gauntlets II'
		$this.MapObjName         = 'dreamsteelgauntletsii'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Dreamsteel Gauntlets, lighter and stronger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidstoneGauntletsII : BEGauntlets {
	BEVoidstoneGauntletsII() : base() {
		$this.Name               = 'Voidstone Gauntlets II'
		$this.MapObjName         = 'voidstonegauntletsii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Superior Voidstone Gauntlets, absorbing more magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunpetalHandguardsII : BEGauntlets {
	BESunpetalHandguardsII() : base() {
		$this.Name               = 'Sunpetal Handguards II'
		$this.MapObjName         = 'sunpetalhandguardsii'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More vibrant Sunpetal Handguards, enhanced healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEHeavyChainmailGauntlets : BEGauntlets {
	BEHeavyChainmailGauntlets() : base() {
		$this.Name               = 'Heavy Chainmail Gauntlets'
		$this.MapObjName         = 'heavychainmailgauntlets'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dense chainmail gauntlets, offering robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlessedSilverGauntlets : BEGauntlets {
	BEBlessedSilverGauntlets() : base() {
		$this.Name               = 'Blessed Silver Gauntlets'
		$this.MapObjName         = 'blessedsilvergauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of purified silver, effective against undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreadKnightGauntlets : BEGauntlets {
	BEDreadKnightGauntlets() : base() {
		$this.Name               = 'Dread Knight Gauntlets'
		$this.MapObjName         = 'dreadknightgauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fearsome dark knight, chilling to the touch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEFeyIronGauntlets : BEGauntlets {
	BEFeyIronGauntlets() : base() {
		$this.Name               = 'Fey Iron Gauntlets'
		$this.MapObjName         = 'feyirongauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from special Fey iron, resistant to magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESerpentTongueGloves : BEGauntlets {
	BESerpentTongueGloves() : base() {
		$this.Name               = 'Serpent Tongue Gloves'
		$this.MapObjName         = 'serpenttonguegloves'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 12
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with a subtle serpentine pattern, aiding in swiftness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrusadersMightGauntlets : BEGauntlets {
	BECrusadersMightGauntlets() : base() {
		$this.Name               = 'Crusader''s Might Gauntlets'
		$this.MapObjName         = 'crusadersmightgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavily fortified gauntlets of a valiant crusader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMoonlitDewGloves : BEGauntlets {
	BEMoonlitDewGloves() : base() {
		$this.Name               = 'Moonlit Dew Gloves'
		$this.MapObjName         = 'moonlitdewgloves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves shimmering with moonlight dew, granting restorative power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESentinelsBulwark : BEGauntlets {
	BESentinelsBulwark() : base() {
		$this.Name               = 'Sentinel''s Bulwark'
		$this.MapObjName         = 'sentinelsbulwark'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that seem to project a defensive aura.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWildheartGauntlets : BEGauntlets {
	BEWildheartGauntlets() : base() {
		$this.Name               = 'Wildheart Gauntlets'
		$this.MapObjName         = 'wildheartgauntlets'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made from primal beast hide, granting strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderclapGauntlets : BEGauntlets {
	BEThunderclapGauntlets() : base() {
		$this.Name               = 'Thunderclap Gauntlets'
		$this.MapObjName         = 'thunderclapgauntlets'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that resonate with thunder, stunning foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritwovenArmbands : BEGauntlets {
	BESpiritwovenArmbands() : base() {
		$this.Name               = 'Spiritwoven Armbands'
		$this.MapObjName         = 'spiritwovenarmbands'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armbands intricately woven with spiritual energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDragonshardGauntlets : BEGauntlets {
	BEDragonshardGauntlets() : base() {
		$this.Name               = 'Dragonshard Gauntlets'
		$this.MapObjName         = 'dragonshardgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets embedded with fragments of dragon shards, immensely powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarforgedVambraces : BEGauntlets {
	BEStarforgedVambraces() : base() {
		$this.Name               = 'Starforged Vambraces'
		$this.MapObjName         = 'starforgedvambraces'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 22
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces forged under a specific constellation, granting luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGravecallerGauntlets : BEGauntlets {
	BEGravecallerGauntlets() : base() {
		$this.Name               = 'Gravecaller Gauntlets'
		$this.MapObjName         = 'gravecallergauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that hum with the whispers of the deceased, aiding necromancy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialBlessingGauntlets : BEGauntlets {
	BECelestialBlessingGauntlets() : base() {
		$this.Name               = 'Celestial Blessing Gauntlets'
		$this.MapObjName         = 'celestialblessinggauntlets'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 78
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets blessed by celestial beings, divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidheartGrips : BEGauntlets {
	BEVoidheartGrips() : base() {
		$this.Name               = 'Voidheart Grips'
		$this.MapObjName         = 'voidheartgrips'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that feel cold to the touch, connected to the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneSentinelGauntlets : BEGauntlets {
	BEArcaneSentinelGauntlets() : base() {
		$this.Name               = 'Arcane Sentinel Gauntlets'
		$this.MapObjName         = 'arcanesentinelgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of an ancient order of arcane guardians, robust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELionheartVambraces : BEGauntlets {
	BELionheartVambraces() : base() {
		$this.Name               = 'Lionheart Vambraces'
		$this.MapObjName         = 'lionheartvambraces'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces bearing the crest of a lion, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEValkyriesWingsGloves : BEGauntlets {
	BEValkyriesWingsGloves() : base() {
		$this.Name               = 'Valkyrie''s Wings Gloves'
		$this.MapObjName         = 'valkyrieswingsgloves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
			[StatId]::Accuracy = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves with feather-like lightness, allowing swift movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESerpentfangGauntlets : BEGauntlets {
	BESerpentfangGauntlets() : base() {
		$this.Name               = 'Serpentfang Gauntlets'
		$this.MapObjName         = 'serpentfanggauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with venomous serpent fangs, for deadly strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemLordGauntlets : BEGauntlets {
	BEGolemLordGauntlets() : base() {
		$this.Name               = 'Golem Lord Gauntlets'
		$this.MapObjName         = 'golemlordgauntlets'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a golem lord, commanding immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEMoonpetalGauntlets : BEGauntlets {
	BEMoonpetalGauntlets() : base() {
		$this.Name               = 'Moonpetal Gauntlets'
		$this.MapObjName         = 'moonpetalgauntlets'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets made of moonlight-infused petals, magically potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECenturionsLegacyGauntlets : BEGauntlets {
	BECenturionsLegacyGauntlets() : base() {
		$this.Name               = 'Centurion''s Legacy Gauntlets'
		$this.MapObjName         = 'centurionslegacygauntlets'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a legendary centurion, carrying his might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpellboundGauntletsII : BEGauntlets {
	BESpellboundGauntletsII() : base() {
		$this.Name               = 'Spellbound Gauntlets II'
		$this.MapObjName         = 'spellboundgauntletsii'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Spellbound Gauntlets, stronger protective spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronGuardGauntletsII : BEGauntlets {
	BEIronGuardGauntletsII() : base() {
		$this.Name               = 'Iron Guard Gauntlets II'
		$this.MapObjName         = 'ironguardgauntletsii'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Reinforced Iron Guard Gauntlets, sturdier.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrigandsPlatedBracers : BEGauntlets {
	BEBrigandsPlatedBracers() : base() {
		$this.Name               = 'Brigand''s Plated Bracers'
		$this.MapObjName         = 'brigandsplatedbracers'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plated bracers favored by elite brigands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsVengeanceGauntlets : BEGauntlets {
	BEZealotsVengeanceGauntlets() : base() {
		$this.Name               = 'Zealot''s Vengeance Gauntlets'
		$this.MapObjName         = 'zealotsvengeancegauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a vengeful zealot, empowering their strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilkenEnchantmentGloves : BEGauntlets {
	BESilkenEnchantmentGloves() : base() {
		$this.Name               = 'Silken Enchantment Gloves'
		$this.MapObjName         = 'silkenenchantmentgloves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Silken gloves imbued with potent enchantments, boosting magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEApprenticesRunebands : BEGauntlets {
	BEApprenticesRunebands() : base() {
		$this.Name               = 'Apprentice''s Runebands'
		$this.MapObjName         = 'apprenticesrunebands'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic runebands for a magic apprentice, aiding their studies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWanderersIronGauntlets : BEGauntlets {
	BEWanderersIronGauntlets() : base() {
		$this.Name               = 'Wanderer''s Iron Gauntlets'
		$this.MapObjName         = 'wanderersirongauntlets'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets for a seasoned wanderer, robust and practical.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFabledChampionGauntlets : BEGauntlets {
	BEFabledChampionGauntlets() : base() {
		$this.Name               = 'Fabled Champion Gauntlets'
		$this.MapObjName         = 'fabledchampiongauntlets'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 135
			[StatId]::MagicDefense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fabled champion, unmatched power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGrimskullLordGauntlets : BEGauntlets {
	BEGrimskullLordGauntlets() : base() {
		$this.Name               = 'Grimskull Lord Gauntlets'
		$this.MapObjName         = 'grimskulllordgauntlets'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a grimskull lord, radiating immense dread.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BECrystalweaveGlovesII : BEGauntlets {
	BECrystalweaveGlovesII() : base() {
		$this.Name               = 'Crystalweave Gloves II'
		$this.MapObjName         = 'crystalweaveglovesii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Crystalweave Gloves, enhancing focus further.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDragonswornGauntletsII : BEGauntlets {
	BEDragonswornGauntletsII() : base() {
		$this.Name               = 'Dragonsworn Gauntlets II'
		$this.MapObjName         = 'dragonsworngauntletsii'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Dragonsworn Gauntlets, stronger loyalty to dragons.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternalFlameGauntletsII : BEGauntlets {
	BEEternalFlameGauntletsII() : base() {
		$this.Name               = 'Eternal Flame Gauntlets II'
		$this.MapObjName         = 'eternalflamegauntletsii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 95
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stronger Eternal Flame Gauntlets, more intense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhispersteelGauntletsII : BEGauntlets {
	BEWhispersteelGauntletsII() : base() {
		$this.Name               = 'Whispersteel Gauntlets II'
		$this.MapObjName         = 'whispersteelgauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Further enhanced Whispersteel Gauntlets, more silent and potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneskinGripsII : BEGauntlets {
	BEStoneskinGripsII() : base() {
		$this.Name               = 'Stoneskin Grips II'
		$this.MapObjName         = 'stoneskingripsii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Stoneskin Grips, turning skin to tougher stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEGoddesssTouchGauntlets : BEGauntlets {
	BEGoddesssTouchGauntlets() : base() {
		$this.Name               = 'Goddess''s Touch Gauntlets'
		$this.MapObjName         = 'goddessstouchgauntlets'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets said to be touched by a goddess, supreme defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEChampionsGloryGauntlets : BEGauntlets {
	BEChampionsGloryGauntlets() : base() {
		$this.Name               = 'Champion''s Glory Gauntlets'
		$this.MapObjName         = 'championsglorygauntlets'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating the glory of a champion, inspiring allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWraithtouchGlovesII : BEGauntlets {
	BEWraithtouchGlovesII() : base() {
		$this.Name               = 'Wraithtouch Gloves II'
		$this.MapObjName         = 'wraithtouchglovesii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Wraithtouch Gloves, chilling effect intensified.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitanforgedGauntletsII : BEGauntlets {
	BETitanforgedGauntletsII() : base() {
		$this.Name               = 'Titanforged Gauntlets II'
		$this.MapObjName         = 'titanforgedgauntletsii'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 120
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Even more massive Titanforged Gauntlets, immense and heavy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEtherealBandsII : BEGauntlets {
	BEEtherealBandsII() : base() {
		$this.Name               = 'Ethereal Bands II'
		$this.MapObjName         = 'etherealbandsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More pure Ethereal Bands, granting greater magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlademasterGauntletsII : BEGauntlets {
	BEBlademasterGauntletsII() : base() {
		$this.Name               = 'Blademaster Gauntlets II'
		$this.MapObjName         = 'blademastergauntletsii'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhanced Blademaster Gauntlets, greater precision and offense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOathswornGauntletsII : BEGauntlets {
	BEOathswornGauntletsII() : base() {
		$this.Name               = 'Oathsworn Gauntlets II'
		$this.MapObjName         = 'oathsworngauntletsii'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Oathsworn Gauntlets, unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESilverlightGlovesII : BEGauntlets {
	BESilverlightGlovesII() : base() {
		$this.Name               = 'Silverlight Gloves II'
		$this.MapObjName         = 'silverlightglovesii'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brighter Silverlight Gloves, revealing more hidden paths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGuardiansResolveGauntlets : BEGauntlets {
	BEGuardiansResolveGauntlets() : base() {
		$this.Name               = 'Guardian''s Resolve Gauntlets'
		$this.MapObjName         = 'guardiansresolvegauntlets'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a guardian''s unwavering resolve.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticRelicGauntletsII : BEGauntlets {
	BEMysticRelicGauntletsII() : base() {
		$this.Name               = 'Mystic Relic Gauntlets II'
		$this.MapObjName         = 'mysticrelicgauntletsii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Mystic Relic Gauntlets, holding stronger ancient power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowdancerGlovesII : BEGauntlets {
	BEShadowdancerGlovesII() : base() {
		$this.Name               = 'Shadowdancer Gloves II'
		$this.MapObjName         = 'shadowdancerglovesii'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
			[StatId]::Accuracy = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More advanced Shadowdancer Gloves, allowing greater agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBattlewornGauntletsII : BEGauntlets {
	BEBattlewornGauntletsII() : base() {
		$this.Name               = 'Battleworn Gauntlets II'
		$this.MapObjName         = 'battleworngauntletsii'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Battleworn Gauntlets hardened by more battles, even stronger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESpiritboundGauntletsII : BEGauntlets {
	BESpiritboundGauntletsII() : base() {
		$this.Name               = 'Spiritbound Gauntlets II'
		$this.MapObjName         = 'spiritboundgauntletsii'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Spiritbound Gauntlets, stronger link to spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomousGripsII : BEGauntlets {
	BEVenomousGripsII() : base() {
		$this.Name               = 'Venomous Grips II'
		$this.MapObjName         = 'venomousgripsii'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 12
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Venomous Grips, dripping with stronger poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZealotsHolyFists : BEGauntlets {
	BEZealotsHolyFists() : base() {
		$this.Name               = 'Zealot''s Holy Fists'
		$this.MapObjName         = 'zealotsholyfists'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists of a truly righteous zealot, imbued with divine fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEmeraldScaleGauntletsII : BEGauntlets {
	BEEmeraldScaleGauntletsII() : base() {
		$this.Name               = 'Emerald Scale Gauntlets II'
		$this.MapObjName         = 'emeraldscalegauntletsii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 60
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More vibrant Emerald Scale Gauntlets, stronger protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostWeaverGlovesII : BEGauntlets {
	BEFrostWeaverGlovesII() : base() {
		$this.Name               = 'Frost Weaver Gloves II'
		$this.MapObjName         = 'frostweaverglovesii'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Improved Frost Weaver Gloves, manipulating ice with greater skill.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEOnyxClawGauntletsII : BEGauntlets {
	BEOnyxClawGauntletsII() : base() {
		$this.Name               = 'Onyx Claw Gauntlets II'
		$this.MapObjName         = 'onyxclawgauntletsii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Onyx Claw Gauntlets, for deeper piercing attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarshardGauntletsII : BEGauntlets {
	BEStarshardGauntletsII() : base() {
		$this.Name               = 'Starshard Gauntlets II'
		$this.MapObjName         = 'starshardgauntletsii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More powerful Starshard Gauntlets, radiating stronger cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneBracersII : BEGauntlets {
	BEMoonstoneBracersII() : base() {
		$this.Name               = 'Moonstone Bracers II'
		$this.MapObjName         = 'moonstonebracersii'
		$this.PurchasePrice      = 1080
		$this.SellPrice          = 540
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 42
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brighter Moonstone Bracers, enhancing nocturnal endeavors further.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBlazecoreGauntletsIII : BEGauntlets {
	BEBlazecoreGauntletsIII() : base() {
		$this.Name               = 'Blazecore Gauntlets III'
		$this.MapObjName         = 'blazecoregauntletsiii'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Blazecore Gauntlets, intensely hot and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BENightfallGauntletsIII : BEGauntlets {
	BENightfallGauntletsIII() : base() {
		$this.Name               = 'Nightfall Gauntlets III'
		$this.MapObjName         = 'nightfallgauntletsiii'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 35
			[StatId]::Accuracy = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Nightfall Gauntlets, deepest shadows, supreme stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAncientSteelGauntletsIII : BEGauntlets {
	BEAncientSteelGauntletsIII() : base() {
		$this.Name               = 'Ancient Steel Gauntlets III'
		$this.MapObjName         = 'ancientsteelgauntletsiii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ancient Steel Gauntlets of ultimate durability, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineEssenceGauntletsIII : BEGauntlets {
	BEDivineEssenceGauntletsIII() : base() {
		$this.Name               = 'Divine Essence Gauntlets III'
		$this.MapObjName         = 'divineessencegauntletsiii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Divine Essence Gauntlets, radiating pure divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidShardGlovesIII : BEGauntlets {
	BEVoidShardGlovesIII() : base() {
		$this.Name               = 'Void Shard Gloves III'
		$this.MapObjName         = 'voidshardglovesiii'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Void Shard Gloves, supreme disorientation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonGuardGauntletsIII : BEGauntlets {
	BECrimsonGuardGauntletsIII() : base() {
		$this.Name               = 'Crimson Guard Gauntlets III'
		$this.MapObjName         = 'crimsonguardgauntletsiii'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crimson Guard Gauntlets of unparalleled ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEEnchantresssGrasp : BEGauntlets {
	BEEnchantresssGrasp() : base() {
		$this.Name               = 'Enchantress''s Grasp'
		$this.MapObjName         = 'enchantresssgrasp'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate bands for an enchantress, absolute magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERuneforgedGauntletsIII : BEGauntlets {
	BERuneforgedGauntletsIII() : base() {
		$this.Name               = 'Runeforged Gauntlets III'
		$this.MapObjName         = 'runeforgedgauntletsiii'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Runeforged Gauntlets, absolute mystical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthshakerGauntletsIII : BEGauntlets {
	BEEarthshakerGauntletsIII() : base() {
		$this.Name               = 'Earthshaker Gauntlets III'
		$this.MapObjName         = 'earthshakergauntletsiii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 80
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Earthshaker Gauntlets, causing devastating tremors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BESoulfireGripsIII : BEGauntlets {
	BESoulfireGripsIII() : base() {
		$this.Name               = 'Soulfire Grips III'
		$this.MapObjName         = 'soulfiregripsiii'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Soulfire Grips, searing spirits with maximum intensity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonheartGauntletsIII : BEGauntlets {
	BEDragonheartGauntletsIII() : base() {
		$this.Name               = 'Dragonheart Gauntlets III'
		$this.MapObjName         = 'dragonheartgauntletsiii'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating the heart of a true dragon, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialTearGauntletsIII : BEGauntlets {
	BECelestialTearGauntletsIII() : base() {
		$this.Name               = 'Celestial Tear Gauntlets III'
		$this.MapObjName         = 'celestialteargauntletsiii'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 105
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Celestial Tear Gauntlets, drawing maximum cosmic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPlateGauntletsIII : BEGauntlets {
	BEAbyssalPlateGauntletsIII() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets III'
		$this.MapObjName         = 'abyssalplategauntletsiii'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Abyssal Plate Gauntlets, unyielding resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixFeatherGlovesIII : BEGauntlets {
	BEPhoenixFeatherGlovesIII() : base() {
		$this.Name               = 'Phoenix Feather Gloves III'
		$this.MapObjName         = 'phoenixfeatherglovesiii'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 58
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Phoenix Feather Gloves, supreme healing and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarlordsDominionGauntlets : BEGauntlets {
	BEWarlordsDominionGauntlets() : base() {
		$this.Name               = 'Warlord''s Dominion Gauntlets'
		$this.MapObjName         = 'warlordsdominiongauntlets'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 88
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that command absolute dominion, inspiring awe.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEDreamsteelGauntletsIII : BEGauntlets {
	BEDreamsteelGauntletsIII() : base() {
		$this.Name               = 'Dreamsteel Gauntlets III'
		$this.MapObjName         = 'dreamsteelgauntletsiii'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 85
			[StatId]::MagicDefense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Dreamsteel Gauntlets, impossibly light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidstoneGauntletsIII : BEGauntlets {
	BEVoidstoneGauntletsIII() : base() {
		$this.Name               = 'Voidstone Gauntlets III'
		$this.MapObjName         = 'voidstonegauntletsiii'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Voidstone Gauntlets, absorbing all magical attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunpetalHandguardsIII : BEGauntlets {
	BESunpetalHandguardsIII() : base() {
		$this.Name               = 'Sunpetal Handguards III'
		$this.MapObjName         = 'sunpetalhandguardsiii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 50
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ultimate Sunpetal Handguards, vibrant and supremely healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
