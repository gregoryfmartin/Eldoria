Class BECottonTunic : BEArmor {
	BECottonTunic() : base() {
		$this.Name               = 'Cotton Tunic'
		$this.MapObjName         = 'cottontunic'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic made of soft cotton, comfortable for everyday wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherVest : BEArmor {
	BELeatherVest() : base() {
		$this.Name               = 'Leather Vest'
		$this.MapObjName         = 'leathervest'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic leather vest offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaddedShirt : BEArmor {
	BEPaddedShirt() : base() {
		$this.Name               = 'Padded Shirt'
		$this.MapObjName         = 'paddedshirt'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A quilted shirt providing light defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELinenRobe : BEArmor {
	BELinenRobe() : base() {
		$this.Name               = 'Linen Robe'
		$this.MapObjName         = 'linenrobe'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A loose-fitting robe suitable for mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStuddedLeatherArmor : BEArmor {
	BEStuddedLeatherArmor() : base() {
		$this.Name               = 'Studded Leather Armor'
		$this.MapObjName         = 'studdedleatherarmor'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather armor reinforced with metal studs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChainmailVest : BEArmor {
	BEChainmailVest() : base() {
		$this.Name               = 'Chainmail Vest'
		$this.MapObjName         = 'chainmailvest'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made of interlocking metal rings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronBreastplate : BEArmor {
	BEIronBreastplate() : base() {
		$this.Name               = 'Iron Breastplate'
		$this.MapObjName         = 'ironbreastplate'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solid iron plate protecting the chest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilkRobe : BEArmor {
	BESilkRobe() : base() {
		$this.Name               = 'Silk Robe'
		$this.MapObjName         = 'silkrobe'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{ [StatId]::MagicDefense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luxurious robe woven from fine silk, enhancing magical prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBronzeCuirass : BEArmor {
	BEBronzeCuirass() : base() {
		$this.Name               = 'Bronze Cuirass'
		$this.MapObjName         = 'bronzecuirass'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy chest piece crafted from bronze.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMithrilChainmail : BEArmor {
	BEMithrilChainmail() : base() {
		$this.Name               = 'Mithril Chainmail'
		$this.MapObjName         = 'mithrilchainmail'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong chainmail.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelPlateArmor : BEArmor {
	BESteelPlateArmor() : base() {
		$this.Name               = 'Steel Plate Armor'
		$this.MapObjName         = 'steelplatearmor'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and reliable steel plate armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnchantedRobe : BEArmor {
	BEEnchantedRobe() : base() {
		$this.Name               = 'Enchanted Robe'
		$this.MapObjName         = 'enchantedrobe'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::MagicDefense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonhideVest : BEArmor {
	BEDragonhideVest() : base() {
		$this.Name               = 'Dragonhide Vest'
		$this.MapObjName         = 'dragonhidevest'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the tough hide of a dragon.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEKnightsCuirass : BEArmor {
	BEKnightsCuirass() : base() {
		$this.Name               = 'Knight''s Cuirass'
		$this.MapObjName         = 'knightscuirass'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The polished chest plate of a valiant knight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticRobe : BEArmor {
	BEMysticRobe() : base() {
		$this.Name               = 'Mystic Robe'
		$this.MapObjName         = 'mysticrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe pulsating with arcane energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdamantitePlate : BEArmor {
	BEAdamantitePlate() : base() {
		$this.Name               = 'Adamantite Plate'
		$this.MapObjName         = 'adamantiteplate'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely durable armor forged from adamantite.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialTunic : BEArmor {
	BECelestialTunic() : base() {
		$this.Name               = 'Celestial Tunic'
		$this.MapObjName         = 'celestialtunic'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic said to be woven from starlight, offering slight protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelersShirt : BEArmor {
	BETravelersShirt() : base() {
		$this.Name               = 'Traveler''s Shirt'
		$this.MapObjName         = 'travelersshirt'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable and durable shirt for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFishermansVest : BEArmor {
	BEFishermansVest() : base() {
		$this.Name               = 'Fisherman''s Vest'
		$this.MapObjName         = 'fishermansvest'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical vest with many pockets, surprisingly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWoolenTunic : BEArmor {
	BEWoolenTunic() : base() {
		$this.Name               = 'Woolen Tunic'
		$this.MapObjName         = 'woolentunic'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm tunic, ideal for colder climates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherJacket : BEArmor {
	BELeatherJacket() : base() {
		$this.Name               = 'Leather Jacket'
		$this.MapObjName         = 'leatherjacket'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish leather jacket offering modest defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBrigandineVest : BEArmor {
	BEBrigandineVest() : base() {
		$this.Name               = 'Brigandine Vest'
		$this.MapObjName         = 'brigandinevest'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::Defense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made of small metal plates riveted to cloth or leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScaleMail : BEArmor {
	BEScaleMail() : base() {
		$this.Name               = 'Scale Mail'
		$this.MapObjName         = 'scalemail'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor made from overlapping scales of metal or hardened leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDarkRobe : BEArmor {
	BEDarkRobe() : base() {
		$this.Name               = 'Dark Robe'
		$this.MapObjName         = 'darkrobe'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{ [StatId]::MagicDefense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A foreboding robe, favored by shadow mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGuardiansBreastplate : BEArmor {
	BEGuardiansBreastplate() : base() {
		$this.Name               = 'Guardian''s Breastplate'
		$this.MapObjName         = 'guardiansbreastplate'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy breastplate designed for protectors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElvenChainmail : BEArmor {
	BEElvenChainmail() : base() {
		$this.Name               = 'Elven Chainmail'
		$this.MapObjName         = 'elvenchainmail'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 12; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Delicately crafted chainmail, light and resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPaladinsCuirass : BEArmor {
	BEPaladinsCuirass() : base() {
		$this.Name               = 'Paladin''s Cuirass'
		$this.MapObjName         = 'paladinscuirass'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 22; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blessed cuirass, offering both defense and spiritual resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcerersRobe : BEArmor {
	BESorcerersRobe() : base() {
		$this.Name               = 'Sorcerer''s Robe'
		$this.MapObjName         = 'sorcerersrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::MagicDefense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe designed to amplify magical incantations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDwarvenPlate : BEArmor {
	BEDwarvenPlate() : base() {
		$this.Name               = 'Dwarven Plate'
		$this.MapObjName         = 'dwarvenplate'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and robust plate armor, masterfully forged.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixRobe : BEArmor {
	BEPhoenixRobe() : base() {
		$this.Name               = 'Phoenix Robe'
		$this.MapObjName         = 'phoenixrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant robe said to grant its wearer renewed vigor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHerosPlate : BEArmor {
	BEHerosPlate() : base() {
		$this.Name               = 'Hero''s Plate'
		$this.MapObjName         = 'herosplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The legendary plate armor of a true hero.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESimpleDress : BEArmor {
	BESimpleDress() : base() {
		$this.Name               = 'Simple Dress'
		$this.MapObjName         = 'simpledress'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{ [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic dress, comfortable for daily wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMaidensBlouse : BEArmor {
	BEMaidensBlouse() : base() {
		$this.Name               = 'Maiden''s Blouse'
		$this.MapObjName         = 'maidensblouse'
		$this.PurchasePrice      = 75
		$this.SellPrice          = 38
		$this.TargetStats        = @{ [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate blouse often worn by young women.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEChefsApron : BEArmor {
	BEChefsApron() : base() {
		$this.Name               = 'Chef''s Apron'
		$this.MapObjName         = 'chefsapron'
		$this.PurchasePrice      = 85
		$this.SellPrice          = 42
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A surprisingly durable apron, good for resisting minor damage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMerchantsVest : BEArmor {
	BEMerchantsVest() : base() {
		$this.Name               = 'Merchant''s Vest'
		$this.MapObjName         = 'merchantsvest'
		$this.PurchasePrice      = 95
		$this.SellPrice          = 48
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple vest with hidden pockets, provides little defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEApprenticesRobe : BEArmor {
	BEApprenticesRobe() : base() {
		$this.Name               = 'Apprentice''s Robe'
		$this.MapObjName         = 'apprenticesrobe'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::MagicDefense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain robe worn by aspiring mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHuntersTunic : BEArmor {
	BEHuntersTunic() : base() {
		$this.Name               = 'Hunter''s Tunic'
		$this.MapObjName         = 'hunterstunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged tunic, ideal for tracking and stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReinforcedLeather : BEArmor {
	BEReinforcedLeather() : base() {
		$this.Name               = 'Reinforced Leather'
		$this.MapObjName         = 'reinforcedleather'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Leather armor with additional plating for better defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBanditsJerkin : BEArmor {
	BEBanditsJerkin() : base() {
		$this.Name               = 'Bandit''s Jerkin'
		$this.MapObjName         = 'banditsjerkin'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patched-up jerkin, good for mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMagesTunic : BEArmor {
	BEMagesTunic() : base() {
		$this.Name               = 'Mage''s Tunic'
		$this.MapObjName         = 'magestunic'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{ [StatId]::MagicDefense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable tunic that aids in spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGothicPlate : BEArmor {
	BEGothicPlate() : base() {
		$this.Name               = 'Gothic Plate'
		$this.MapObjName         = 'gothicplate'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, imposing plate armor with sharp edges.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAcolytesRobe : BEArmor {
	BEAcolytesRobe() : base() {
		$this.Name               = 'Acolyte''s Robe'
		$this.MapObjName         = 'acolytesrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A solemn robe worn by those devoted to ancient deities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrusadersBreastplate : BEArmor {
	BECrusadersBreastplate() : base() {
		$this.Name               = 'Crusader''s Breastplate'
		$this.MapObjName         = 'crusadersbreastplate'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 23; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A holy breastplate, blessed against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERoyalGown : BEArmor {
	BERoyalGown() : base() {
		$this.Name               = 'Royal Gown'
		$this.MapObjName         = 'royalgown'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant gown, offering prestige more than protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorsTunic : BEArmor {
	BEWarriorsTunic() : base() {
		$this.Name               = 'Warrior''s Tunic'
		$this.MapObjName         = 'warriorstunic'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy tunic designed for frontline combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThiefsVest : BEArmor {
	BEThiefsVest() : base() {
		$this.Name               = 'Thief''s Vest'
		$this.MapObjName         = 'thiefsvest'
		$this.PurchasePrice      = 210
		$this.SellPrice          = 105
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight vest designed for agility and concealment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClericsVestments : BEArmor {
	BEClericsVestments() : base() {
		$this.Name               = 'Cleric''s Vestments'
		$this.MapObjName         = 'clericsvestments'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::MagicDefense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed vestments providing spiritual protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGladiatorsHarness : BEArmor {
	BEGladiatorsHarness() : base() {
		$this.Name               = 'Gladiator''s Harness'
		$this.MapObjName         = 'gladiatorsharness'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A minimal but tough harness designed for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESamuraiArmor : BEArmor {
	BESamuraiArmor() : base() {
		$this.Name               = 'Samurai Armor'
		$this.MapObjName         = 'samuraiarmor'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Intricate and strong armor, balanced for offense and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENinjaGarb : BEArmor {
	BENinjaGarb() : base() {
		$this.Name               = 'Ninja Garb'
		$this.MapObjName         = 'ninjagarb'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 15; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, flexible clothing for stealth and swift movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVestoftheWild : BEArmor {
	BEVestoftheWild() : base() {
		$this.Name               = 'Vest of the Wild'
		$this.MapObjName         = 'vestofthewild'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from beast hides, ideal for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECourtWizardsRobe : BEArmor {
	BECourtWizardsRobe() : base() {
		$this.Name               = 'Court Wizard''s Robe'
		$this.MapObjName         = 'courtwizardsrobe'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely embroidered robe, befitting a royal mage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHeavyLeatherArmor : BEArmor {
	BEHeavyLeatherArmor() : base() {
		$this.Name               = 'Heavy Leather Armor'
		$this.MapObjName         = 'heavyleatherarmor'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{ [StatId]::Defense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Thick layers of leather for enhanced defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilverChainmail : BEArmor {
	BESilverChainmail() : base() {
		$this.Name               = 'Silver Chainmail'
		$this.MapObjName         = 'silverchainmail'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail woven with strands of silver, effective against dark creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoldenCuirass : BEArmor {
	BEGoldenCuirass() : base() {
		$this.Name               = 'Golden Cuirass'
		$this.MapObjName         = 'goldencuirass'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 16; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A polished gold-plated cuirass, more for show than defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritRobe : BEArmor {
	BESpiritRobe() : base() {
		$this.Name               = 'Spirit Robe'
		$this.MapObjName         = 'spiritrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent robe that shimmers with ethereal energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianPlate : BEArmor {
	BEObsidianPlate() : base() {
		$this.Name               = 'Obsidian Plate'
		$this.MapObjName         = 'obsidianplate'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from solidified volcanic glass, very strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESagesRobe : BEArmor {
	BESagesRobe() : base() {
		$this.Name               = 'Sage''s Robe'
		$this.MapObjName         = 'sagesrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple yet powerful robe, worn by wise mystics.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBattle-WornTunic : BEArmor {
	BEBattle-WornTunic() : base() {
		$this.Name               = 'Battle-Worn Tunic'
		$this.MapObjName         = 'battle-worntunic'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A torn but resilient tunic, seen many skirmishes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFarmersSmock : BEArmor {
	BEFarmersSmock() : base() {
		$this.Name               = 'Farmer''s Smock'
		$this.MapObjName         = 'farmerssmock'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rough smock, offering almost no protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERangersVest : BEArmor {
	BERangersVest() : base() {
		$this.Name               = 'Ranger''s Vest'
		$this.MapObjName         = 'rangersvest'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical vest with many pockets, good for outdoor life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScholarsRobe : BEArmor {
	BEScholarsRobe() : base() {
		$this.Name               = 'Scholar''s Robe'
		$this.MapObjName         = 'scholarsrobe'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{ [StatId]::MagicDefense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable robe for long hours of study.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHardLeatherVest : BEArmor {
	BEHardLeatherVest() : base() {
		$this.Name               = 'Hard Leather Vest'
		$this.MapObjName         = 'hardleathervest'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stiff leather vest, slightly more protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELightChainmail : BEArmor {
	BELightChainmail() : base() {
		$this.Name               = 'Light Chainmail'
		$this.MapObjName         = 'lightchainmail'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lighter version of chainmail, for increased mobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESteelBreastplate : BEArmor {
	BESteelBreastplate() : base() {
		$this.Name               = 'Steel Breastplate'
		$this.MapObjName         = 'steelbreastplate'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{ [StatId]::Defense = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A standard issue breastplate for soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneRobe : BEArmor {
	BEArcaneRobe() : base() {
		$this.Name               = 'Arcane Robe'
		$this.MapObjName         = 'arcanerobe'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{ [StatId]::MagicDefense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe crackling with uncontrolled magical energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReinforcedCuirass : BEArmor {
	BEReinforcedCuirass() : base() {
		$this.Name               = 'Reinforced Cuirass'
		$this.MapObjName         = 'reinforcedcuirass'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass with extra plating in vital areas.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMysticalChainmail : BEArmor {
	BEMysticalChainmail() : base() {
		$this.Name               = 'Mystical Chainmail'
		$this.MapObjName         = 'mysticalchainmail'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 11; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail imbued with minor protective enchantments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFullPlateArmor : BEArmor {
	BEFullPlateArmor() : base() {
		$this.Name               = 'Full Plate Armor'
		$this.MapObjName         = 'fullplatearmor'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Complete and heavy plate armor, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadowRobe : BEArmor {
	BEShadowRobe() : base() {
		$this.Name               = 'Shadow Robe'
		$this.MapObjName         = 'shadowrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that allows the wearer to blend into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernhideVest : BEArmor {
	BEWyvernhideVest() : base() {
		$this.Name               = 'Wyvernhide Vest'
		$this.MapObjName         = 'wyvernhidevest'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the tough hide of a wyvern.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmperorsCuirass : BEArmor {
	BEEmperorsCuirass() : base() {
		$this.Name               = 'Emperor''s Cuirass'
		$this.MapObjName         = 'emperorscuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial cuirass, intricately decorated.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralRobe : BEArmor {
	BEAstralRobe() : base() {
		$this.Name               = 'Astral Robe'
		$this.MapObjName         = 'astralrobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be woven from threads of the cosmos.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELegendaryPlate : BEArmor {
	BELegendaryPlate() : base() {
		$this.Name               = 'Legendary Plate'
		$this.MapObjName         = 'legendaryplate'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{ [StatId]::Defense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor of unfathomable strength, rumored to be divine.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENursesUniform : BEArmor {
	BENursesUniform() : base() {
		$this.Name               = 'Nurse''s Uniform'
		$this.MapObjName         = 'nursesuniform'
		$this.PurchasePrice      = 65
		$this.SellPrice          = 33
		$this.TargetStats        = @{ [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple white uniform, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBallGown : BEArmor {
	BEBallGown() : base() {
		$this.Name               = 'Ball Gown'
		$this.MapObjName         = 'ballgown'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent gown, offers no protection but great charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDancersVeil : BEArmor {
	BEDancersVeil() : base() {
		$this.Name               = 'Dancer''s Veil'
		$this.MapObjName         = 'dancersveil'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Defense = 1; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, flowing garment that enhances agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEPriestesssRobe : BEArmor {
	BEPriestesssRobe() : base() {
		$this.Name               = 'Priestess''s Robe'
		$this.MapObjName         = 'priestesssrobe'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{ [StatId]::MagicDefense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure white robe, blessed with divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpellbindersRobe : BEArmor {
	BESpellbindersRobe() : base() {
		$this.Name               = 'Spellbinder''s Robe'
		$this.MapObjName         = 'spellbindersrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant robe that hums with magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMatriarchsGown : BEArmor {
	BEMatriarchsGown() : base() {
		$this.Name               = 'Matriarch''s Gown'
		$this.MapObjName         = 'matriarchsgown'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An imposing gown worn by powerful female leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEValkyriesCuirass : BEArmor {
	BEValkyriesCuirass() : base() {
		$this.Name               = 'Valkyrie''s Cuirass'
		$this.MapObjName         = 'valkyriescuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::Defense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A golden cuirass worn by valiant warrior women.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEnchantresssGown : BEArmor {
	BEEnchantresssGown() : base() {
		$this.Name               = 'Enchantress''s Gown'
		$this.MapObjName         = 'enchantresssgown'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gown of exquisite design, perfect for casting powerful spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEAmazonianBreastplate : BEArmor {
	BEAmazonianBreastplate() : base() {
		$this.Name               = 'Amazonian Breastplate'
		$this.MapObjName         = 'amazonianbreastplate'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light but sturdy breastplate for female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEQueensRegalia : BEArmor {
	BEQueensRegalia() : base() {
		$this.Name               = 'Queen''s Regalia'
		$this.MapObjName         = 'queensregalia'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 24 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ceremonial robes of a queen, imbued with subtle magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEHuntresssVest : BEArmor {
	BEHuntresssVest() : base() {
		$this.Name               = 'Huntress''s Vest'
		$this.MapObjName         = 'huntresssvest'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged vest designed for female hunters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDruidesssRobe : BEArmor {
	BEDruidesssRobe() : base() {
		$this.Name               = 'Druidess''s Robe'
		$this.MapObjName         = 'druidesssrobe'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::MagicDefense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made of natural fibers, attuned to nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESorceresssGown : BEArmor {
	BESorceresssGown() : base() {
		$this.Name               = 'Sorceress''s Gown'
		$this.MapObjName         = 'sorceresssgown'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{ [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A darkly elegant gown, enhancing destructive spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorPrincesssCuirass : BEArmor {
	BEWarriorPrincesssCuirass() : base() {
		$this.Name               = 'Warrior Princess''s Cuirass'
		$this.MapObjName         = 'warriorprincessscuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A decorative yet strong cuirass for a royal warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMaidensPlate : BEArmor {
	BEMaidensPlate() : base() {
		$this.Name               = 'Maiden''s Plate'
		$this.MapObjName         = 'maidensplate'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light plate armor designed for female combatants.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpiritWeaversRobe : BEArmor {
	BESpiritWeaversRobe() : base() {
		$this.Name               = 'Spirit Weaver''s Robe'
		$this.MapObjName         = 'spiritweaversrobe'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{ [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe used to commune with spirits, enhancing spiritual magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBattleDress : BEArmor {
	BEBattleDress() : base() {
		$this.Name               = 'Battle Dress'
		$this.MapObjName         = 'battledress'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A functional dress designed for combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESilkBlouse : BEArmor {
	BESilkBlouse() : base() {
		$this.Name               = 'Silk Blouse'
		$this.MapObjName         = 'silkblouse'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fine silk blouse, comfortable but offers no defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEFairyTaleGown : BEArmor {
	BEFairyTaleGown() : base() {
		$this.Name               = 'Fairy Tale Gown'
		$this.MapObjName         = 'fairytalegown'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{ [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A whimsical gown that offers a slight magic boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECelestialDress : BEArmor {
	BECelestialDress() : base() {
		$this.Name               = 'Celestial Dress'
		$this.MapObjName         = 'celestialdress'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dress adorned with celestial patterns, granting minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonlightRobe : BEArmor {
	BEMoonlightRobe() : base() {
		$this.Name               = 'Moonlight Robe'
		$this.MapObjName         = 'moonlightrobe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::MagicDefense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that glows faintly in the dark, enhancing lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESunstoneVest : BEArmor {
	BESunstoneVest() : base() {
		$this.Name               = 'Sunstone Vest'
		$this.MapObjName         = 'sunstonevest'
		$this.PurchasePrice      = 270
		$this.SellPrice          = 135
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with sunstone fragments, offering fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOceanicRobe : BEArmor {
	BEOceanicRobe() : base() {
		$this.Name               = 'Oceanic Robe'
		$this.MapObjName         = 'oceanicrobe'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::MagicDefense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from kelp and enchanted shells, good for water magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGloomVest : BEArmor {
	BEGloomVest() : base() {
		$this.Name               = 'Gloom Vest'
		$this.MapObjName         = 'gloomvest'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark vest that helps the wearer blend into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlazeCuirass : BEArmor {
	BEBlazeCuirass() : base() {
		$this.Name               = 'Blaze Cuirass'
		$this.MapObjName         = 'blazecuirass'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass imbued with fire magic, protecting against heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostChainmail : BEArmor {
	BEFrostChainmail() : base() {
		$this.Name               = 'Frost Chainmail'
		$this.MapObjName         = 'frostchainmail'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Defense = 13; [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail that shimmers with icy energy, resisting cold.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEThunderRobe : BEArmor {
	BEThunderRobe() : base() {
		$this.Name               = 'Thunder Robe'
		$this.MapObjName         = 'thunderrobe'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that crackles with static, enhancing lightning spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEarthPlate : BEArmor {
	BEEarthPlate() : base() {
		$this.Name               = 'Earth Plate'
		$this.MapObjName         = 'earthplate'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plate armor forged from enchanted earth, very sturdy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWindTunic : BEArmor {
	BEWindTunic() : base() {
		$this.Name               = 'Wind Tunic'
		$this.MapObjName         = 'windtunic'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light tunic that makes the wearer feel swifter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoisonVest : BEArmor {
	BEPoisonVest() : base() {
		$this.Name               = 'Poison Vest'
		$this.MapObjName         = 'poisonvest'
		$this.PurchasePrice      = 290
		$this.SellPrice          = 145
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest coated in a subtle, non-toxic venom, useful for rogues.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHolyBreastplate : BEArmor {
	BEHolyBreastplate() : base() {
		$this.Name               = 'Holy Breastplate'
		$this.MapObjName         = 'holybreastplate'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate blessed by the church, resisting dark attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECursedRobe : BEArmor {
	BECursedRobe() : base() {
		$this.Name               = 'Cursed Robe'
		$this.MapObjName         = 'cursedrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A powerful but dangerous robe, drains health but boosts magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDemonicCuirass : BEArmor {
	BEDemonicCuirass() : base() {
		$this.Name               = 'Demonic Cuirass'
		$this.MapObjName         = 'demoniccuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, imposing cuirass said to be forged in hellfire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAngelsRobe : BEArmor {
	BEAngelsRobe() : base() {
		$this.Name               = 'Angel''s Robe'
		$this.MapObjName         = 'angelsrobe'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant robe that offers powerful divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonScalePlate : BEArmor {
	BEDragonScalePlate() : base() {
		$this.Name               = 'Dragon Scale Plate'
		$this.MapObjName         = 'dragonscaleplate'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{ [StatId]::Defense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor crafted from genuine dragon scales, incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalVest : BEArmor {
	BEElementalVest() : base() {
		$this.Name               = 'Elemental Vest'
		$this.MapObjName         = 'elementalvest'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 6; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that shifts color based on the nearest element, offering minor resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClockworkCuirass : BEArmor {
	BEClockworkCuirass() : base() {
		$this.Name               = 'Clockwork Cuirass'
		$this.MapObjName         = 'clockworkcuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made of intricate gears and metal, offers decent defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsRobe : BEArmor {
	BEAlchemistsRobe() : base() {
		$this.Name               = 'Alchemist''s Robe'
		$this.MapObjName         = 'alchemistsrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stained but resilient robe, with many hidden pockets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlagueDoctorsCoat : BEArmor {
	BEPlagueDoctorsCoat() : base() {
		$this.Name               = 'Plague Doctor''s Coat'
		$this.MapObjName         = 'plaguedoctorscoat'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A long, thick coat offering protection against miasma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpectersRobe : BEArmor {
	BESpectersRobe() : base() {
		$this.Name               = 'Specter''s Robe'
		$this.MapObjName         = 'spectersrobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ghostly robe that grants a small chance to evade attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBerserkersHarness : BEArmor {
	BEBerserkersHarness() : base() {
		$this.Name               = 'Berserker''s Harness'
		$this.MapObjName         = 'berserkersharness'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A minimal harness that allows for unrestrained movement and boosts attack.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWardensVest : BEArmor {
	BEWardensVest() : base() {
		$this.Name               = 'Warden''s Vest'
		$this.MapObjName         = 'wardensvest'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust vest for patrolling guards, with good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESirensRobe : BEArmor {
	BESirensRobe() : base() {
		$this.Name               = 'Siren''s Robe'
		$this.MapObjName         = 'sirensrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering robe that enthralls those nearby, enhancing charm magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVampiresCoat : BEArmor {
	BEVampiresCoat() : base() {
		$this.Name               = 'Vampire''s Coat'
		$this.MapObjName         = 'vampirescoat'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant dark coat, said to sustain the wearer''s life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWerewolfHideVest : BEArmor {
	BEWerewolfHideVest() : base() {
		$this.Name               = 'Werewolf Hide Vest'
		$this.MapObjName         = 'werewolfhidevest'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hide of a werewolf, offers minor strength boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemPlate : BEArmor {
	BEGolemPlate() : base() {
		$this.Name               = 'Golem Plate'
		$this.MapObjName         = 'golemplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely heavy and tough plate armor, slows movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicRobe : BEArmor {
	BECosmicRobe() : base() {
		$this.Name               = 'Cosmic Robe'
		$this.MapObjName         = 'cosmicrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe depicting constellations, allowing glimpses of future spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulWeaversRobe : BEArmor {
	BESoulWeaversRobe() : base() {
		$this.Name               = 'Soul Weaver''s Robe'
		$this.MapObjName         = 'soulweaversrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe allowing manipulation of souls, boosts dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidPlate : BEArmor {
	BEVoidPlate() : base() {
		$this.Name               = 'Void Plate'
		$this.MapObjName         = 'voidplate'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{ [StatId]::Defense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor that seems to absorb light, offering ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENovicesTunic : BEArmor {
	BENovicesTunic() : base() {
		$this.Name               = 'Novice''s Tunic'
		$this.MapObjName         = 'novicestunic'
		$this.PurchasePrice      = 45
		$this.SellPrice          = 23
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic worn by those beginning their adventure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOldLeatherArmor : BEArmor {
	BEOldLeatherArmor() : base() {
		$this.Name               = 'Old Leather Armor'
		$this.MapObjName         = 'oldleatherarmor'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn and patched leather armor, still offers some defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERaggedShirt : BEArmor {
	BERaggedShirt() : base() {
		$this.Name               = 'Ragged Shirt'
		$this.MapObjName         = 'raggedshirt'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tattered shirt, barely offering any protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDirtyRobe : BEArmor {
	BEDirtyRobe() : base() {
		$this.Name               = 'Dirty Robe'
		$this.MapObjName         = 'dirtyrobe'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grimy robe, suitable for beggars or desperate mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERustyChainmail : BEArmor {
	BERustyChainmail() : base() {
		$this.Name               = 'Rusty Chainmail'
		$this.MapObjName         = 'rustychainmail'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Old and rusted chainmail, prone to breaking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDentedBreastplate : BEArmor {
	BEDentedBreastplate() : base() {
		$this.Name               = 'Dented Breastplate'
		$this.MapObjName         = 'dentedbreastplate'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate that has seen better days, but still functions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWovenRobe : BEArmor {
	BEWovenRobe() : base() {
		$this.Name               = 'Woven Robe'
		$this.MapObjName         = 'wovenrobe'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::MagicDefense = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple robe made from woven plant fibers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrudeCuirass : BEArmor {
	BECrudeCuirass() : base() {
		$this.Name               = 'Crude Cuirass'
		$this.MapObjName         = 'crudecuirass'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A poorly made cuirass, offers basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGildedChainmail : BEArmor {
	BEGildedChainmail() : base() {
		$this.Name               = 'Gilded Chainmail'
		$this.MapObjName         = 'gildedchainmail'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 8; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail with decorative gold plating, less practical.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrnatePlateArmor : BEArmor {
	BEOrnatePlateArmor() : base() {
		$this.Name               = 'Ornate Plate Armor'
		$this.MapObjName         = 'ornateplatearmor'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Highly decorative plate armor, more for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperRobe : BEArmor {
	BEWhisperRobe() : base() {
		$this.Name               = 'Whisper Robe'
		$this.MapObjName         = 'whisperrobe'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::MagicDefense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes a soft rustling sound, used for quiet movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFleshGolemVest : BEArmor {
	BEFleshGolemVest() : base() {
		$this.Name               = 'Flesh Golem Vest'
		$this.MapObjName         = 'fleshgolemvest'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A repulsive vest made from stitched together flesh, surprisingly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBaronsCuirass : BEArmor {
	BEBaronsCuirass() : base() {
		$this.Name               = 'Baron''s Cuirass'
		$this.MapObjName         = 'baronscuirass'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fancy cuirass, symbolizing minor nobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamweaversRobe : BEArmor {
	BEDreamweaversRobe() : base() {
		$this.Name               = 'Dreamweaver''s Robe'
		$this.MapObjName         = 'dreamweaversrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that helps its wearer control dreams, useful for illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitaniumPlate : BEArmor {
	BETitaniumPlate() : base() {
		$this.Name               = 'Titanium Plate'
		$this.MapObjName         = 'titaniumplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong plate armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESerpenthideRobe : BEArmor {
	BESerpenthideRobe() : base() {
		$this.Name               = 'Serpenthide Robe'
		$this.MapObjName         = 'serpenthiderobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from the scales of a giant serpent, offers resistance to poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmuletVest : BEArmor {
	BEAmuletVest() : base() {
		$this.Name               = 'Amulet Vest'
		$this.MapObjName         = 'amuletvest'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 7; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with various protective amulets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinHideTunic : BEArmor {
	BEGoblinHideTunic() : base() {
		$this.Name               = 'Goblin Hide Tunic'
		$this.MapObjName         = 'goblinhidetunic'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude tunic made from goblin hides, smells faintly of swamp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOgreBoneCuirass : BEArmor {
	BEOgreBoneCuirass() : base() {
		$this.Name               = 'Ogre Bone Cuirass'
		$this.MapObjName         = 'ogrebonecuirass'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy cuirass made from ogre bones, very intimidating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHarpyFeatherRobe : BEArmor {
	BEHarpyFeatherRobe() : base() {
		$this.Name               = 'Harpy Feather Robe'
		$this.MapObjName         = 'harpyfeatherrobe'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::MagicDefense = 24 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light robe adorned with harpy feathers, allows graceful movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEUnicornHornPlate : BEArmor {
	BEUnicornHornPlate() : base() {
		$this.Name               = 'Unicorn Horn Plate'
		$this.MapObjName         = 'unicornhornplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 30; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor inlaid with fragments of unicorn horn, very rare.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChiffonGown : BEArmor {
	BEChiffonGown() : base() {
		$this.Name               = 'Chiffon Gown'
		$this.MapObjName         = 'chiffongown'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate and sheer gown, provides no protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBridalGown : BEArmor {
	BEBridalGown() : base() {
		$this.Name               = 'Bridal Gown'
		$this.MapObjName         = 'bridalgown'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful white gown, worn for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEFortuneTellersRobe : BEArmor {
	BEFortuneTellersRobe() : base() {
		$this.Name               = 'Fortune Teller''s Robe'
		$this.MapObjName         = 'fortunetellersrobe'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::MagicDefense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful robe with mystical symbols, enhances foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBardsVest : BEArmor {
	BEBardsVest() : base() {
		$this.Name               = 'Bard''s Vest'
		$this.MapObjName         = 'bardsvest'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with performances, slight charm boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScholarsGown : BEArmor {
	BEScholarsGown() : base() {
		$this.Name               = 'Scholar''s Gown'
		$this.MapObjName         = 'scholarsgown'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dignified gown for intellectual pursuits, very comfortable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECourtJestersTunic : BEArmor {
	BECourtJestersTunic() : base() {
		$this.Name               = 'Court Jester''s Tunic'
		$this.MapObjName         = 'courtjesterstunic'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brightly colored tunic, offers no protection, purely cosmetic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtisansApron : BEArmor {
	BEArtisansApron() : base() {
		$this.Name               = 'Artisan''s Apron'
		$this.MapObjName         = 'artisansapron'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical apron with many pockets, good for crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinersVest : BEArmor {
	BEMinersVest() : base() {
		$this.Name               = 'Miner''s Vest'
		$this.MapObjName         = 'minersvest'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick vest, offers protection against falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInquisitorsRobe : BEArmor {
	BEInquisitorsRobe() : base() {
		$this.Name               = 'Inquisitor''s Robe'
		$this.MapObjName         = 'inquisitorsrobe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim robe worn by those who seek out evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReapersShroud : BEArmor {
	BEReapersShroud() : base() {
		$this.Name               = 'Reaper''s Shroud'
		$this.MapObjName         = 'reapersshroud'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, flowing shroud that seems to absorb light, feared by many.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBarbariansFurVest : BEArmor {
	BEBarbariansFurVest() : base() {
		$this.Name               = 'Barbarian''s Fur Vest'
		$this.MapObjName         = 'barbariansfurvest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged vest made of thick fur, offers warmth and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENomadsTunic : BEArmor {
	BENomadsTunic() : base() {
		$this.Name               = 'Nomad''s Tunic'
		$this.MapObjName         = 'nomadstunic'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable tunic for desert wanderers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrVest : BEArmor {
	BEZephyrVest() : base() {
		$this.Name               = 'Zephyr Vest'
		$this.MapObjName         = 'zephyrvest'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light vest that makes the wearer feel faster.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneBreastplate : BEArmor {
	BEStoneBreastplate() : base() {
		$this.Name               = 'Stone Breastplate'
		$this.MapObjName         = 'stonebreastplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy breastplate carved from a single piece of stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENetherRobe : BEArmor {
	BENetherRobe() : base() {
		$this.Name               = 'Nether Robe'
		$this.MapObjName         = 'netherrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe from the underworld, radiating ominous energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyrmscaleVest : BEArmor {
	BEWyrmscaleVest() : base() {
		$this.Name               = 'Wyrmscale Vest'
		$this.MapObjName         = 'wyrmscalevest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the scales of a smaller wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonRobe : BEArmor {
	BECrimsonRobe() : base() {
		$this.Name               = 'Crimson Robe'
		$this.MapObjName         = 'crimsonrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vivid red robe, associated with powerful fire mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilverPlateArmor : BEArmor {
	BESilverPlateArmor() : base() {
		$this.Name               = 'Silver Plate Armor'
		$this.MapObjName         = 'silverplatearmor'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor forged from pure silver, shines brightly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunesmithsRobe : BEArmor {
	BERunesmithsRobe() : base() {
		$this.Name               = 'Runesmith''s Robe'
		$this.MapObjName         = 'runesmithsrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy robe adorned with glowing runes, enhances enchanting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChitinCuirass : BEArmor {
	BEChitinCuirass() : base() {
		$this.Name               = 'Chitin Cuirass'
		$this.MapObjName         = 'chitincuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from the hard exoskeleton of a giant insect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemHeartBreastplate : BEArmor {
	BEGolemHeartBreastplate() : base() {
		$this.Name               = 'Golem Heart Breastplate'
		$this.MapObjName         = 'golemheartbreastplate'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{ [StatId]::Defense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate embedded with the pulsating core of a golem.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallRobe : BEArmor {
	BEStarfallRobe() : base() {
		$this.Name               = 'Starfall Robe'
		$this.MapObjName         = 'starfallrobe'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::MagicDefense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be woven from threads of falling stars, grants incredible power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealVest : BEArmor {
	BEEtherealVest() : base() {
		$this.Name               = 'Ethereal Vest'
		$this.MapObjName         = 'etherealvest'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A semi-transparent vest that seems to flicker in and out of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpecterVest : BEArmor {
	BESpecterVest() : base() {
		$this.Name               = 'Specter Vest'
		$this.MapObjName         = 'spectervest'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 3; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that offers slight resistance to spiritual attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShamansRobe : BEArmor {
	BEShamansRobe() : base() {
		$this.Name               = 'Shaman''s Robe'
		$this.MapObjName         = 'shamansrobe'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial robe adorned with totems and charms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECultistsRobe : BEArmor {
	BECultistsRobe() : base() {
		$this.Name               = 'Cultist''s Robe'
		$this.MapObjName         = 'cultistsrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark and ominous robe, often worn by followers of dark deities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExecutionersPlate : BEArmor {
	BEExecutionersPlate() : base() {
		$this.Name               = 'Executioner''s Plate'
		$this.MapObjName         = 'executionersplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and dark plate armor, designed for maximum intimidation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodRobe : BEArmor {
	BEBloodRobe() : base() {
		$this.Name               = 'Blood Robe'
		$this.MapObjName         = 'bloodrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 5; [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe stained with ancient blood, granting power through sacrifice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonKingsCuirass : BEArmor {
	BEDragonKingsCuirass() : base() {
		$this.Name               = 'Dragon King''s Cuirass'
		$this.MapObjName         = 'dragonkingscuirass'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{ [StatId]::Defense = 40; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The legendary cuirass of a dragon ruler, immensely powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineRobe : BEArmor {
	BEDivineRobe() : base() {
		$this.Name               = 'Divine Robe'
		$this.MapObjName         = 'divinerobe'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::MagicDefense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe of unparalleled purity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlordsPlate : BEArmor {
	BEWarlordsPlate() : base() {
		$this.Name               = 'Warlord''s Plate'
		$this.MapObjName         = 'warlordsplate'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{ [StatId]::Defense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The battle-hardened plate armor of a seasoned warlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMistRobe : BEArmor {
	BEMistRobe() : base() {
		$this.Name               = 'Mist Robe'
		$this.MapObjName         = 'mistrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to shimmer like mist, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneSkinVest : BEArmor {
	BEStoneSkinVest() : base() {
		$this.Name               = 'Stone Skin Vest'
		$this.MapObjName         = 'stoneskinvest'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that makes the wearer''s skin as hard as stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnigmaRobe : BEArmor {
	BEEnigmaRobe() : base() {
		$this.Name               = 'Enigma Robe'
		$this.MapObjName         = 'enigmarobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::MagicDefense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that constantly changes its magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChampionsBreastplate : BEArmor {
	BEChampionsBreastplate() : base() {
		$this.Name               = 'Champion''s Breastplate'
		$this.MapObjName         = 'championsbreastplate'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The shining breastplate of a revered champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcerersTunic : BEArmor {
	BESorcerersTunic() : base() {
		$this.Name               = 'Sorcerer''s Tunic'
		$this.MapObjName         = 'sorcererstunic'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{ [StatId]::MagicDefense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic, often worn under a robe, with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdventurersJacket : BEArmor {
	BEAdventurersJacket() : base() {
		$this.Name               = 'Adventurer''s Jacket'
		$this.MapObjName         = 'adventurersjacket'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A versatile jacket with many pockets, good for general exploration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHermitsRobe : BEArmor {
	BEHermitsRobe() : base() {
		$this.Name               = 'Hermit''s Robe'
		$this.MapObjName         = 'hermitsrobe'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain, patched robe, worn by reclusive wise individuals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGuardsUniform : BEArmor {
	BEGuardsUniform() : base() {
		$this.Name               = 'Guard''s Uniform'
		$this.MapObjName         = 'guardsuniform'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The standard uniform of a town guard, offers moderate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExecutionersVest : BEArmor {
	BEExecutionersVest() : base() {
		$this.Name               = 'Executioner''s Vest'
		$this.MapObjName         = 'executionersvest'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy, dark vest worn by those carrying out justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancersRobe : BEArmor {
	BENecromancersRobe() : base() {
		$this.Name               = 'Necromancer''s Robe'
		$this.MapObjName         = 'necromancersrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling robe that pulses with unholy energy, enhancing dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlessedChainmail : BEArmor {
	BEBlessedChainmail() : base() {
		$this.Name               = 'Blessed Chainmail'
		$this.MapObjName         = 'blessedchainmail'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 11; [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail consecrated by holy rites, effective against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianCuirass : BEArmor {
	BEObsidianCuirass() : base() {
		$this.Name               = 'Obsidian Cuirass'
		$this.MapObjName         = 'obsidiancuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass carved from pure obsidian, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenRobe : BEArmor {
	BESunkenRobe() : base() {
		$this.Name               = 'Sunken Robe'
		$this.MapObjName         = 'sunkenrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe recovered from deep sea ruins, still damp but enchanted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansPlate : BEArmor {
	BETitansPlate() : base() {
		$this.Name               = 'Titan''s Plate'
		$this.MapObjName         = 'titansplate'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{ [StatId]::Defense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor said to be forged by ancient titans, immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmberRobe : BEArmor {
	BEEmberRobe() : base() {
		$this.Name               = 'Ember Robe'
		$this.MapObjName         = 'emberrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that radiates a faint warmth, hinting at fire magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalCuirass : BEArmor {
	BECrystalCuirass() : base() {
		$this.Name               = 'Crystal Cuirass'
		$this.MapObjName         = 'crystalcuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened magical crystals, somewhat fragile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVindicatorsPlate : BEArmor {
	BEVindicatorsPlate() : base() {
		$this.Name               = 'Vindicator''s Plate'
		$this.MapObjName         = 'vindicatorsplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor worn by those who seek justice, glows faintly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhantomRobe : BEArmor {
	BEPhantomRobe() : base() {
		$this.Name               = 'Phantom Robe'
		$this.MapObjName         = 'phantomrobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes the wearer partially incorporeal, enhancing evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulboundVest : BEArmor {
	BESoulboundVest() : base() {
		$this.Name               = 'Soulbound Vest'
		$this.MapObjName         = 'soulboundvest'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 8; [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that has formed a mystical link with its wearer, gaining power over time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialRobe : BEArmor {
	BEGlacialRobe() : base() {
		$this.Name               = 'Glacial Robe'
		$this.MapObjName         = 'glacialrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe radiating intense cold, perfect for ice mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonSlayersPlate : BEArmor {
	BEDragonSlayersPlate() : base() {
		$this.Name               = 'Dragon Slayer''s Plate'
		$this.MapObjName         = 'dragonslayersplate'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{ [StatId]::Defense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor designed specifically to combat dragons, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMonksGi : BEArmor {
	BEMonksGi() : base() {
		$this.Name               = 'Monk''s Gi'
		$this.MapObjName         = 'monksgi'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, loose-fitting martial arts uniform.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelersCloak : BEArmor {
	BETravelersCloak() : base() {
		$this.Name               = 'Traveler''s Cloak'
		$this.MapObjName         = 'travelerscloak'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A multi-purpose cloak that can be worn like a tunic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHerbalistsTunic : BEArmor {
	BEHerbalistsTunic() : base() {
		$this.Name               = 'Herbalist''s Tunic'
		$this.MapObjName         = 'herbaliststunic'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic with many pockets for herbs, slightly protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEngineersVest : BEArmor {
	BEEngineersVest() : base() {
		$this.Name               = 'Engineer''s Vest'
		$this.MapObjName         = 'engineersvest'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with various tools and pockets, offers minor defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlitteringRobe : BEArmor {
	BEGlitteringRobe() : base() {
		$this.Name               = 'Glittering Robe'
		$this.MapObjName         = 'glitteringrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with fine silver threads, sparkles in the light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESwashbucklersVest : BEArmor {
	BESwashbucklersVest() : base() {
		$this.Name               = 'Swashbuckler''s Vest'
		$this.MapObjName         = 'swashbucklersvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with agility and charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBeastmastersTunic : BEArmor {
	BEBeastmastersTunic() : base() {
		$this.Name               = 'Beastmaster''s Tunic'
		$this.MapObjName         = 'beastmasterstunic'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from tough animal hides, enhances communication with beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBardsTunic : BEArmor {
	BEBardsTunic() : base() {
		$this.Name               = 'Bard''s Tunic'
		$this.MapObjName         = 'bardstunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable and stylish tunic for performers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGloomRobe : BEArmor {
	BEGloomRobe() : base() {
		$this.Name               = 'Gloom Robe'
		$this.MapObjName         = 'gloomrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, plain robe for those who prefer to remain unnoticed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStonehideVest : BEArmor {
	BEStonehideVest() : base() {
		$this.Name               = 'Stonehide Vest'
		$this.MapObjName         = 'stonehidevest'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that feels as tough as stone, surprisingly flexible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECoralCuirass : BEArmor {
	BECoralCuirass() : base() {
		$this.Name               = 'Coral Cuirass'
		$this.MapObjName         = 'coralcuirass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 15; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened coral, offers water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarSapphireRobe : BEArmor {
	BEStarSapphireRobe() : base() {
		$this.Name               = 'Star Sapphire Robe'
		$this.MapObjName         = 'starsapphirerobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep blue robe embedded with star sapphires, very potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEValiantCuirass : BEArmor {
	BEValiantCuirass() : base() {
		$this.Name               = 'Valiant Cuirass'
		$this.MapObjName         = 'valiantcuirass'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shining cuirass worn by courageous warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlocksRobe : BEArmor {
	BEWarlocksRobe() : base() {
		$this.Name               = 'Warlock''s Robe'
		$this.MapObjName         = 'warlocksrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, ominous robe, often associated with forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinFeatherVest : BEArmor {
	BEGriffinFeatherVest() : base() {
		$this.Name               = 'Griffin Feather Vest'
		$this.MapObjName         = 'griffinfeathervest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the feathers of a griffin, allows for light fall.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostfireRobe : BEArmor {
	BEFrostfireRobe() : base() {
		$this.Name               = 'Frostfire Robe'
		$this.MapObjName         = 'frostfirerobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers with both ice and fire, very volatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternalPlate : BEArmor {
	BEEternalPlate() : base() {
		$this.Name               = 'Eternal Plate'
		$this.MapObjName         = 'eternalplate'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Defense = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor said to be from another dimension, unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonChainmail : BEArmor {
	BECrimsonChainmail() : base() {
		$this.Name               = 'Crimson Chainmail'
		$this.MapObjName         = 'crimsonchainmail'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail dyed crimson, favored by elite guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAzureRobe : BEArmor {
	BEAzureRobe() : base() {
		$this.Name               = 'Azure Robe'
		$this.MapObjName         = 'azurerobe'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{ [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brilliant blue robe, often worn by powerful water mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestDwellersTunic : BEArmor {
	BEForestDwellersTunic() : base() {
		$this.Name               = 'Forest Dweller''s Tunic'
		$this.MapObjName         = 'forestdwellerstunic'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A green tunic that blends in with natural environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoachersVest : BEArmor {
	BEPoachersVest() : base() {
		$this.Name               = 'Poacher''s Vest'
		$this.MapObjName         = 'poachersvest'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stealthy vest with many hidden compartments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialBreastplate : BEArmor {
	BEGlacialBreastplate() : base() {
		$this.Name               = 'Glacial Breastplate'
		$this.MapObjName         = 'glacialbreastplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate emanating a freezing aura, good against fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanicRobe : BEArmor {
	BEVolcanicRobe() : base() {
		$this.Name               = 'Volcanic Robe'
		$this.MapObjName         = 'volcanicrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from cooled lava, resisting extreme heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPlate : BEArmor {
	BEAbyssalPlate() : base() {
		$this.Name               = 'Abyssal Plate'
		$this.MapObjName         = 'abyssalplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor from the deepest parts of the ocean, incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESkyforgedCuirass : BEArmor {
	BESkyforgedCuirass() : base() {
		$this.Name               = 'Skyforged Cuirass'
		$this.MapObjName         = 'skyforgedcuirass'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass said to be hammered from clouds, very light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenTreasureRobe : BEArmor {
	BESunkenTreasureRobe() : base() {
		$this.Name               = 'Sunken Treasure Robe'
		$this.MapObjName         = 'sunkentreasurerobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe encrusted with pearls and gems from sunken ships, carries a sea enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOnyxPlate : BEArmor {
	BEOnyxPlate() : base() {
		$this.Name               = 'Onyx Plate'
		$this.MapObjName         = 'onyxplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from polished black onyx, very heavy and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilver-ThreadedRobe : BEArmor {
	BESilver-ThreadedRobe() : base() {
		$this.Name               = 'Silver-Threaded Robe'
		$this.MapObjName         = 'silver-threadedrobe'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe intricately woven with silver threads, enhances defense against dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronboundVest : BEArmor {
	BEIronboundVest() : base() {
		$this.Name               = 'Ironbound Vest'
		$this.MapObjName         = 'ironboundvest'
		$this.PurchasePrice      = 310
		$this.SellPrice          = 155
		$this.TargetStats        = @{ [StatId]::Defense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with iron plates sewn into the fabric for added protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindTunic : BEArmor {
	BEWhisperwindTunic() : base() {
		$this.Name               = 'Whisperwind Tunic'
		$this.MapObjName         = 'whisperwindtunic'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight tunic that barely rustles, ideal for stealth and speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESolarCuirass : BEArmor {
	BESolarCuirass() : base() {
		$this.Name               = 'Solar Cuirass'
		$this.MapObjName         = 'solarcuirass'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{ [StatId]::Defense = 17; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that radiates a gentle warmth, offering minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneRobe : BEArmor {
	BEMoonstoneRobe() : base() {
		$this.Name               = 'Moonstone Robe'
		$this.MapObjName         = 'moonstonerobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe adorned with glowing moonstones, boosting lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGargoylePlate : BEArmor {
	BEGargoylePlate() : base() {
		$this.Name               = 'Gargoyle Plate'
		$this.MapObjName         = 'gargoyleplate'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, grotesque plate armor carved to resemble a gargoyle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritwalkersVest : BEArmor {
	BESpiritwalkersVest() : base() {
		$this.Name               = 'Spiritwalker''s Vest'
		$this.MapObjName         = 'spiritwalkersvest'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Defense = 9; [StatId]::MagicDefense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that aids in traversing spiritual realms, light but protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneWeaveRobe : BEArmor {
	BEArcaneWeaveRobe() : base() {
		$this.Name               = 'Arcane Weave Robe'
		$this.MapObjName         = 'arcaneweaverobe'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with pure arcane energy, granting significant magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlackenedSteelCuirass : BEArmor {
	BEBlackenedSteelCuirass() : base() {
		$this.Name               = 'Blackened Steel Cuirass'
		$this.MapObjName         = 'blackenedsteelcuirass'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Defense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Steel cuirass treated to a dark, menacing finish.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFey-TouchedTunic : BEArmor {
	BEFey-TouchedTunic() : base() {
		$this.Name               = 'Fey-Touched Tunic'
		$this.MapObjName         = 'fey-touchedtunic'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{ [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic seemingly woven from forest leaves, offering minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadow-StitchedVest : BEArmor {
	BEShadow-StitchedVest() : base() {
		$this.Name               = 'Shadow-Stitched Vest'
		$this.MapObjName         = 'shadow-stitchedvest'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest sewn with threads of shadow, enhancing stealth and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineAegisBreastplate : BEArmor {
	BEDivineAegisBreastplate() : base() {
		$this.Name               = 'Divine Aegis Breastplate'
		$this.MapObjName         = 'divineaegisbreastplate'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate radiating holy light, offering strong defense against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalMastersRobe : BEArmor {
	BEElementalMastersRobe() : base() {
		$this.Name               = 'Elemental Master''s Robe'
		$this.MapObjName         = 'elementalmastersrobe'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 5; [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with the essence of all four elements, highly versatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomhideCuirass : BEArmor {
	BEVenomhideCuirass() : base() {
		$this.Name               = 'Venomhide Cuirass'
		$this.MapObjName         = 'venomhidecuirass'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from poisonous beast hide, offering minor toxin resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralSilkRobe : BEArmor {
	BEAstralSilkRobe() : base() {
		$this.Name               = 'Astral Silk Robe'
		$this.MapObjName         = 'astralsilkrobe'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from ethereal silk, allowing slight glimpses into other dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrystalineBreastplate : BEArmor {
	BECrystalineBreastplate() : base() {
		$this.Name               = 'Crystaline Breastplate'
		$this.MapObjName         = 'crystalinebreastplate'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{ [StatId]::Defense = 27; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate forged from compressed magical crystals, very durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChronosRobe : BEArmor {
	BEChronosRobe() : base() {
		$this.Name               = 'Chronos Robe'
		$this.MapObjName         = 'chronosrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to slightly bend time around the wearer, boosting speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalChainmail : BEArmor {
	BEAbyssalChainmail() : base() {
		$this.Name               = 'Abyssal Chainmail'
		$this.MapObjName         = 'abyssalchainmail'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail found in the deepest parts of the ocean, resistant to pressure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertWanderersRobe : BEArmor {
	BEDesertWanderersRobe() : base() {
		$this.Name               = 'Desert Wanderer''s Robe'
		$this.MapObjName         = 'desertwanderersrobe'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{ [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, breathable robe ideal for hot climates, offers minor sun protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneGuardTunic : BEArmor {
	BEStoneGuardTunic() : base() {
		$this.Name               = 'Stone Guard Tunic'
		$this.MapObjName         = 'stoneguardtunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic reinforced with small stone plates for basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPilgrimsVest : BEArmor {
	BEPilgrimsVest() : base() {
		$this.Name               = 'Pilgrim''s Vest'
		$this.MapObjName         = 'pilgrimsvest'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable vest for long journeys of faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsApron : BEArmor {
	BEAlchemistsApron() : base() {
		$this.Name               = 'Alchemist''s Apron'
		$this.MapObjName         = 'alchemistsapron'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy apron with many pockets, useful for potion crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamersRobe : BEArmor {
	BEDreamersRobe() : base() {
		$this.Name               = 'Dreamer''s Robe'
		$this.MapObjName         = 'dreamersrobe'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::MagicDefense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A soft robe that aids in lucid dreaming, enhancing magical recovery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERiverstoneVest : BEArmor {
	BERiverstoneVest() : base() {
		$this.Name               = 'Riverstone Vest'
		$this.MapObjName         = 'riverstonevest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with smooth river stones, offering minor water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostweaveRobe : BEArmor {
	BEFrostweaveRobe() : base() {
		$this.Name               = 'Frostweave Robe'
		$this.MapObjName         = 'frostweaverobe'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{ [StatId]::MagicDefense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from icy fibers, providing cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlimmeringChainmail : BEArmor {
	BEGlimmeringChainmail() : base() {
		$this.Name               = 'Glimmering Chainmail'
		$this.MapObjName         = 'glimmeringchainmail'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 12; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail that catches the light and subtly disorients foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernBoneCuirass : BEArmor {
	BEWyvernBoneCuirass() : base() {
		$this.Name               = 'Wyvern Bone Cuirass'
		$this.MapObjName         = 'wyvernbonecuirass'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass crafted from the bones of a wyvern, lightweight yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialMessengersRobe : BEArmor {
	BECelestialMessengersRobe() : base() {
		$this.Name               = 'Celestial Messenger''s Robe'
		$this.MapObjName         = 'celestialmessengersrobe'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be worn by celestial beings, granting wisdom and foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemPlating : BEArmor {
	BEGolemPlating() : base() {
		$this.Name               = 'Golem Plating'
		$this.MapObjName         = 'golemplating'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{ [StatId]::Defense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sections of golem plating fashioned into a heavy torso armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulfireRobe : BEArmor {
	BESoulfireRobe() : base() {
		$this.Name               = 'Soulfire Robe'
		$this.MapObjName         = 'soulfirerobe'
		$this.PurchasePrice      = 1950
		$this.SellPrice          = 975
		$this.TargetStats        = @{ [StatId]::MagicDefense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with captured souls, radiating dark energy and boosting spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianGuardVest : BEArmor {
	BEObsidianGuardVest() : base() {
		$this.Name               = 'Obsidian Guard Vest'
		$this.MapObjName         = 'obsidianguardvest'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{ [StatId]::Defense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest reinforced with shards of obsidian, offering sharp defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmeraldRobe : BEArmor {
	BEEmeraldRobe() : base() {
		$this.Name               = 'Emerald Robe'
		$this.MapObjName         = 'emeraldrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant green robe adorned with emeralds, enhancing nature magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunicBreastplate : BEArmor {
	BERunicBreastplate() : base() {
		$this.Name               = 'Runic Breastplate'
		$this.MapObjName         = 'runicbreastplate'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate etched with protective runes, offering strong magical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStardustRobe : BEArmor {
	BEStardustRobe() : base() {
		$this.Name               = 'Stardust Robe'
		$this.MapObjName         = 'stardustrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers like scattered stardust, boosting cosmic magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVikingChainmail : BEArmor {
	BEVikingChainmail() : base() {
		$this.Name               = 'Viking Chainmail'
		$this.MapObjName         = 'vikingchainmail'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, sturdy chainmail favored by northern warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreadKnightsCuirass : BEArmor {
	BEDreadKnightsCuirass() : base() {
		$this.Name               = 'Dread Knight''s Cuirass'
		$this.MapObjName         = 'dreadknightscuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying black cuirass, instilling fear in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherRobe : BEArmor {
	BEAetherRobe() : base() {
		$this.Name               = 'Aether Robe'
		$this.MapObjName         = 'aetherrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent robe that seems to shift with air currents, very light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChimeraHideVest : BEArmor {
	BEChimeraHideVest() : base() {
		$this.Name               = 'Chimera Hide Vest'
		$this.MapObjName         = 'chimerahidevest'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hides of various monstrous creatures, granting varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampiricRobe : BEArmor {
	BEVampiricRobe() : base() {
		$this.Name               = 'Vampiric Robe'
		$this.MapObjName         = 'vampiricrobe'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{ [StatId]::Defense = 3; [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly drains life from enemies during combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormforgedPlate : BEArmor {
	BEStormforgedPlate() : base() {
		$this.Name               = 'Stormforged Plate'
		$this.MapObjName         = 'stormforgedplate'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{ [StatId]::Defense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor that hums with static electricity, resisting lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEchoingRobe : BEArmor {
	BEEchoingRobe() : base() {
		$this.Name               = 'Echoing Robe'
		$this.MapObjName         = 'echoingrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that amplifies spells, but leaves residual magical echoes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansLegacyBreastplate : BEArmor {
	BETitansLegacyBreastplate() : base() {
		$this.Name               = 'Titan''s Legacy Breastplate'
		$this.MapObjName         = 'titanslegacybreastplate'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{ [StatId]::Defense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate said to be a fragment of a titan''s armor, immense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamcatcherVest : BEArmor {
	BEDreamcatcherVest() : base() {
		$this.Name               = 'Dreamcatcher Vest'
		$this.MapObjName         = 'dreamcatchervest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest woven with mystical strands, protecting against magical sleep.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenPlate : BEArmor {
	BESunkenPlate() : base() {
		$this.Name               = 'Sunken Plate'
		$this.MapObjName         = 'sunkenplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plate armor encrusted with barnacles, very resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonWitchsGown : BEArmor {
	BECrimsonWitchsGown() : base() {
		$this.Name               = 'Crimson Witch''s Gown'
		$this.MapObjName         = 'crimsonwitchsgown'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep crimson gown, enhancing dark and fire-based magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERoseSilkRobe : BEArmor {
	BERoseSilkRobe() : base() {
		$this.Name               = 'Rose Silk Robe'
		$this.MapObjName         = 'rosesilkrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate pink silk robe, often worn by charming mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMaidensChainmail : BEArmor {
	BEMaidensChainmail() : base() {
		$this.Name               = 'Maiden''s Chainmail'
		$this.MapObjName         = 'maidenschainmail'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lighter, more flexible chainmail designed for female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEnchantedCorset : BEArmor {
	BEEnchantedCorset() : base() {
		$this.Name               = 'Enchanted Corset'
		$this.MapObjName         = 'enchantedcorset'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 2; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reinforced corset imbued with minor protective enchantments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGoddesssGown : BEArmor {
	BEGoddesssGown() : base() {
		$this.Name               = 'Goddess''s Gown'
		$this.MapObjName         = 'goddesssgown'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant gown said to be blessed by a deity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVixensVest : BEArmor {
	BEVixensVest() : base() {
		$this.Name               = 'Vixen''s Vest'
		$this.MapObjName         = 'vixensvest'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sleek, dark vest, often worn by agile and cunning female rogues.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEmpresssRobe : BEArmor {
	BEEmpresssRobe() : base() {
		$this.Name               = 'Empress''s Robe'
		$this.MapObjName         = 'empresssrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A regal robe, richly embroidered and imbued with subtle power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonlitDress : BEArmor {
	BEMoonlitDress() : base() {
		$this.Name               = 'Moonlit Dress'
		$this.MapObjName         = 'moonlitdress'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flowing dress that glows softly in the moonlight, enhancing illusion magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDiamondCuirass : BEArmor {
	BEDiamondCuirass() : base() {
		$this.Name               = 'Diamond Cuirass'
		$this.MapObjName         = 'diamondcuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sparkling cuirass inlaid with diamonds, very durable and beautiful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEForestNymphsTunic : BEArmor {
	BEForestNymphsTunic() : base() {
		$this.Name               = 'Forest Nymph''s Tunic'
		$this.MapObjName         = 'forestnymphstunic'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from living leaves and moss, blending with nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBattleMaidensPlate : BEArmor {
	BEBattleMaidensPlate() : base() {
		$this.Name               = 'Battle Maiden''s Plate'
		$this.MapObjName         = 'battlemaidensplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy plate armor designed for female warriors, allowing flexibility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEQueenofThornsRobe : BEArmor {
	BEQueenofThornsRobe() : base() {
		$this.Name               = 'Queen of Thorns Robe'
		$this.MapObjName         = 'queenofthornsrobe'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{ [StatId]::Defense = 2; [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, thorny robe, providing protection and minor offensive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpiritDancersBlouse : BEArmor {
	BESpiritDancersBlouse() : base() {
		$this.Name               = 'Spirit Dancer''s Blouse'
		$this.MapObjName         = 'spiritdancersblouse'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light blouse that enhances agility and spiritual connection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrimsonCourtGown : BEArmor {
	BECrimsonCourtGown() : base() {
		$this.Name               = 'Crimson Court Gown'
		$this.MapObjName         = 'crimsoncourtgown'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luxurious crimson gown, granting slight magical allure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEShadowHuntresssVest : BEArmor {
	BEShadowHuntresssVest() : base() {
		$this.Name               = 'Shadow Huntress''s Vest'
		$this.MapObjName         = 'shadowhuntresssvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark vest optimized for stealth and ranged attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECelestialSorceressGown : BEArmor {
	BECelestialSorceressGown() : base() {
		$this.Name               = 'Celestial Sorceress Gown'
		$this.MapObjName         = 'celestialsorceressgown'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 44 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent gown adorned with celestial patterns, immensely powerful for magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDesertRoseDress : BEArmor {
	BEDesertRoseDress() : base() {
		$this.Name               = 'Desert Rose Dress'
		$this.MapObjName         = 'desertrosedress'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, airy dress, comfortable in hot climates, with minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWinterMaidensRobe : BEArmor {
	BEWinterMaidensRobe() : base() {
		$this.Name               = 'Winter Maiden''s Robe'
		$this.MapObjName         = 'wintermaidensrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that emanates a chilling aura, providing strong cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorQueensBreastplate : BEArmor {
	BEWarriorQueensBreastplate() : base() {
		$this.Name               = 'Warrior Queen''s Breastplate'
		$this.MapObjName         = 'warriorqueensbreastplate'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome breastplate worn by a powerful female leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGothicVest : BEArmor {
	BEGothicVest() : base() {
		$this.Name               = 'Gothic Vest'
		$this.MapObjName         = 'gothicvest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{ [StatId]::Defense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, layered vest with ornate buckles, offers good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBonePlate : BEArmor {
	BEBonePlate() : base() {
		$this.Name               = 'Bone Plate'
		$this.MapObjName         = 'boneplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from hardened bones, eerie but effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDeepSeaRobe : BEArmor {
	BEDeepSeaRobe() : base() {
		$this.Name               = 'Deep Sea Robe'
		$this.MapObjName         = 'deepsearobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from rare deep-sea fibers, offers strong water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolatileVest : BEArmor {
	BEVolatileVest() : base() {
		$this.Name               = 'Volatile Vest'
		$this.MapObjName         = 'volatilevest'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{ [StatId]::Defense = 7; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that sometimes explodes with magical energy, risky but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEldritchRobe : BEArmor {
	BEEldritchRobe() : base() {
		$this.Name               = 'Eldritch Robe'
		$this.MapObjName         = 'eldritchrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly shifts patterns, enhancing forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidWeaversCuirass : BEArmor {
	BEVoidWeaversCuirass() : base() {
		$this.Name               = 'Void Weaver''s Cuirass'
		$this.MapObjName         = 'voidweaverscuirass'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that seems to absorb all light, making the wearer harder to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemPlate : BEArmor {
	BEGolemPlate() : base() {
		$this.Name               = 'Golem Plate'
		$this.MapObjName         = 'golemplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely heavy and tough plate armor, slows movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicRobe : BEArmor {
	BECosmicRobe() : base() {
		$this.Name               = 'Cosmic Robe'
		$this.MapObjName         = 'cosmicrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe depicting constellations, allowing glimpses of future spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulWeaversRobe : BEArmor {
	BESoulWeaversRobe() : base() {
		$this.Name               = 'Soul Weaver''s Robe'
		$this.MapObjName         = 'soulweaversrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe allowing manipulation of souls, boosts dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidPlate : BEArmor {
	BEVoidPlate() : base() {
		$this.Name               = 'Void Plate'
		$this.MapObjName         = 'voidplate'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{ [StatId]::Defense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor that seems to absorb light, offering ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenRobe : BEArmor {
	BESunkenRobe() : base() {
		$this.Name               = 'Sunken Robe'
		$this.MapObjName         = 'sunkenrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe recovered from deep sea ruins, still damp but enchanted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalVest : BEArmor {
	BEElementalVest() : base() {
		$this.Name               = 'Elemental Vest'
		$this.MapObjName         = 'elementalvest'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 6; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that shifts color based on the nearest element, offering minor resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClockworkCuirass : BEArmor {
	BEClockworkCuirass() : base() {
		$this.Name               = 'Clockwork Cuirass'
		$this.MapObjName         = 'clockworkcuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made of intricate gears and metal, offers decent defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsRobe : BEArmor {
	BEAlchemistsRobe() : base() {
		$this.Name               = 'Alchemist''s Robe'
		$this.MapObjName         = 'alchemistsrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stained but resilient robe, with many hidden pockets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPlagueDoctorsCoat : BEArmor {
	BEPlagueDoctorsCoat() : base() {
		$this.Name               = 'Plague Doctor''s Coat'
		$this.MapObjName         = 'plaguedoctorscoat'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A long, thick coat offering protection against miasma.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpectersRobe : BEArmor {
	BESpectersRobe() : base() {
		$this.Name               = 'Specter''s Robe'
		$this.MapObjName         = 'spectersrobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ghostly robe that grants a small chance to evade attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBerserkersHarness : BEArmor {
	BEBerserkersHarness() : base() {
		$this.Name               = 'Berserker''s Harness'
		$this.MapObjName         = 'berserkersharness'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A minimal harness that allows for unrestrained movement and boosts attack.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWardensVest : BEArmor {
	BEWardensVest() : base() {
		$this.Name               = 'Warden''s Vest'
		$this.MapObjName         = 'wardensvest'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust vest for patrolling guards, with good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESirensRobe : BEArmor {
	BESirensRobe() : base() {
		$this.Name               = 'Siren''s Robe'
		$this.MapObjName         = 'sirensrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering robe that enthralls those nearby, enhancing charm magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVampiresCoat : BEArmor {
	BEVampiresCoat() : base() {
		$this.Name               = 'Vampire''s Coat'
		$this.MapObjName         = 'vampirescoat'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant dark coat, said to sustain the wearer''s life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWerewolfHideVest : BEArmor {
	BEWerewolfHideVest() : base() {
		$this.Name               = 'Werewolf Hide Vest'
		$this.MapObjName         = 'werewolfhidevest'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hide of a werewolf, offers minor strength boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemPlate : BEArmor {
	BEGolemPlate() : base() {
		$this.Name               = 'Golem Plate'
		$this.MapObjName         = 'golemplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Extremely heavy and tough plate armor, slows movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECosmicRobe : BEArmor {
	BECosmicRobe() : base() {
		$this.Name               = 'Cosmic Robe'
		$this.MapObjName         = 'cosmicrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe depicting constellations, allowing glimpses of future spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulWeaversRobe : BEArmor {
	BESoulWeaversRobe() : base() {
		$this.Name               = 'Soul Weaver''s Robe'
		$this.MapObjName         = 'soulweaversrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe allowing manipulation of souls, boosts dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidPlate : BEArmor {
	BEVoidPlate() : base() {
		$this.Name               = 'Void Plate'
		$this.MapObjName         = 'voidplate'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{ [StatId]::Defense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor that seems to absorb light, offering ultimate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENovicesTunic : BEArmor {
	BENovicesTunic() : base() {
		$this.Name               = 'Novice''s Tunic'
		$this.MapObjName         = 'novicestunic'
		$this.PurchasePrice      = 45
		$this.SellPrice          = 23
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic worn by those beginning their adventure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOldLeatherArmor : BEArmor {
	BEOldLeatherArmor() : base() {
		$this.Name               = 'Old Leather Armor'
		$this.MapObjName         = 'oldleatherarmor'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn and patched leather armor, still offers some defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERaggedShirt : BEArmor {
	BERaggedShirt() : base() {
		$this.Name               = 'Ragged Shirt'
		$this.MapObjName         = 'raggedshirt'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tattered shirt, barely offering any protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDirtyRobe : BEArmor {
	BEDirtyRobe() : base() {
		$this.Name               = 'Dirty Robe'
		$this.MapObjName         = 'dirtyrobe'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grimy robe, suitable for beggars or desperate mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERustyChainmail : BEArmor {
	BERustyChainmail() : base() {
		$this.Name               = 'Rusty Chainmail'
		$this.MapObjName         = 'rustychainmail'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Old and rusted chainmail, prone to breaking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDentedBreastplate : BEArmor {
	BEDentedBreastplate() : base() {
		$this.Name               = 'Dented Breastplate'
		$this.MapObjName         = 'dentedbreastplate'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate that has seen better days, but still functions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWovenRobe : BEArmor {
	BEWovenRobe() : base() {
		$this.Name               = 'Woven Robe'
		$this.MapObjName         = 'wovenrobe'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::MagicDefense = 11 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple robe made from woven plant fibers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrudeCuirass : BEArmor {
	BECrudeCuirass() : base() {
		$this.Name               = 'Crude Cuirass'
		$this.MapObjName         = 'crudecuirass'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A poorly made cuirass, offers basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGildedChainmail : BEArmor {
	BEGildedChainmail() : base() {
		$this.Name               = 'Gilded Chainmail'
		$this.MapObjName         = 'gildedchainmail'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 8; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail with decorative gold plating, less practical.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOrnatePlateArmor : BEArmor {
	BEOrnatePlateArmor() : base() {
		$this.Name               = 'Ornate Plate Armor'
		$this.MapObjName         = 'ornateplatearmor'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Highly decorative plate armor, more for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperRobe : BEArmor {
	BEWhisperRobe() : base() {
		$this.Name               = 'Whisper Robe'
		$this.MapObjName         = 'whisperrobe'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::MagicDefense = 19 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes a soft rustling sound, used for quiet movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFleshGolemVest : BEArmor {
	BEFleshGolemVest() : base() {
		$this.Name               = 'Flesh Golem Vest'
		$this.MapObjName         = 'fleshgolemvest'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A repulsive vest made from stitched together flesh, surprisingly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBaronsCuirass : BEArmor {
	BEBaronsCuirass() : base() {
		$this.Name               = 'Baron''s Cuirass'
		$this.MapObjName         = 'baronscuirass'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fancy cuirass, symbolizing minor nobility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamweaversRobe : BEArmor {
	BEDreamweaversRobe() : base() {
		$this.Name               = 'Dreamweaver''s Robe'
		$this.MapObjName         = 'dreamweaversrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that helps its wearer control dreams, useful for illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitaniumPlate : BEArmor {
	BETitaniumPlate() : base() {
		$this.Name               = 'Titanium Plate'
		$this.MapObjName         = 'titaniumplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong plate armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESerpenthideRobe : BEArmor {
	BESerpenthideRobe() : base() {
		$this.Name               = 'Serpenthide Robe'
		$this.MapObjName         = 'serpenthiderobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from the scales of a giant serpent, offers resistance to poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAmuletVest : BEArmor {
	BEAmuletVest() : base() {
		$this.Name               = 'Amulet Vest'
		$this.MapObjName         = 'amuletvest'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{ [StatId]::Defense = 7; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with various protective amulets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGoblinHideTunic : BEArmor {
	BEGoblinHideTunic() : base() {
		$this.Name               = 'Goblin Hide Tunic'
		$this.MapObjName         = 'goblinhidetunic'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude tunic made from goblin hides, smells faintly of swamp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOgreBoneCuirass : BEArmor {
	BEOgreBoneCuirass() : base() {
		$this.Name               = 'Ogre Bone Cuirass'
		$this.MapObjName         = 'ogrebonecuirass'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy cuirass made from ogre bones, very intimidating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHarpyFeatherRobe : BEArmor {
	BEHarpyFeatherRobe() : base() {
		$this.Name               = 'Harpy Feather Robe'
		$this.MapObjName         = 'harpyfeatherrobe'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::MagicDefense = 24 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light robe adorned with harpy feathers, allows graceful movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEUnicornHornPlate : BEArmor {
	BEUnicornHornPlate() : base() {
		$this.Name               = 'Unicorn Horn Plate'
		$this.MapObjName         = 'unicornhornplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 30; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor inlaid with fragments of unicorn horn, very rare.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChiffonGown : BEArmor {
	BEChiffonGown() : base() {
		$this.Name               = 'Chiffon Gown'
		$this.MapObjName         = 'chiffongown'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{ [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate and sheer gown, provides no protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBridalGown : BEArmor {
	BEBridalGown() : base() {
		$this.Name               = 'Bridal Gown'
		$this.MapObjName         = 'bridalgown'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful white gown, worn for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEFortuneTellersRobe : BEArmor {
	BEFortuneTellersRobe() : base() {
		$this.Name               = 'Fortune Teller''s Robe'
		$this.MapObjName         = 'fortunetellersrobe'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::MagicDefense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful robe with mystical symbols, enhances foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBardsVest : BEArmor {
	BEBardsVest() : base() {
		$this.Name               = 'Bard''s Vest'
		$this.MapObjName         = 'bardsvest'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with performances, slight charm boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEScholarsGown : BEArmor {
	BEScholarsGown() : base() {
		$this.Name               = 'Scholar''s Gown'
		$this.MapObjName         = 'scholarsgown'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dignified gown for intellectual pursuits, very comfortable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECourtJestersTunic : BEArmor {
	BECourtJestersTunic() : base() {
		$this.Name               = 'Court Jester''s Tunic'
		$this.MapObjName         = 'courtjesterstunic'
		$this.PurchasePrice      = 30
		$this.SellPrice          = 15
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brightly colored tunic, offers no protection, purely cosmetic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArtisansApron : BEArmor {
	BEArtisansApron() : base() {
		$this.Name               = 'Artisan''s Apron'
		$this.MapObjName         = 'artisansapron'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical apron with many pockets, good for crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMinersVest : BEArmor {
	BEMinersVest() : base() {
		$this.Name               = 'Miner''s Vest'
		$this.MapObjName         = 'minersvest'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick vest, offers protection against falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEInquisitorsRobe : BEArmor {
	BEInquisitorsRobe() : base() {
		$this.Name               = 'Inquisitor''s Robe'
		$this.MapObjName         = 'inquisitorsrobe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim robe worn by those who seek out evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEReapersShroud : BEArmor {
	BEReapersShroud() : base() {
		$this.Name               = 'Reaper''s Shroud'
		$this.MapObjName         = 'reapersshroud'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, flowing shroud that seems to absorb light, feared by many.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBarbariansFurVest : BEArmor {
	BEBarbariansFurVest() : base() {
		$this.Name               = 'Barbarian''s Fur Vest'
		$this.MapObjName         = 'barbariansfurvest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged vest made of thick fur, offers warmth and protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENomadsTunic : BEArmor {
	BENomadsTunic() : base() {
		$this.Name               = 'Nomad''s Tunic'
		$this.MapObjName         = 'nomadstunic'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable tunic for desert wanderers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEZephyrVest : BEArmor {
	BEZephyrVest() : base() {
		$this.Name               = 'Zephyr Vest'
		$this.MapObjName         = 'zephyrvest'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light vest that makes the wearer feel faster.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneBreastplate : BEArmor {
	BEStoneBreastplate() : base() {
		$this.Name               = 'Stone Breastplate'
		$this.MapObjName         = 'stonebreastplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy breastplate carved from a single piece of stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENetherRobe : BEArmor {
	BENetherRobe() : base() {
		$this.Name               = 'Nether Robe'
		$this.MapObjName         = 'netherrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe from the underworld, radiating ominous energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyrmscaleVest : BEArmor {
	BEWyrmscaleVest() : base() {
		$this.Name               = 'Wyrmscale Vest'
		$this.MapObjName         = 'wyrmscalevest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest crafted from the scales of a smaller wyrm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilverPlateArmor : BEArmor {
	BESilverPlateArmor() : base() {
		$this.Name               = 'Silver Plate Armor'
		$this.MapObjName         = 'silverplatearmor'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor forged from pure silver, shines brightly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunesmithsRobe : BEArmor {
	BERunesmithsRobe() : base() {
		$this.Name               = 'Runesmith''s Robe'
		$this.MapObjName         = 'runesmithsrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy robe adorned with glowing runes, enhances enchanting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChitinCuirass : BEArmor {
	BEChitinCuirass() : base() {
		$this.Name               = 'Chitin Cuirass'
		$this.MapObjName         = 'chitincuirass'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from the hard exoskeleton of a giant insect.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemHeartBreastplate : BEArmor {
	BEGolemHeartBreastplate() : base() {
		$this.Name               = 'Golem Heart Breastplate'
		$this.MapObjName         = 'golemheartbreastplate'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{ [StatId]::Defense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate embedded with the pulsating core of a golem.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarfallRobe : BEArmor {
	BEStarfallRobe() : base() {
		$this.Name               = 'Starfall Robe'
		$this.MapObjName         = 'starfallrobe'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::MagicDefense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be woven from threads of falling stars, grants incredible power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEtherealVest : BEArmor {
	BEEtherealVest() : base() {
		$this.Name               = 'Ethereal Vest'
		$this.MapObjName         = 'etherealvest'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::Defense = 10; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A semi-transparent vest that seems to flicker in and out of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpecterVest : BEArmor {
	BESpecterVest() : base() {
		$this.Name               = 'Specter Vest'
		$this.MapObjName         = 'spectervest'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 3; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that offers slight resistance to spiritual attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShamansRobe : BEArmor {
	BEShamansRobe() : base() {
		$this.Name               = 'Shaman''s Robe'
		$this.MapObjName         = 'shamansrobe'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial robe adorned with totems and charms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECultistsRobe : BEArmor {
	BECultistsRobe() : base() {
		$this.Name               = 'Cultist''s Robe'
		$this.MapObjName         = 'cultistsrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark and ominous robe, often worn by followers of dark deities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExecutionersPlate : BEArmor {
	BEExecutionersPlate() : base() {
		$this.Name               = 'Executioner''s Plate'
		$this.MapObjName         = 'executionersplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and dark plate armor, designed for maximum intimidation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBloodRobe : BEArmor {
	BEBloodRobe() : base() {
		$this.Name               = 'Blood Robe'
		$this.MapObjName         = 'bloodrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 5; [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe stained with ancient blood, granting power through sacrifice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonKingsCuirass : BEArmor {
	BEDragonKingsCuirass() : base() {
		$this.Name               = 'Dragon King''s Cuirass'
		$this.MapObjName         = 'dragonkingscuirass'
		$this.PurchasePrice      = 3000
		$this.SellPrice          = 1500
		$this.TargetStats        = @{ [StatId]::Defense = 40; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The legendary cuirass of a dragon ruler, immensely powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineRobe : BEArmor {
	BEDivineRobe() : base() {
		$this.Name               = 'Divine Robe'
		$this.MapObjName         = 'divinerobe'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::MagicDefense = 45 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe of unparalleled purity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlordsPlate : BEArmor {
	BEWarlordsPlate() : base() {
		$this.Name               = 'Warlord''s Plate'
		$this.MapObjName         = 'warlordsplate'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{ [StatId]::Defense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The battle-hardened plate armor of a seasoned warlord.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMistRobe : BEArmor {
	BEMistRobe() : base() {
		$this.Name               = 'Mist Robe'
		$this.MapObjName         = 'mistrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to shimmer like mist, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneSkinVest : BEArmor {
	BEStoneSkinVest() : base() {
		$this.Name               = 'Stone Skin Vest'
		$this.MapObjName         = 'stoneskinvest'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that makes the wearer''s skin as hard as stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEnigmaRobe : BEArmor {
	BEEnigmaRobe() : base() {
		$this.Name               = 'Enigma Robe'
		$this.MapObjName         = 'enigmarobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::MagicDefense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that constantly changes its magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChampionsBreastplate : BEArmor {
	BEChampionsBreastplate() : base() {
		$this.Name               = 'Champion''s Breastplate'
		$this.MapObjName         = 'championsbreastplate'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The shining breastplate of a revered champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcerersTunic : BEArmor {
	BESorcerersTunic() : base() {
		$this.Name               = 'Sorcerer''s Tunic'
		$this.MapObjName         = 'sorcererstunic'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{ [StatId]::MagicDefense = 12 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic, often worn under a robe, with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAdventurersJacket : BEArmor {
	BEAdventurersJacket() : base() {
		$this.Name               = 'Adventurer''s Jacket'
		$this.MapObjName         = 'adventurersjacket'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A versatile jacket with many pockets, good for general exploration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHermitsRobe : BEArmor {
	BEHermitsRobe() : base() {
		$this.Name               = 'Hermit''s Robe'
		$this.MapObjName         = 'hermitsrobe'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A plain, patched robe, worn by reclusive wise individuals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGuardsUniform : BEArmor {
	BEGuardsUniform() : base() {
		$this.Name               = 'Guard''s Uniform'
		$this.MapObjName         = 'guardsuniform'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The standard uniform of a town guard, offers moderate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEExecutionersVest : BEArmor {
	BEExecutionersVest() : base() {
		$this.Name               = 'Executioner''s Vest'
		$this.MapObjName         = 'executionersvest'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy, dark vest worn by those carrying out justice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BENecromancersRobe : BEArmor {
	BENecromancersRobe() : base() {
		$this.Name               = 'Necromancer''s Robe'
		$this.MapObjName         = 'necromancersrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling robe that pulses with unholy energy, enhancing dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlessedChainmail : BEArmor {
	BEBlessedChainmail() : base() {
		$this.Name               = 'Blessed Chainmail'
		$this.MapObjName         = 'blessedchainmail'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 11; [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail consecrated by holy rites, effective against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianCuirass : BEArmor {
	BEObsidianCuirass() : base() {
		$this.Name               = 'Obsidian Cuirass'
		$this.MapObjName         = 'obsidiancuirass'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass carved from pure obsidian, incredibly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenRobe : BEArmor {
	BESunkenRobe() : base() {
		$this.Name               = 'Sunken Robe'
		$this.MapObjName         = 'sunkenrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe recovered from deep sea ruins, still damp but enchanted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansPlate : BEArmor {
	BETitansPlate() : base() {
		$this.Name               = 'Titan''s Plate'
		$this.MapObjName         = 'titansplate'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{ [StatId]::Defense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor said to be forged by ancient titans, immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmberRobe : BEArmor {
	BEEmberRobe() : base() {
		$this.Name               = 'Ember Robe'
		$this.MapObjName         = 'emberrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that radiates a faint warmth, hinting at fire magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrystalCuirass : BEArmor {
	BECrystalCuirass() : base() {
		$this.Name               = 'Crystal Cuirass'
		$this.MapObjName         = 'crystalcuirass'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened magical crystals, somewhat fragile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVindicatorsPlate : BEArmor {
	BEVindicatorsPlate() : base() {
		$this.Name               = 'Vindicator''s Plate'
		$this.MapObjName         = 'vindicatorsplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor worn by those who seek justice, glows faintly.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhantomRobe : BEArmor {
	BEPhantomRobe() : base() {
		$this.Name               = 'Phantom Robe'
		$this.MapObjName         = 'phantomrobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes the wearer partially incorporeal, enhancing evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulboundVest : BEArmor {
	BESoulboundVest() : base() {
		$this.Name               = 'Soulbound Vest'
		$this.MapObjName         = 'soulboundvest'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::Defense = 8; [StatId]::MagicDefense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that has formed a mystical link with its wearer, gaining power over time.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialRobe : BEArmor {
	BEGlacialRobe() : base() {
		$this.Name               = 'Glacial Robe'
		$this.MapObjName         = 'glacialrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe radiating intense cold, perfect for ice mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDragonSlayersPlate : BEArmor {
	BEDragonSlayersPlate() : base() {
		$this.Name               = 'Dragon Slayer''s Plate'
		$this.MapObjName         = 'dragonslayersplate'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{ [StatId]::Defense = 42 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor designed specifically to combat dragons, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMonksGi : BEArmor {
	BEMonksGi() : base() {
		$this.Name               = 'Monk''s Gi'
		$this.MapObjName         = 'monksgi'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, loose-fitting martial arts uniform.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelersCloak : BEArmor {
	BETravelersCloak() : base() {
		$this.Name               = 'Traveler''s Cloak'
		$this.MapObjName         = 'travelerscloak'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A multi-purpose cloak that can be worn like a tunic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHerbalistsTunic : BEArmor {
	BEHerbalistsTunic() : base() {
		$this.Name               = 'Herbalist''s Tunic'
		$this.MapObjName         = 'herbaliststunic'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{ [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic with many pockets for herbs, slightly protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEngineersVest : BEArmor {
	BEEngineersVest() : base() {
		$this.Name               = 'Engineer''s Vest'
		$this.MapObjName         = 'engineersvest'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with various tools and pockets, offers minor defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlitteringRobe : BEArmor {
	BEGlitteringRobe() : base() {
		$this.Name               = 'Glittering Robe'
		$this.MapObjName         = 'glitteringrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with fine silver threads, sparkles in the light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESwashbucklersVest : BEArmor {
	BESwashbucklersVest() : base() {
		$this.Name               = 'Swashbuckler''s Vest'
		$this.MapObjName         = 'swashbucklersvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with agility and charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBeastmastersTunic : BEArmor {
	BEBeastmastersTunic() : base() {
		$this.Name               = 'Beastmaster''s Tunic'
		$this.MapObjName         = 'beastmasterstunic'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from tough animal hides, enhances communication with beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBardsTunic : BEArmor {
	BEBardsTunic() : base() {
		$this.Name               = 'Bard''s Tunic'
		$this.MapObjName         = 'bardstunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable and stylish tunic for performers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGloomRobe : BEArmor {
	BEGloomRobe() : base() {
		$this.Name               = 'Gloom Robe'
		$this.MapObjName         = 'gloomrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, plain robe for those who prefer to remain unnoticed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStonehideVest : BEArmor {
	BEStonehideVest() : base() {
		$this.Name               = 'Stonehide Vest'
		$this.MapObjName         = 'stonehidevest'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that feels as tough as stone, surprisingly flexible.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECoralCuirass : BEArmor {
	BECoralCuirass() : base() {
		$this.Name               = 'Coral Cuirass'
		$this.MapObjName         = 'coralcuirass'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{ [StatId]::Defense = 15; [StatId]::MagicDefense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from hardened coral, offers water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStarSapphireRobe : BEArmor {
	BEStarSapphireRobe() : base() {
		$this.Name               = 'Star Sapphire Robe'
		$this.MapObjName         = 'starsapphirerobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep blue robe embedded with star sapphires, very potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEValiantCuirass : BEArmor {
	BEValiantCuirass() : base() {
		$this.Name               = 'Valiant Cuirass'
		$this.MapObjName         = 'valiantcuirass'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shining cuirass worn by courageous warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWarlocksRobe : BEArmor {
	BEWarlocksRobe() : base() {
		$this.Name               = 'Warlock''s Robe'
		$this.MapObjName         = 'warlocksrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, ominous robe, often associated with forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGriffinFeatherVest : BEArmor {
	BEGriffinFeatherVest() : base() {
		$this.Name               = 'Griffin Feather Vest'
		$this.MapObjName         = 'griffinfeathervest'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 16 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the feathers of a griffin, allows for light fall.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostfireRobe : BEArmor {
	BEFrostfireRobe() : base() {
		$this.Name               = 'Frostfire Robe'
		$this.MapObjName         = 'frostfirerobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers with both ice and fire, very volatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEternalPlate : BEArmor {
	BEEternalPlate() : base() {
		$this.Name               = 'Eternal Plate'
		$this.MapObjName         = 'eternalplate'
		$this.PurchasePrice      = 4000
		$this.SellPrice          = 2000
		$this.TargetStats        = @{ [StatId]::Defense = 50 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor said to be from another dimension, unbreakable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonChainmail : BEArmor {
	BECrimsonChainmail() : base() {
		$this.Name               = 'Crimson Chainmail'
		$this.MapObjName         = 'crimsonchainmail'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{ [StatId]::Defense = 14 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail dyed crimson, favored by elite guards.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAzureRobe : BEArmor {
	BEAzureRobe() : base() {
		$this.Name               = 'Azure Robe'
		$this.MapObjName         = 'azurerobe'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{ [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brilliant blue robe, often worn by powerful water mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEForestDwellersTunic : BEArmor {
	BEForestDwellersTunic() : base() {
		$this.Name               = 'Forest Dweller''s Tunic'
		$this.MapObjName         = 'forestdwellerstunic'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::Defense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A green tunic that blends in with natural environments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPoachersVest : BEArmor {
	BEPoachersVest() : base() {
		$this.Name               = 'Poacher''s Vest'
		$this.MapObjName         = 'poachersvest'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stealthy vest with many hidden compartments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacialBreastplate : BEArmor {
	BEGlacialBreastplate() : base() {
		$this.Name               = 'Glacial Breastplate'
		$this.MapObjName         = 'glacialbreastplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate emanating a freezing aura, good against fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolcanicRobe : BEArmor {
	BEVolcanicRobe() : base() {
		$this.Name               = 'Volcanic Robe'
		$this.MapObjName         = 'volcanicrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from cooled lava, resisting extreme heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalPlate : BEArmor {
	BEAbyssalPlate() : base() {
		$this.Name               = 'Abyssal Plate'
		$this.MapObjName         = 'abyssalplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{ [StatId]::Defense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor from the deepest parts of the ocean, incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESkyforgedCuirass : BEArmor {
	BESkyforgedCuirass() : base() {
		$this.Name               = 'Skyforged Cuirass'
		$this.MapObjName         = 'skyforgedcuirass'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass said to be hammered from clouds, very light and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenTreasureRobe : BEArmor {
	BESunkenTreasureRobe() : base() {
		$this.Name               = 'Sunken Treasure Robe'
		$this.MapObjName         = 'sunkentreasurerobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::MagicDefense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe encrusted with pearls and gems from sunken ships, carries a sea enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEOnyxPlate : BEArmor {
	BEOnyxPlate() : base() {
		$this.Name               = 'Onyx Plate'
		$this.MapObjName         = 'onyxplate'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from polished black onyx, very heavy and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESilver-ThreadedRobe : BEArmor {
	BESilver-ThreadedRobe() : base() {
		$this.Name               = 'Silver-Threaded Robe'
		$this.MapObjName         = 'silver-threadedrobe'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{ [StatId]::MagicDefense = 25 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe intricately woven with silver threads, enhances defense against dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEIronboundVest : BEArmor {
	BEIronboundVest() : base() {
		$this.Name               = 'Ironbound Vest'
		$this.MapObjName         = 'ironboundvest'
		$this.PurchasePrice      = 310
		$this.SellPrice          = 155
		$this.TargetStats        = @{ [StatId]::Defense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with iron plates sewn into the fabric for added protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWhisperwindTunic : BEArmor {
	BEWhisperwindTunic() : base() {
		$this.Name               = 'Whisperwind Tunic'
		$this.MapObjName         = 'whisperwindtunic'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight tunic that barely rustles, ideal for stealth and speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESolarCuirass : BEArmor {
	BESolarCuirass() : base() {
		$this.Name               = 'Solar Cuirass'
		$this.MapObjName         = 'solarcuirass'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{ [StatId]::Defense = 17; [StatId]::MagicDefense = 2 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that radiates a gentle warmth, offering minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEMoonstoneRobe : BEArmor {
	BEMoonstoneRobe() : base() {
		$this.Name               = 'Moonstone Robe'
		$this.MapObjName         = 'moonstonerobe'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{ [StatId]::MagicDefense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe adorned with glowing moonstones, boosting lunar magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGargoylePlate : BEArmor {
	BEGargoylePlate() : base() {
		$this.Name               = 'Gargoyle Plate'
		$this.MapObjName         = 'gargoyleplate'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, grotesque plate armor carved to resemble a gargoyle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESpiritwalkersVest : BEArmor {
	BESpiritwalkersVest() : base() {
		$this.Name               = 'Spiritwalker''s Vest'
		$this.MapObjName         = 'spiritwalkersvest'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Defense = 9; [StatId]::MagicDefense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that aids in traversing spiritual realms, light but protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEArcaneWeaveRobe : BEArmor {
	BEArcaneWeaveRobe() : base() {
		$this.Name               = 'Arcane Weave Robe'
		$this.MapObjName         = 'arcaneweaverobe'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{ [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with pure arcane energy, granting significant magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlackenedSteelCuirass : BEArmor {
	BEBlackenedSteelCuirass() : base() {
		$this.Name               = 'Blackened Steel Cuirass'
		$this.MapObjName         = 'blackenedsteelcuirass'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{ [StatId]::Defense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Steel cuirass treated to a dark, menacing finish.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFey-TouchedTunic : BEArmor {
	BEFey-TouchedTunic() : base() {
		$this.Name               = 'Fey-Touched Tunic'
		$this.MapObjName         = 'fey-touchedtunic'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{ [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic seemingly woven from forest leaves, offering minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEShadow-StitchedVest : BEArmor {
	BEShadow-StitchedVest() : base() {
		$this.Name               = 'Shadow-Stitched Vest'
		$this.MapObjName         = 'shadow-stitchedvest'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest sewn with threads of shadow, enhancing stealth and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDivineAegisBreastplate : BEArmor {
	BEDivineAegisBreastplate() : base() {
		$this.Name               = 'Divine Aegis Breastplate'
		$this.MapObjName         = 'divineaegisbreastplate'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate radiating holy light, offering strong defense against evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEElementalMastersRobe : BEArmor {
	BEElementalMastersRobe() : base() {
		$this.Name               = 'Elemental Master''s Robe'
		$this.MapObjName         = 'elementalmastersrobe'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{ [StatId]::Defense = 5; [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with the essence of all four elements, highly versatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVenomhideCuirass : BEArmor {
	BEVenomhideCuirass() : base() {
		$this.Name               = 'Venomhide Cuirass'
		$this.MapObjName         = 'venomhidecuirass'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{ [StatId]::Defense = 18 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass made from poisonous beast hide, offering minor toxin resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAstralSilkRobe : BEArmor {
	BEAstralSilkRobe() : base() {
		$this.Name               = 'Astral Silk Robe'
		$this.MapObjName         = 'astralsilkrobe'
		$this.PurchasePrice      = 1650
		$this.SellPrice          = 825
		$this.TargetStats        = @{ [StatId]::MagicDefense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from ethereal silk, allowing slight glimpses into other dimensions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrystalineBreastplate : BEArmor {
	BECrystalineBreastplate() : base() {
		$this.Name               = 'Crystaline Breastplate'
		$this.MapObjName         = 'crystalinebreastplate'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{ [StatId]::Defense = 27; [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate forged from compressed magical crystals, very durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChronosRobe : BEArmor {
	BEChronosRobe() : base() {
		$this.Name               = 'Chronos Robe'
		$this.MapObjName         = 'chronosrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that seems to slightly bend time around the wearer, boosting speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAbyssalChainmail : BEArmor {
	BEAbyssalChainmail() : base() {
		$this.Name               = 'Abyssal Chainmail'
		$this.MapObjName         = 'abyssalchainmail'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::Defense = 15 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail found in the deepest parts of the ocean, resistant to pressure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDesertWanderersRobe : BEArmor {
	BEDesertWanderersRobe() : base() {
		$this.Name               = 'Desert Wanderer''s Robe'
		$this.MapObjName         = 'desertwanderersrobe'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{ [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, breathable robe ideal for hot climates, offers minor sun protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStoneGuardTunic : BEArmor {
	BEStoneGuardTunic() : base() {
		$this.Name               = 'Stone Guard Tunic'
		$this.MapObjName         = 'stoneguardtunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{ [StatId]::Defense = 3 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic reinforced with small stone plates for basic defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPilgrimsVest : BEArmor {
	BEPilgrimsVest() : base() {
		$this.Name               = 'Pilgrim''s Vest'
		$this.MapObjName         = 'pilgrimsvest'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{  }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable vest for long journeys of faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAlchemistsApron : BEArmor {
	BEAlchemistsApron() : base() {
		$this.Name               = 'Alchemist''s Apron'
		$this.MapObjName         = 'alchemistsapron'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{ [StatId]::Defense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy apron with many pockets, useful for potion crafting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamersRobe : BEArmor {
	BEDreamersRobe() : base() {
		$this.Name               = 'Dreamer''s Robe'
		$this.MapObjName         = 'dreamersrobe'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::MagicDefense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A soft robe that aids in lucid dreaming, enhancing magical recovery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERiverstoneVest : BEArmor {
	BERiverstoneVest() : base() {
		$this.Name               = 'Riverstone Vest'
		$this.MapObjName         = 'riverstonevest'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{ [StatId]::Defense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest embedded with smooth river stones, offering minor water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEFrostweaveRobe : BEArmor {
	BEFrostweaveRobe() : base() {
		$this.Name               = 'Frostweave Robe'
		$this.MapObjName         = 'frostweaverobe'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{ [StatId]::MagicDefense = 22 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from icy fibers, providing cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlimmeringChainmail : BEArmor {
	BEGlimmeringChainmail() : base() {
		$this.Name               = 'Glimmering Chainmail'
		$this.MapObjName         = 'glimmeringchainmail'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{ [StatId]::Defense = 12; [StatId]::MagicDefense = 1 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Chainmail that catches the light and subtly disorients foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEWyvernBoneCuirass : BEArmor {
	BEWyvernBoneCuirass() : base() {
		$this.Name               = 'Wyvern Bone Cuirass'
		$this.MapObjName         = 'wyvernbonecuirass'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::Defense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass crafted from the bones of a wyvern, lightweight yet strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECelestialMessengersRobe : BEArmor {
	BECelestialMessengersRobe() : base() {
		$this.Name               = 'Celestial Messenger''s Robe'
		$this.MapObjName         = 'celestialmessengersrobe'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe said to be worn by celestial beings, granting wisdom and foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGolemPlating : BEArmor {
	BEGolemPlating() : base() {
		$this.Name               = 'Golem Plating'
		$this.MapObjName         = 'golemplating'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{ [StatId]::Defense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sections of golem plating fashioned into a heavy torso armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESoulfireRobe : BEArmor {
	BESoulfireRobe() : base() {
		$this.Name               = 'Soulfire Robe'
		$this.MapObjName         = 'soulfirerobe'
		$this.PurchasePrice      = 1950
		$this.SellPrice          = 975
		$this.TargetStats        = @{ [StatId]::MagicDefense = 37 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with captured souls, radiating dark energy and boosting spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEObsidianGuardVest : BEArmor {
	BEObsidianGuardVest() : base() {
		$this.Name               = 'Obsidian Guard Vest'
		$this.MapObjName         = 'obsidianguardvest'
		$this.PurchasePrice      = 480
		$this.SellPrice          = 240
		$this.TargetStats        = @{ [StatId]::Defense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest reinforced with shards of obsidian, offering sharp defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEmeraldRobe : BEArmor {
	BEEmeraldRobe() : base() {
		$this.Name               = 'Emerald Robe'
		$this.MapObjName         = 'emeraldrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 26 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant green robe adorned with emeralds, enhancing nature magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERunicBreastplate : BEArmor {
	BERunicBreastplate() : base() {
		$this.Name               = 'Runic Breastplate'
		$this.MapObjName         = 'runicbreastplate'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate etched with protective runes, offering strong magical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStardustRobe : BEArmor {
	BEStardustRobe() : base() {
		$this.Name               = 'Stardust Robe'
		$this.MapObjName         = 'stardustrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{ [StatId]::MagicDefense = 34 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers like scattered stardust, boosting cosmic magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVikingChainmail : BEArmor {
	BEVikingChainmail() : base() {
		$this.Name               = 'Viking Chainmail'
		$this.MapObjName         = 'vikingchainmail'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, sturdy chainmail favored by northern warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreadKnightsCuirass : BEArmor {
	BEDreadKnightsCuirass() : base() {
		$this.Name               = 'Dread Knight''s Cuirass'
		$this.MapObjName         = 'dreadknightscuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 29 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying black cuirass, instilling fear in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEAetherRobe : BEArmor {
	BEAetherRobe() : base() {
		$this.Name               = 'Aether Robe'
		$this.MapObjName         = 'aetherrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A translucent robe that seems to shift with air currents, very light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEChimeraHideVest : BEArmor {
	BEChimeraHideVest() : base() {
		$this.Name               = 'Chimera Hide Vest'
		$this.MapObjName         = 'chimerahidevest'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::Defense = 20 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest made from the hides of various monstrous creatures, granting varied resistances.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVampiricRobe : BEArmor {
	BEVampiricRobe() : base() {
		$this.Name               = 'Vampiric Robe'
		$this.MapObjName         = 'vampiricrobe'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{ [StatId]::Defense = 3; [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly drains life from enemies during combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEStormforgedPlate : BEArmor {
	BEStormforgedPlate() : base() {
		$this.Name               = 'Stormforged Plate'
		$this.MapObjName         = 'stormforgedplate'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{ [StatId]::Defense = 35 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor that hums with static electricity, resisting lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEchoingRobe : BEArmor {
	BEEchoingRobe() : base() {
		$this.Name               = 'Echoing Robe'
		$this.MapObjName         = 'echoingrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 38 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that amplifies spells, but leaves residual magical echoes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETitansLegacyBreastplate : BEArmor {
	BETitansLegacyBreastplate() : base() {
		$this.Name               = 'Titan''s Legacy Breastplate'
		$this.MapObjName         = 'titanslegacybreastplate'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{ [StatId]::Defense = 39 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate said to be a fragment of a titan''s armor, immense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDreamcatcherVest : BEArmor {
	BEDreamcatcherVest() : base() {
		$this.Name               = 'Dreamcatcher Vest'
		$this.MapObjName         = 'dreamcatchervest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest woven with mystical strands, protecting against magical sleep.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESunkenPlate : BEArmor {
	BESunkenPlate() : base() {
		$this.Name               = 'Sunken Plate'
		$this.MapObjName         = 'sunkenplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{ [StatId]::Defense = 33 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plate armor encrusted with barnacles, very resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonWitchsGown : BEArmor {
	BECrimsonWitchsGown() : base() {
		$this.Name               = 'Crimson Witch''s Gown'
		$this.MapObjName         = 'crimsonwitchsgown'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{ [StatId]::MagicDefense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep crimson gown, enhancing dark and fire-based magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERoseSilkRobe : BEArmor {
	BERoseSilkRobe() : base() {
		$this.Name               = 'Rose Silk Robe'
		$this.MapObjName         = 'rosesilkrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::MagicDefense = 17 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate pink silk robe, often worn by charming mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMaidensChainmail : BEArmor {
	BEMaidensChainmail() : base() {
		$this.Name               = 'Maiden''s Chainmail'
		$this.MapObjName         = 'maidenschainmail'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{ [StatId]::Defense = 9 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lighter, more flexible chainmail designed for female warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEnchantedCorset : BEArmor {
	BEEnchantedCorset() : base() {
		$this.Name               = 'Enchanted Corset'
		$this.MapObjName         = 'enchantedcorset'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 2; [StatId]::MagicDefense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A reinforced corset imbued with minor protective enchantments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGoddesssGown : BEArmor {
	BEGoddesssGown() : base() {
		$this.Name               = 'Goddess''s Gown'
		$this.MapObjName         = 'goddesssgown'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::MagicDefense = 40 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant gown said to be blessed by a deity, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEVixensVest : BEArmor {
	BEVixensVest() : base() {
		$this.Name               = 'Vixen''s Vest'
		$this.MapObjName         = 'vixensvest'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{ [StatId]::Defense = 5 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sleek, dark vest, often worn by agile and cunning female rogues.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEEmpresssRobe : BEArmor {
	BEEmpresssRobe() : base() {
		$this.Name               = 'Empress''s Robe'
		$this.MapObjName         = 'empresssrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{ [StatId]::MagicDefense = 32 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A regal robe, richly embroidered and imbued with subtle power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonlitDress : BEArmor {
	BEMoonlitDress() : base() {
		$this.Name               = 'Moonlit Dress'
		$this.MapObjName         = 'moonlitdress'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{ [StatId]::MagicDefense = 23 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flowing dress that glows softly in the moonlight, enhancing illusion magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDiamondCuirass : BEArmor {
	BEDiamondCuirass() : base() {
		$this.Name               = 'Diamond Cuirass'
		$this.MapObjName         = 'diamondcuirass'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{ [StatId]::Defense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sparkling cuirass inlaid with diamonds, very durable and beautiful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEForestNymphsTunic : BEArmor {
	BEForestNymphsTunic() : base() {
		$this.Name               = 'Forest Nymph''s Tunic'
		$this.MapObjName         = 'forestnymphstunic'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{ [StatId]::MagicDefense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from living leaves and moss, blending with nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEBattleMaidensPlate : BEArmor {
	BEBattleMaidensPlate() : base() {
		$this.Name               = 'Battle Maiden''s Plate'
		$this.MapObjName         = 'battlemaidensplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{ [StatId]::Defense = 21 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy plate armor designed for female warriors, allowing flexibility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEQueenofThornsRobe : BEArmor {
	BEQueenofThornsRobe() : base() {
		$this.Name               = 'Queen of Thorns Robe'
		$this.MapObjName         = 'queenofthornsrobe'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{ [StatId]::Defense = 2; [StatId]::MagicDefense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, thorny robe, providing protection and minor offensive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BESpiritDancersBlouse : BEArmor {
	BESpiritDancersBlouse() : base() {
		$this.Name               = 'Spirit Dancer''s Blouse'
		$this.MapObjName         = 'spiritdancersblouse'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{ [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light blouse that enhances agility and spiritual connection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECrimsonCourtGown : BEArmor {
	BECrimsonCourtGown() : base() {
		$this.Name               = 'Crimson Court Gown'
		$this.MapObjName         = 'crimsoncourtgown'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{ [StatId]::MagicDefense = 10 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A luxurious crimson gown, granting slight magical allure.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEShadowHuntresssVest : BEArmor {
	BEShadowHuntresssVest() : base() {
		$this.Name               = 'Shadow Huntress''s Vest'
		$this.MapObjName         = 'shadowhuntresssvest'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{ [StatId]::Defense = 6 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark vest optimized for stealth and ranged attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BECelestialSorceressGown : BEArmor {
	BECelestialSorceressGown() : base() {
		$this.Name               = 'Celestial Sorceress Gown'
		$this.MapObjName         = 'celestialsorceressgown'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{ [StatId]::MagicDefense = 44 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent gown adorned with celestial patterns, immensely powerful for magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDesertRoseDress : BEArmor {
	BEDesertRoseDress() : base() {
		$this.Name               = 'Desert Rose Dress'
		$this.MapObjName         = 'desertrosedress'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{ [StatId]::MagicDefense = 4 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, airy dress, comfortable in hot climates, with minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWinterMaidensRobe : BEArmor {
	BEWinterMaidensRobe() : base() {
		$this.Name               = 'Winter Maiden''s Robe'
		$this.MapObjName         = 'wintermaidensrobe'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{ [StatId]::MagicDefense = 27 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that emanates a chilling aura, providing strong cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorQueensBreastplate : BEArmor {
	BEWarriorQueensBreastplate() : base() {
		$this.Name               = 'Warrior Queen''s Breastplate'
		$this.MapObjName         = 'warriorqueensbreastplate'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 31 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome breastplate worn by a powerful female leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEGothicVest : BEArmor {
	BEGothicVest() : base() {
		$this.Name               = 'Gothic Vest'
		$this.MapObjName         = 'gothicvest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{ [StatId]::Defense = 8 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, layered vest with ornate buckles, offers good defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBonePlate : BEArmor {
	BEBonePlate() : base() {
		$this.Name               = 'Bone Plate'
		$this.MapObjName         = 'boneplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{ [StatId]::Defense = 13 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from hardened bones, eerie but effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEDeepSeaRobe : BEArmor {
	BEDeepSeaRobe() : base() {
		$this.Name               = 'Deep Sea Robe'
		$this.MapObjName         = 'deepsearobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{ [StatId]::MagicDefense = 28 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from rare deep-sea fibers, offers strong water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVolatileVest : BEArmor {
	BEVolatileVest() : base() {
		$this.Name               = 'Volatile Vest'
		$this.MapObjName         = 'volatilevest'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{ [StatId]::Defense = 7; [StatId]::MagicDefense = 7 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that sometimes explodes with magical energy, risky but powerful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEEldritchRobe : BEArmor {
	BEEldritchRobe() : base() {
		$this.Name               = 'Eldritch Robe'
		$this.MapObjName         = 'eldritchrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{ [StatId]::MagicDefense = 36 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly shifts patterns, enhancing forbidden magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidWeaversCuirass : BEArmor {
	BEVoidWeaversCuirass() : base() {
		$this.Name               = 'Void Weaver''s Cuirass'
		$this.MapObjName         = 'voidweaverscuirass'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{ [StatId]::Defense = 30 }
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cuirass that seems to absorb all light, making the wearer harder to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}

