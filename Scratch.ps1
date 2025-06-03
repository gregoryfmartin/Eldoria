Class BELeatherCap : BEHelmet {
    BELeatherCap() : base() {
        $this.Name               = 'Leather Cap'
        $this.MapObjName         = 'leathercap'
        $this.PurchasePrice      = 100
        $this.SellPrice          = 50
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 5 }
        $this.RequiredStats      = @{ [StatId]::Defense = 3 }
        $this.ExamineString      = 'A simple cap made of tanned leather. Offers minimal protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEIronHelmet : BEHelmet {
    BEIronHelmet() : base() {
        $this.Name               = 'Iron Helmet'
        $this.MapObjName         = 'ironhelmet'
        $this.PurchasePrice      = 250
        $this.SellPrice          = 125
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 6 }
        $this.ExamineString      = 'A sturdy helmet forged from iron. Provides basic physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEBronzeHelmet : BEHelmet {
    BEBronzeHelmet() : base() {
        $this.Name               = 'Bronze Helmet'
        $this.MapObjName         = 'bronzehelmet'
        $this.PurchasePrice      = 300
        $this.SellPrice          = 150
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 9; [StatId]::MagicDefense = 2 }
        $this.RequiredStats      = @{ [StatId]::Defense = 5; [StatId]::MagicDefense = 1 }
        $this.ExamineString      = 'A helm crafted from bronze, offering a touch of magical resistance.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BESpikedHelmet : BEHelmet {
    BESpikedHelmet() : base() {
        $this.Name               = 'Spiked Helmet'
        $this.MapObjName         = 'spikedhelmet'
        $this.PurchasePrice      = 380
        $this.SellPrice          = 190
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 12 }
        $this.RequiredStats      = @{ [StatId]::Defense = 7 }
        $this.ExamineString      = 'An intimidating helmet adorned with sharp spikes. Focuses on physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESteelHelmet : BEHelmet {
    BESteelHelmet() : base() {
        $this.Name               = 'Steel Helmet'
        $this.MapObjName         = 'steelhelmet'
        $this.PurchasePrice      = 450
        $this.SellPrice          = 225
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 15 }
        $this.RequiredStats      = @{ [StatId]::Defense = 9 }
        $this.ExamineString      = 'A well-made helmet of steel, providing reliable protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEGreatHelmet : BEHelmet {
    BEGreatHelmet() : base() {
        $this.Name               = 'Great Helmet'
        $this.MapObjName         = 'greathelmet'
        $this.PurchasePrice      = 700
        $this.SellPrice          = 350
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 22 }
        $this.RequiredStats      = @{ [StatId]::Defense = 13 }
        $this.ExamineString      = 'A full-face helmet offering excellent physical protection. Limits visibility.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDragonScaleHelmet : BEHelmet {
    BEDragonScaleHelmet() : base() {
        $this.Name               = 'Dragon Scale Helm'
        $this.MapObjName         = 'dragonscalehelm'
        $this.PurchasePrice      = 900
        $this.SellPrice          = 450
        $this.TargetGender       = [Gender]::Unisex
        $this.TargetStats        = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 15; [StatId]::MagicDefense = 6 }
        $this.ExamineString      = 'A helm crafted from tough dragon scales, offering both physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEHolyHel : BEHelmet {
    BEHolyHel() : base() {
        $this.Name               = 'Holy Helm'
        $this.MapObjName         = 'holyhelm'
        $this.PurchasePrice      = 1100
        $this.SellPrice          = 550
        $this.TargetStats        = @{ [StatId]::Defense = 28; [StatId]::MagicDefense = 15 }
        $this.RequiredStats      = @{ [StatId]::Defense = 17; [StatId]::MagicDefense = 9 }
        $this.ExamineString      = 'A blessed helmet radiating a faint holy aura, providing good defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEKnightsHel : BEHelmet {
    BEKnightsHel() : base() {
        $this.Name               = 'Knight''s Helm'
        $this.MapObjName         = 'knightshelm'
        $this.PurchasePrice      = 1200
        $this.SellPrice          = 600
        $this.TargetStats        = @{ [StatId]::Defense = 30 }
        $this.RequiredStats      = @{ [StatId]::Defense = 18 }
        $this.ExamineString      = 'A classic knight''s helm, symbolizing bravery and offering strong defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEWarHel : BEHelmet {
    BEWarHel() : base() {
        $this.Name               = 'War Helm'
        $this.MapObjName         = 'warhelm'
        $this.PurchasePrice      = 1350
        $this.SellPrice          = 675
        $this.TargetStats        = @{ [StatId]::Defense = 32; [StatId]::MagicDefense = 5 }
        $this.RequiredStats      = @{ [StatId]::Defense = 19; [StatId]::MagicDefense = 3 }
        $this.ExamineString      = 'A rugged helmet designed for battle, with slight magical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDemonHel : BEHelmet {
    BEDemonHel() : base() {
        $this.Name               = 'Demon Helm'
        $this.MapObjName         = 'demonhelm'
        $this.PurchasePrice      = 1750
        $this.SellPrice          = 875
        $this.TargetStats        = @{ [StatId]::Defense = 35; [StatId]::MagicDefense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 21; [StatId]::MagicDefense = 6 }
        $this.ExamineString      = 'A sinister helm imbued with dark energy, offering potent defenses.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEObsidianHel : BEHelmet {
    BEObsidianHel() : base() {
        $this.Name               = 'Obsidian Helm'
        $this.MapObjName         = 'obsidianhelm'
        $this.PurchasePrice      = 2000
        $this.SellPrice          = 1000
        $this.TargetStats        = @{ [StatId]::Defense = 38 }
        $this.RequiredStats      = @{ [StatId]::Defense = 22 }
        $this.ExamineString      = 'A heavy helmet carved from obsidian, providing superb physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEChampionsHel : BEHelmet {
    BEChampionsHel() : base() {
        $this.Name               = 'Champion''s Helm'
        $this.MapObjName         = 'championshelm'
        $this.PurchasePrice      = 2200
        $this.SellPrice          = 1100
        $this.TargetStats        = @{ [StatId]::Defense = 40; [StatId]::MagicDefense = 8 }
        $this.RequiredStats      = @{ [StatId]::Defense = 24; [StatId]::MagicDefense = 5 }
        $this.ExamineString      = 'A helm worn by champions, offering significant physical and some magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEConquerorsHel : BEHelmet {
    BEConquerorsHel() : base() {
        $this.Name               = 'Conqueror''s Helm'
        $this.MapObjName         = 'conquerorshelm'
        $this.PurchasePrice      = 2600
        $this.SellPrice          = 1300
        $this.TargetStats        = @{ [StatId]::Defense = 45 }
        $this.RequiredStats      = @{ [StatId]::Defense = 27 }
        $this.ExamineString      = 'A helm fit for a conqueror, granting exceptional physical fortitude.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEGuardianHel : BEHelmet {
    BEGuardianHel() : base() {
        $this.Name               = 'Guardian Helm'
        $this.MapObjName         = 'guardianhelm'
        $this.PurchasePrice      = 2800
        $this.SellPrice          = 1400
        $this.TargetStats        = @{ [StatId]::Defense = 48; [StatId]::MagicDefense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 29; [StatId]::MagicDefense = 6 }
        $this.ExamineString      = 'A sturdy helm favored by guardians, providing strong all-around protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BERoyalHel : BEHelmet {
    BERoyalHel() : base() {
        $this.Name               = 'Royal Helm'
        $this.MapObjName         = 'royalhelm'
        $this.PurchasePrice      = 3000
        $this.SellPrice          = 1500
        $this.TargetStats        = @{ [StatId]::Defense = 50; [StatId]::MagicDefense = 5 }
        $this.RequiredStats      = @{ [StatId]::Defense = 30; [StatId]::MagicDefense = 3 }
        $this.ExamineString      = 'A regal helmet signifying authority, with balanced defensive capabilities.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDreadHel : BEHelmet {
    BEDreadHel() : base() {
        $this.Name               = 'Dread Helm'
        $this.MapObjName         = 'dreadhelm'
        $this.PurchasePrice      = 3500
        $this.SellPrice          = 1750
        $this.TargetStats        = @{ [StatId]::Defense = 55 }
        $this.RequiredStats      = @{ [StatId]::Defense = 33 }
        $this.ExamineString      = 'A terrifying helm that instills fear, offering superior physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEPaladinsHel : BEHelmet {
    BEPaladinsHel() : base() {
        $this.Name               = 'Paladin''s Helm'
        $this.MapObjName         = 'paladinshelm'
        $this.PurchasePrice      = 3800
        $this.SellPrice          = 1900
        $this.TargetStats        = @{ [StatId]::Defense = 58; [StatId]::MagicDefense = 12 }
        $this.RequiredStats      = @{ [StatId]::Defense = 34; [StatId]::MagicDefense = 7 }
        $this.ExamineString      = 'A gleaming helm worn by paladins, blessed with strong defenses.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BELegendaryHel : BEHelmet {
    BELegendaryHel() : base() {
        $this.Name               = 'Legendary Helm'
        $this.MapObjName         = 'legendaryhelm'
        $this.PurchasePrice      = 4000
        $this.SellPrice          = 2000
        $this.TargetStats        = @{ [StatId]::Defense = 60; [StatId]::MagicDefense = 15 }
        $this.RequiredStats      = @{ [StatId]::Defense = 36; [StatId]::MagicDefense = 9 }
        $this.ExamineString      = 'A legendary helm spoken of in tales, offering remarkable protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDragonboneHel : BEHelmet {
    BEDragonboneHel() : base() {
        $this.Name               = 'Dragonbone Helm'
        $this.MapObjName         = 'dragonbonehelm'
        $this.PurchasePrice      = 4500
        $this.SellPrice          = 2250
        $this.TargetStats        = @{ [StatId]::Defense = 65 }
        $this.RequiredStats      = @{ [StatId]::Defense = 39 }
        $this.ExamineString      = 'A helm crafted from the bones of a mighty dragon, incredibly resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEImperialHel : BEHelmet {
    BEImperialHel() : base() {
        $this.Name               = 'Imperial Helm'
        $this.MapObjName         = 'imperialhelm'
        $this.PurchasePrice      = 4800
        $this.SellPrice          = 2400
        $this.TargetStats        = @{ [StatId]::Defense = 68; [StatId]::MagicDefense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 40; [StatId]::MagicDefense = 6 }
        $this.ExamineString      = 'A majestic helm worn by imperial soldiers, providing excellent defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BERuneplateHel : BEHelmet {
    BERuneplateHel() : base() {
        $this.Name               = 'Runeplate Helm'
        $this.MapObjName         = 'runeplatehelm'
        $this.PurchasePrice      = 5000
        $this.SellPrice          = 2500
        $this.TargetStats        = @{ [StatId]::Defense = 70; [StatId]::MagicDefense = 18 }
        $this.RequiredStats      = @{ [StatId]::Defense = 42; [StatId]::MagicDefense = 10 }
        $this.ExamineString      = 'A helm inscribed with ancient runes, granting strong physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEVoidHel : BEHelmet {
    BEVoidHel() : base() {
        $this.Name               = 'Void Helm'
        $this.MapObjName         = 'voidhelm'
        $this.PurchasePrice      = 5500
        $this.SellPrice          = 2750
        $this.TargetStats        = @{ [StatId]::Defense = 75 }
        $this.RequiredStats      = @{ [StatId]::Defense = 45 }
        $this.ExamineString      = 'A dark helm emanating void energy, offering exceptional physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEColossalHel : BEHelmet {
    BEColossalHel() : base() {
        $this.Name               = 'Colossal Helm'
        $this.MapObjName         = 'colossalhelm'
        $this.PurchasePrice      = 5800
        $this.SellPrice          = 2900
        $this.TargetStats        = @{ [StatId]::Defense = 78; [StatId]::MagicDefense = 12 }
        $this.RequiredStats      = @{ [StatId]::Defense = 46; [StatId]::MagicDefense = 7 }
        $this.ExamineString      = 'A massive helmet providing overwhelming physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDivineHel : BEHelmet {
    BEDivineHel() : base() {
        $this.Name               = 'Divine Helm'
        $this.MapObjName         = 'divinehelm'
        $this.PurchasePrice      = 6000
        $this.SellPrice          = 3000
        $this.TargetStats        = @{ [StatId]::Defense = 80; [StatId]::MagicDefense = 20 }
        $this.RequiredStats      = @{ [StatId]::Defense = 48; [StatId]::MagicDefense = 12 }
        $this.ExamineString      = 'A radiant helm touched by divine power, offering superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEConquerorsCrown : BEHelmet {
    BEConquerorsCrown() : base() {
        $this.Name               = 'Conqueror''s Crown'
        $this.MapObjName         = 'conquerorscrown'
        $this.PurchasePrice      = 6500
        $this.SellPrice          = 3250
        $this.TargetStats        = @{ [StatId]::Defense = 85 }
        $this.RequiredStats      = @{ [StatId]::Defense = 51 }
        $this.ExamineString      = 'The ultimate symbol of conquest, granting peerless physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BETitanHel : BEHelmet {
    BETitanHel() : base() {
        $this.Name               = 'Titan Helm'
        $this.MapObjName         = 'titanhelm'
        $this.PurchasePrice      = 6800
        $this.SellPrice          = 3400
        $this.TargetStats        = @{ [StatId]::Defense = 88; [StatId]::MagicDefense = 15 }
        $this.RequiredStats      = @{ [StatId]::Defense = 52; [StatId]::MagicDefense = 9 }
        $this.ExamineString      = 'A helm befitting a titan, offering immense physical and some magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEEmpyreanHel : BEHelmet {
    BEEmpyreanHel() : base() {
        $this.Name               = 'Empyrean Helm'
        $this.MapObjName         = 'empyreanhelm'
        $this.PurchasePrice      = 7000
        $this.SellPrice          = 3500
        $this.TargetStats        = @{ [StatId]::Defense = 90; [StatId]::MagicDefense = 25 }
        $this.RequiredStats      = @{ [StatId]::Defense = 54; [StatId]::MagicDefense = 15 }
        $this.ExamineString      = 'A heavenly helm radiating celestial energy, providing exceptional defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDoomHel : BEHelmet {
    BEDoomHel() : base() {
        $this.Name               = 'Doom Helm'
        $this.MapObjName         = 'doomhelm'
        $this.PurchasePrice      = 7500
        $this.SellPrice          = 3750
        $this.TargetStats        = @{ [StatId]::Defense = 95 }
        $this.RequiredStats      = @{ [StatId]::Defense = 57 }
        $this.ExamineString      = 'A cursed helm promising unmatched physical power, but at what cost?'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEValorHel : BEHelmet {
    BEValorHel() : base() {
        $this.Name               = 'Valor Helm'
        $this.MapObjName         = 'valorhelm'
        $this.PurchasePrice      = 7800
        $this.SellPrice          = 3900
        $this.TargetStats        = @{ [StatId]::Defense = 98; [StatId]::MagicDefense = 18 }
        $this.RequiredStats      = @{ [StatId]::Defense = 58; [StatId]::MagicDefense = 10 }
        $this.ExamineString      = 'A helm embodying valor, offering remarkable physical and some magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BESovereignHel : BEHelmet {
    BESovereignHel() : base() {
        $this.Name               = 'Sovereign Helm'
        $this.MapObjName         = 'sovereignhelm'
        $this.PurchasePrice      = 8000
        $this.SellPrice          = 4000
        $this.TargetStats        = @{ [StatId]::Defense = 100; [StatId]::MagicDefense = 30 }
        $this.RequiredStats      = @{ [StatId]::Defense = 60; [StatId]::MagicDefense = 18 }
        $this.ExamineString      = 'A majestic helm signifying supreme rule, with outstanding all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWarGodsHel : BEHelmet {
    BEWarGodsHel() : base() {
        $this.Name               = 'War God''s Helm'
        $this.MapObjName         = 'wargodshelm'
        $this.PurchasePrice      = 8500
        $this.SellPrice          = 4250
        $this.TargetStats        = @{ [StatId]::Defense = 105 }
        $this.RequiredStats      = @{ [StatId]::Defense = 63 }
        $this.ExamineString      = 'A helm blessed by the god of war, granting unparalleled physical might.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEIndomitableHel : BEHelmet {
    BEIndomitableHel() : base() {
        $this.Name               = 'Indomitable Helm'
        $this.MapObjName         = 'indomitablehelm'
        $this.PurchasePrice      = 8800
        $this.SellPrice          = 4400
        $this.TargetStats        = @{ [StatId]::Defense = 108; [StatId]::MagicDefense = 20 }
        $this.RequiredStats      = @{ [StatId]::Defense = 64; [StatId]::MagicDefense = 12 }
        $this.ExamineString      = 'An unbreakable helm offering incredible physical and magical resistance.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEOverlordsHel : BEHelmet {
    BEOverlordsHel() : base() {
        $this.Name               = 'Overlord''s Helm'
        $this.MapObjName         = 'overlordshelm'
        $this.PurchasePrice      = 9000
        $this.SellPrice          = 4500
        $this.TargetStats        = @{ [StatId]::Defense = 110; [StatId]::MagicDefense = 35 }
        $this.RequiredStats      = @{ [StatId]::Defense = 66; [StatId]::MagicDefense = 21 }
        $this.ExamineString      = 'A helm worn by the ultimate ruler, granting supreme defensive power.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BECelestialKingsHel : BEHelmet {
    BECelestialKingsHel() : base() {
        $this.Name               = 'Celestial King''s Helm'
        $this.MapObjName         = 'celestialkingshelm'
        $this.PurchasePrice      = 9500
        $this.SellPrice          = 4750
        $this.TargetStats        = @{ [StatId]::Defense = 115 }
        $this.RequiredStats      = @{ [StatId]::Defense = 69 }
        $this.ExamineString      = 'A helm befitting a king of the heavens, with unmatched physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEImmortalHel : BEHelmet {
    BEImmortalHel() : base() {
        $this.Name               = 'Immortal Helm'
        $this.MapObjName         = 'immortalhelm'
        $this.PurchasePrice      = 9800
        $this.SellPrice          = 4900
        $this.TargetStats        = @{ [StatId]::Defense = 118; [StatId]::MagicDefense = 22 }
        $this.RequiredStats      = @{ [StatId]::Defense = 70; [StatId]::MagicDefense = 13 }
        $this.ExamineString      = 'A helm rumored to grant a degree of immortality, offering superb defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BERadiantHel : BEHelmet {
    BERadiantHel() : base() {
        $this.Name               = 'Radiant Helm'
        $this.MapObjName         = 'radianthelm'
        $this.PurchasePrice      = 10000
        $this.SellPrice          = 5000
        $this.TargetStats        = @{ [StatId]::Defense = 120; [StatId]::MagicDefense = 40 }
        $this.RequiredStats      = @{ [StatId]::Defense = 72; [StatId]::MagicDefense = 24 }
        $this.ExamineString      = 'A brilliantly shining helm offering exceptional physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEEtherealHel : BEHelmet {
    BEEtherealHel() : base() {
        $this.Name               = 'Ethereal Helm'
        $this.MapObjName         = 'etherealhelm'
        $this.PurchasePrice      = 10500
        $this.SellPrice          = 5250
        $this.TargetStats        = @{ [StatId]::Defense = 125 }
        $this.RequiredStats      = @{ [StatId]::Defense = 75 }
        $this.ExamineString      = 'A helm seemingly formed from pure energy, incredibly physically resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEWorldBreakerHel : BEHelmet {
    BEWorldBreakerHel() : base() {
        $this.Name               = 'World Breaker Helm'
        $this.MapObjName         = 'worldbreakerhelm'
        $this.PurchasePrice      = 10800
        $this.SellPrice          = 5400
        $this.TargetStats        = @{ [StatId]::Defense = 128; [StatId]::MagicDefense = 25 }
        $this.RequiredStats      = @{ [StatId]::Defense = 76; [StatId]::MagicDefense = 15 }
        $this.ExamineString      = 'A helm said to have the power to shatter worlds, offering incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDivineAegisHel : BEHelmet {
    BEDivineAegisHel() : base() {
        $this.Name               = 'Divine Aegis Helm'
        $this.MapObjName         = 'divineaegishelm'
        $this.PurchasePrice      = 11000
        $this.SellPrice          = 5500
        $this.TargetStats        = @{ [StatId]::Defense = 130; [StatId]::MagicDefense = 45 }
        $this.RequiredStats      = @{ [StatId]::Defense = 78; [StatId]::MagicDefense = 27 }
        $this.ExamineString      = 'A helm blessed with divine protection, offering outstanding all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEApexHel : BEHelmet {
    BEApexHel() : base() {
        $this.Name               = 'Apex Helm'
        $this.MapObjName         = 'apexhelm'
        $this.PurchasePrice      = 11500
        $this.SellPrice          = 5750
        $this.TargetStats        = @{ [StatId]::Defense = 135 }
        $this.RequiredStats      = @{ [StatId]::Defense = 81 }
        $this.ExamineString      = 'The ultimate physical helm, representing the peak of protective gear.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEPhoenixHel : BEHelmet {
    BEPhoenixHel() : base() {
        $this.Name               = 'Phoenix Helm'
        $this.MapObjName         = 'phoenixhelm'
        $this.PurchasePrice      = 11800
        $this.SellPrice          = 5900
        $this.TargetStats        = @{ [StatId]::Defense = 138; [StatId]::MagicDefense = 28 }
        $this.RequiredStats      = @{ [StatId]::Defense = 82; [StatId]::MagicDefense = 16 }
        $this.ExamineString      = 'A helm imbued with the fiery spirit of a phoenix, granting great defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDragonfireHel : BEHelmet {
    BEDragonfireHel() : base() {
        $this.Name               = 'Dragonfire Helm'
        $this.MapObjName         = 'dragonfirehelm'
        $this.PurchasePrice      = 12000
        $this.SellPrice          = 6000
        $this.TargetStats        = @{ [StatId]::Defense = 140; [StatId]::MagicDefense = 50 }
        $this.RequiredStats      = @{ [StatId]::Defense = 84; [StatId]::MagicDefense = 30 }
        $this.ExamineString      = 'A helm forged in dragonfire, offering exceptional resistance to all threats.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEGlimmeringHel : BEHelmet {
    BEGlimmeringHel() : base() {
        $this.Name               = 'Glimmering Helm'
        $this.MapObjName         = 'glimmeringhelm'
        $this.PurchasePrice      = 12500
        $this.SellPrice          = 6250
        $this.TargetStats        = @{ [StatId]::Defense = 145 }
        $this.RequiredStats      = @{ [StatId]::Defense = 87 }
        $this.ExamineString      = 'A brightly glimmering helm, offering unmatched physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEUnyieldingHel : BEHelmet {
    BEUnyieldingHel() : base() {
        $this.Name               = 'Unyielding Helm'
        $this.MapObjName         = 'unyieldinghelm'
        $this.PurchasePrice      = 12800
        $this.SellPrice          = 6400
        $this.TargetStats        = @{ [StatId]::Defense = 148; [StatId]::MagicDefense = 30 }
        $this.RequiredStats      = @{ [StatId]::Defense = 88; [StatId]::MagicDefense = 18 }
        $this.ExamineString      = 'A helm that will not yield, providing incredible physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BESunkenKingsHel : BEHelmet {
    BESunkenKingsHel() : base() {
        $this.Name               = 'Sunken King''s Helm'
        $this.MapObjName         = 'sunkenkingshelm'
        $this.PurchasePrice      = 13000
        $this.SellPrice          = 6500
        $this.TargetStats        = @{ [StatId]::Defense = 150; [StatId]::MagicDefense = 55 }
        $this.RequiredStats      = @{ [StatId]::Defense = 90; [StatId]::MagicDefense = 33 }
        $this.ExamineString      = 'A helm from a long-lost underwater kingdom, offering superb protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEAbyssalHel : BEHelmet {
    BEAbyssalHel() : base() {
        $this.Name               = 'Abyssal Helm'
        $this.MapObjName         = 'abyssalhelm'
        $this.PurchasePrice      = 13500
        $this.SellPrice          = 6750
        $this.TargetStats        = @{ [StatId]::Defense = 155 }
        $this.RequiredStats      = @{ [StatId]::Defense = 93 }
        $this.ExamineString      = 'A helm from the deepest abyss, granting phenomenal physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEPrimalHel : BEHelmet {
    BEPrimalHel() : base() {
        $this.Name               = 'Primal Helm'
        $this.MapObjName         = 'primalhelm'
        $this.PurchasePrice      = 13800
        $this.SellPrice          = 6900
        $this.TargetStats        = @{ [StatId]::Defense = 158; [StatId]::MagicDefense = 32 }
        $this.RequiredStats      = @{ [StatId]::Defense = 94; [StatId]::MagicDefense = 19 }
        $this.ExamineString      = 'A helm resonating with primal energy, offering exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEZenithHel : BEHelmet {
    BEZenithHel() : base() {
        $this.Name               = 'Zenith Helm'
        $this.MapObjName         = 'zenithhelm'
        $this.PurchasePrice      = 14000
        $this.SellPrice          = 7000
        $this.TargetStats        = @{ [StatId]::Defense = 160; [StatId]::MagicDefense = 60 }
        $this.RequiredStats      = @{ [StatId]::Defense = 96; [StatId]::MagicDefense = 36 }
        $this.ExamineString      = 'The ultimate helm, representing the zenith of protective craftsmanship.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BECelestialWarlordsHel : BEHelmet {
    BECelestialWarlordsHel() : base() {
        $this.Name               = 'Celestial Warlord''s Helm'
        $this.MapObjName         = 'celestialwarlordshelm'
        $this.PurchasePrice      = 14500
        $this.SellPrice          = 7250
        $this.TargetStats        = @{ [StatId]::Defense = 165 }
        $this.RequiredStats      = @{ [StatId]::Defense = 99 }
        $this.ExamineString      = 'A helm befitting a warlord of the heavens, with supreme physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEAbsoluteHel : BEHelmet {
    BEAbsoluteHel() : base() {
        $this.Name               = 'Absolute Helm'
        $this.MapObjName         = 'absolutehelm'
        $this.PurchasePrice      = 14800
        $this.SellPrice          = 7400
        $this.TargetStats        = @{ [StatId]::Defense = 168; [StatId]::MagicDefense = 35 }
        $this.RequiredStats      = @{ [StatId]::Defense = 100; [StatId]::MagicDefense = 21 }
        $this.ExamineString      = 'The ultimate in protection, offering absolute physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEGodsbaneHel : BEHelmet {
    BEGodsbaneHel() : base() {
        $this.Name               = 'Godsbane Helm'
        $this.MapObjName         = 'godsbanehelm'
        $this.PurchasePrice      = 15000
        $this.SellPrice          = 7500
        $this.TargetStats        = @{ [StatId]::Defense = 170; [StatId]::MagicDefense = 65 }
        $this.RequiredStats      = @{ [StatId]::Defense = 102; [StatId]::MagicDefense = 39 }
        $this.ExamineString      = 'A helm said to be capable of harming gods, offering unparalleled protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWorldsEndHel : BEHelmet {
    BEWorldsEndHel() : base() {
        $this.Name               = 'World''s End Helm'
        $this.MapObjName         = 'worldsendhelm'
        $this.PurchasePrice      = 15500
        $this.SellPrice          = 7750
        $this.TargetStats        = @{ [StatId]::Defense = 175 }
        $this.RequiredStats      = @{ [StatId]::Defense = 105 }
        $this.ExamineString      = 'A helm rumored to have witnessed the end of worlds, incredibly resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEBarbarianHel : BEHelmet {
    BEBarbarianHel() : base() {
        $this.Name               = 'Barbarian Helm'
        $this.MapObjName         = 'barbarianhelm'
        $this.PurchasePrice      = 400
        $this.SellPrice          = 200
        $this.TargetStats        = @{ [StatId]::Defense = 13 }
        $this.RequiredStats      = @{ [StatId]::Defense = 8 }
        $this.ExamineString      = 'A crude but sturdy helmet favored by barbarians. Offers decent physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BECrusaderHel : BEHelmet {
    BECrusaderHel() : base() {
        $this.Name               = 'Crusader Helm'
        $this.MapObjName         = 'crusaderhelm'
        $this.PurchasePrice      = 950
        $this.SellPrice          = 475
        $this.TargetStats        = @{ [StatId]::Defense = 26; [StatId]::MagicDefense = 5 }
        $this.RequiredStats      = @{ [StatId]::Defense = 15; [StatId]::MagicDefense = 3 }
        $this.ExamineString      = 'A gleaming helmet worn by crusaders. Offers good physical and some magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWarlordsVisage : BEHelmet {
    BEWarlordsVisage() : base() {
        $this.Name               = 'Warlord''s Visage'
        $this.MapObjName         = 'warlordsvisage'
        $this.PurchasePrice      = 1500
        $this.SellPrice          = 750
        $this.TargetStats        = @{ [StatId]::Defense = 33 }
        $this.RequiredStats      = @{ [StatId]::Defense = 19 }
        $this.ExamineString      = 'A menacing helmet worn by warlords. Provides significant physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEGriffinHel : BEHelmet {
    BEGriffinHel() : base() {
        $this.Name               = 'Griffin Helm'
        $this.MapObjName         = 'griffinhelm'
        $this.PurchasePrice      = 2100
        $this.SellPrice          = 1050
        $this.TargetStats        = @{ [StatId]::Defense = 42; [StatId]::MagicDefense = 10 }
        $this.RequiredStats      = @{ [StatId]::Defense = 25; [StatId]::MagicDefense = 6 }
        $this.ExamineString      = 'A majestic helm adorned with griffin feathers. Offers strong all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDreadnoughtHel : BEHelmet {
    BEDreadnoughtHel() : base() {
        $this.Name               = 'Dreadnought Helm'
        $this.MapObjName         = 'dreadnoughthelm'
        $this.PurchasePrice      = 2700
        $this.SellPrice          = 1350
        $this.TargetStats        = @{ [StatId]::Defense = 49 }
        $this.RequiredStats      = @{ [StatId]::Defense = 29 }
        $this.ExamineString      = 'A heavily armored helmet favored by dreadnoughts. Provides excellent physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEBerserkersHel : BEHelmet {
    BEBerserkersHel() : base() {
        $this.Name               = 'Berserker''s Helm'
        $this.MapObjName         = 'berserkershelm'
        $this.PurchasePrice      = 3400
        $this.SellPrice          = 1700
        $this.TargetStats        = @{ [StatId]::Defense = 56; [StatId]::MagicDefense = 5 }
        $this.RequiredStats      = @{ [StatId]::Defense = 33; [StatId]::MagicDefense = 3 }
        $this.ExamineString      = 'A fierce helmet that empowers berserkers. Offers great physical and some magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEStormlordsHel : BEHelmet {
    BEStormlordsHel() : base() {
        $this.Name               = 'Stormlord''s Helm'
        $this.MapObjName         = 'stormlordshelm'
        $this.PurchasePrice      = 4100
        $this.SellPrice          = 2050
        $this.TargetStats        = @{ [StatId]::Defense = 62; [StatId]::MagicDefense = 12 }
        $this.RequiredStats      = @{ [StatId]::Defense = 37; [StatId]::MagicDefense = 7 }
        $this.ExamineString      = 'A helm crackling with storm energy. Provides superior all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEEarthshakerHel : BEHelmet {
    BEEarthshakerHel() : base() {
        $this.Name               = 'Earthshaker Helm'
        $this.MapObjName         = 'earthshakerhelm'
        $this.PurchasePrice      = 4900
        $this.SellPrice          = 2450
        $this.TargetStats        = @{ [StatId]::Defense = 72 }
        $this.RequiredStats      = @{ [StatId]::Defense = 43 }
        $this.ExamineString      = 'A solid helmet said to withstand earthquakes. Offers exceptional physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESkyfangHel : BEHelmet {
    BESkyfangHel() : base() {
        $this.Name               = 'Skyfang Helm'
        $this.MapObjName         = 'skyfanghelm'
        $this.PurchasePrice      = 5600
        $this.SellPrice          = 2800
        $this.TargetStats        = @{ [StatId]::Defense = 82; [StatId]::MagicDefense = 15 }
        $this.RequiredStats      = @{ [StatId]::Defense = 49; [StatId]::MagicDefense = 9 }
        $this.ExamineString      = 'A helm crafted from the tooth of a sky serpent. Offers remarkable all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEGladiatorsHel : BEHelmet {
    BEGladiatorsHel() : base() {
        $this.Name               = 'Gladiator''s Helm'
        $this.MapObjName         = 'gladiatorshelm'
        $this.PurchasePrice      = 6400
        $this.SellPrice          = 3200
        $this.TargetStats        = @{ [StatId]::Defense = 89 }
        $this.RequiredStats      = @{ [StatId]::Defense = 53 }
        $this.ExamineString      = 'A battle-worn helmet favored by gladiators. Provides outstanding physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BERoyalGuardHel : BEHelmet {
    BERoyalGuardHel() : base() {
        $this.Name               = 'Royal Guard Helm'
        $this.MapObjName         = 'royalguardhelm'
        $this.PurchasePrice      = 7100
        $this.SellPrice          = 3550
        $this.TargetStats        = @{ [StatId]::Defense = 92; [StatId]::MagicDefense = 20 }
        $this.RequiredStats      = @{ [StatId]::Defense = 55; [StatId]::MagicDefense = 12 }
        $this.ExamineString      = 'A distinguished helmet worn by the royal guard. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDraconianHel : BEHelmet {
    BEDraconianHel() : base() {
        $this.Name               = 'Draconian Helm'
        $this.MapObjName         = 'draconianhelm'
        $this.PurchasePrice      = 7900
        $this.SellPrice          = 3950
        $this.TargetStats        = @{ [StatId]::Defense = 102 }
        $this.RequiredStats      = @{ [StatId]::Defense = 61 }
        $this.ExamineString      = 'A powerful helm forged in the image of a dragon. Grants peerless physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESunstoneHel : BEHelmet {
    BESunstoneHel() : base() {
        $this.Name               = 'Sunstone Helm'
        $this.MapObjName         = 'sunstonehelm'
        $this.PurchasePrice      = 8700
        $this.SellPrice          = 4350
        $this.TargetStats        = @{ [StatId]::Defense = 112; [StatId]::MagicDefense = 25 }
        $this.RequiredStats      = @{ [StatId]::Defense = 67; [StatId]::MagicDefense = 15 }
        $this.ExamineString      = 'A radiant helm powered by a sunstone. Offers excellent physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEShadowflameHel : BEHelmet {
    BEShadowflameHel() : base() {
        $this.Name               = 'Shadowflame Helm'
        $this.MapObjName         = 'shadowflamehelm'
        $this.PurchasePrice      = 9400
        $this.SellPrice          = 4700
        $this.TargetStats        = @{ [StatId]::Defense = 117 }
        $this.RequiredStats      = @{ [StatId]::Defense = 70 }
        $this.ExamineString      = 'A dark helm wreathed in shadowy flames. Provides incredible physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BELionheartHel : BEHelmet {
    BELionheartHel() : base() {
        $this.Name               = 'Lionheart Helm'
        $this.MapObjName         = 'lionhearthelm'
        $this.PurchasePrice      = 10200
        $this.SellPrice          = 5100
        $this.TargetStats        = @{ [StatId]::Defense = 122; [StatId]::MagicDefense = 30 }
        $this.RequiredStats      = @{ [StatId]::Defense = 73; [StatId]::MagicDefense = 18 }
        $this.ExamineString      = 'A courageous helm said to embolden the wearer. Offers superior all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDrakonusHel : BEHelmet {
    BEDrakonusHel() : base() {
        $this.Name               = 'Drakonus Helm'
        $this.MapObjName         = 'drakonushelm'
        $this.PurchasePrice      = 10900
        $this.SellPrice          = 5450
        $this.TargetStats        = @{ [StatId]::Defense = 130 }
        $this.RequiredStats      = @{ [StatId]::Defense = 78 }
        $this.ExamineString      = 'An imposing helm crafted from dragon hide. Grants unmatched physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEVanguardHel : BEHelmet {
    BEVanguardHel() : base() {
        $this.Name               = 'Vanguard Helm'
        $this.MapObjName         = 'vanguardhelm'
        $this.PurchasePrice      = 11600
        $this.SellPrice          = 5800
        $this.TargetStats        = @{ [StatId]::Defense = 136; [StatId]::MagicDefense = 35 }
        $this.RequiredStats      = @{ [StatId]::Defense = 81; [StatId]::MagicDefense = 21 }
        $this.ExamineString      = 'A protective helm favored by vanguards. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEParagonHel : BEHelmet {
    BEParagonHel() : base() {
        $this.Name               = 'Paragon Helm'
        $this.MapObjName         = 'paragonhelm'
        $this.PurchasePrice      = 12300
        $this.SellPrice          = 6150
        $this.TargetStats        = @{ [StatId]::Defense = 142 }
        $this.RequiredStats      = @{ [StatId]::Defense = 85 }
        $this.ExamineString      = 'The epitome of physical protection. A paragon among helms.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESoulforgedHel : BEHelmet {
    BESoulforgedHel() : base() {
        $this.Name               = 'Soulforged Helm'
        $this.MapObjName         = 'soulforgedhelm'
        $this.PurchasePrice      = 13000
        $this.SellPrice          = 6500
        $this.TargetStats        = @{ [StatId]::Defense = 147; [StatId]::MagicDefense = 40 }
        $this.RequiredStats      = @{ [StatId]::Defense = 88; [StatId]::MagicDefense = 24 }
        $this.ExamineString      = 'A helm bound with arcane energies. Offers incredible physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEOblivionHel : BEHelmet {
    BEOblivionHel() : base() {
        $this.Name               = 'Oblivion Helm'
        $this.MapObjName         = 'oblivionhelm'
        $this.PurchasePrice      = 13700
        $this.SellPrice          = 6850
        $this.TargetStats        = @{ [StatId]::Defense = 152 }
        $this.RequiredStats      = @{ [StatId]::Defense = 91 }
        $this.ExamineString      = 'A dark and silent helm from the realm of oblivion. Provides phenomenal physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEEbonsteelHel : BEHelmet {
    BEEbonsteelHel() : base() {
        $this.Name               = 'Ebonsteel Helm'
        $this.MapObjName         = 'ebonsteelhelm'
        $this.PurchasePrice      = 14400
        $this.SellPrice          = 7200
        $this.TargetStats        = @{ [StatId]::Defense = 158; [StatId]::MagicDefense = 45 }
        $this.RequiredStats      = @{ [StatId]::Defense = 94; [StatId]::MagicDefense = 27 }
        $this.ExamineString      = 'A helm forged from rare ebonsteel. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEZenithGuardHel : BEHelmet {
    BEZenithGuardHel() : base() {
        $this.Name               = 'Zenith Guard Helm'
        $this.MapObjName         = 'zenithguardhelm'
        $this.PurchasePrice      = 15100
        $this.SellPrice          = 7550
        $this.TargetStats        = @{ [StatId]::Defense = 162 }
        $this.RequiredStats      = @{ [StatId]::Defense = 97 }
        $this.ExamineString      = 'A top-tier helm favored by elite guards. Grants unmatched physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEThunderclapHel : BEHelmet {
    BEThunderclapHel() : base() {
        $this.Name               = 'Thunderclap Helm'
        $this.MapObjName         = 'thunderclaphelm'
        $this.PurchasePrice      = 15800
        $this.SellPrice          = 7900
        $this.TargetStats        = @{ [StatId]::Defense = 168; [StatId]::MagicDefense = 50 }
        $this.RequiredStats      = @{ [StatId]::Defense = 100; [StatId]::MagicDefense = 30 }
        $this.ExamineString      = 'A helm that resonates with the power of thunder. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWyrmhideHel : BEHelmet {
    BEWyrmhideHel() : base() {
        $this.Name               = 'Wyrmhide Helm'
        $this.MapObjName         = 'wyrmhidehelm'
        $this.PurchasePrice      = 16500
        $this.SellPrice          = 8250
        $this.TargetStats        = @{ [StatId]::Defense = 172 }
        $this.RequiredStats      = @{ [StatId]::Defense = 103 }
        $this.ExamineString      = 'A resilient helm crafted from the hide of a great wyrm. Provides peerless physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEFrostboundHel : BEHelmet {
    BEFrostboundHel() : base() {
        $this.Name               = 'Frostbound Helm'
        $this.MapObjName         = 'frostboundhelm'
        $this.PurchasePrice      = 17200
        $this.SellPrice          = 8600
        $this.TargetStats        = @{ [StatId]::Defense = 178; [StatId]::MagicDefense = 55 }
        $this.RequiredStats      = @{ [StatId]::Defense = 106; [StatId]::MagicDefense = 33 }
        $this.ExamineString      = 'A helm encased in eternal ice. Offers incredible physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BESolarHel : BEHelmet {
    BESolarHel() : base() {
        $this.Name               = 'Solar Helm'
        $this.MapObjName         = 'solarhelm'
        $this.PurchasePrice      = 17900
        $this.SellPrice          = 8950
        $this.TargetStats        = @{ [StatId]::Defense = 182 }
        $this.RequiredStats      = @{ [StatId]::Defense = 109 }
        $this.ExamineString      = 'A radiant helm powered by the sun''s energy. Grants unmatched physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEMoonshardHel : BEHelmet {
    BEMoonshardHel() : base() {
        $this.Name               = 'Moonshard Helm'
        $this.MapObjName         = 'moonshardhelm'
        $this.PurchasePrice      = 18600
        $this.SellPrice          = 9300
        $this.TargetStats        = @{ [StatId]::Defense = 188; [StatId]::MagicDefense = 60 }
        $this.RequiredStats      = @{ [StatId]::Defense = 112; [StatId]::MagicDefense = 36 }
        $this.ExamineString      = 'A helm crafted from a shard of the moon. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEAncientDefenderHel : BEHelmet {
    BEAncientDefenderHel() : base() {
        $this.Name               = 'Ancient Defender Helm'
        $this.MapObjName         = 'ancientdefenderhelm'
        $this.PurchasePrice      = 19300
        $this.SellPrice          = 9650
        $this.TargetStats        = @{ [StatId]::Defense = 192 }
        $this.RequiredStats      = @{ [StatId]::Defense = 115 }
        $this.ExamineString      = 'A relic from an ancient protector. Provides phenomenal physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BECosmicGuardianHel : BEHelmet {
    BECosmicGuardianHel() : base() {
        $this.Name               = 'Cosmic Guardian Helm'
        $this.MapObjName         = 'cosmicguardianhelm'
        $this.PurchasePrice      = 20000
        $this.SellPrice          = 10000
        $this.TargetStats        = @{ [StatId]::Defense = 198; [StatId]::MagicDefense = 65 }
        $this.RequiredStats      = @{ [StatId]::Defense = 118; [StatId]::MagicDefense = 39 }
        $this.ExamineString      = 'A helm imbued with cosmic energies. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDoomslayerHel : BEHelmet {
    BEDoomslayerHel() : base() {
        $this.Name               = 'Doomslayer Helm'
        $this.MapObjName         = 'doomslayerhelm'
        $this.PurchasePrice      = 20700
        $this.SellPrice          = 10350
        $this.TargetStats        = @{ [StatId]::Defense = 202 }
        $this.RequiredStats      = @{ [StatId]::Defense = 121 }
        $this.ExamineString      = 'A legendary helm said to be worn by those who slay doom. Incredibly resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEStarfellHel : BEHelmet {
    BEStarfellHel() : base() {
        $this.Name               = 'Starfell Helm'
        $this.MapObjName         = 'starfellhelm'
        $this.PurchasePrice      = 21400
        $this.SellPrice          = 10700
        $this.TargetStats        = @{ [StatId]::Defense = 208; [StatId]::MagicDefense = 70 }
        $this.RequiredStats      = @{ [StatId]::Defense = 124; [StatId]::MagicDefense = 42 }
        $this.ExamineString      = 'A helm that fell from the stars. Offers incredible physical and magical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEHellfireHel : BEHelmet {
    BEHellfireHel() : base() {
        $this.Name               = 'Hellfire Helm'
        $this.MapObjName         = 'hellfirehelm'
        $this.PurchasePrice      = 22100
        $this.SellPrice          = 11050
        $this.TargetStats        = @{ [StatId]::Defense = 212 }
        $this.RequiredStats      = @{ [StatId]::Defense = 127 }
        $this.ExamineString      = 'A terrifying helm wreathed in hellfire. Grants unmatched physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDivineCrusaderHel : BEHelmet {
    BEDivineCrusaderHel() : base() {
        $this.Name               = 'Divine Crusader Helm'
        $this.MapObjName         = 'divinecrusaderhelm'
        $this.PurchasePrice      = 22800
        $this.SellPrice          = 11400
        $this.TargetStats        = @{ [StatId]::Defense = 218; [StatId]::MagicDefense = 75 }
        $this.RequiredStats      = @{ [StatId]::Defense = 130; [StatId]::MagicDefense = 45 }
        $this.ExamineString      = 'A holy helm blessed for divine crusaders. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEObsidianSkullHel : BEHelmet {
    BEObsidianSkullHel() : base() {
        $this.Name               = 'Obsidian Skull Helm'
        $this.MapObjName         = 'obsidianskullhelmm'
        $this.PurchasePrice      = 23500
        $this.SellPrice          = 11750
        $this.TargetStats        = @{ [StatId]::Defense = 222 }
        $this.RequiredStats      = @{ [StatId]::Defense = 133 }
        $this.ExamineString      = 'A sinister helm crafted from an obsidian skull. Provides phenomenal physical defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEEmpyreanChampionHel : BEHelmet {
    BEEmpyreanChampionHel() : base() {
        $this.Name               = 'Empyrean Champion Helm'
        $this.MapObjName         = 'empyreanchampionhelm'
        $this.PurchasePrice      = 24200
        $this.SellPrice          = 12100
        $this.TargetStats        = @{ [StatId]::Defense = 228; [StatId]::MagicDefense = 80 }
        $this.RequiredStats      = @{ [StatId]::Defense = 136; [StatId]::MagicDefense = 48 }
        $this.ExamineString      = 'A helm befitting a champion of the empyrean. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEValhallanHel : BEHelmet {
    BEValhallanHel() : base() {
        $this.Name               = 'Valhallan Helm'
        $this.MapObjName         = 'valhallanhelm'
        $this.PurchasePrice      = 24900
        $this.SellPrice          = 12450
        $this.TargetStats        = @{ [StatId]::Defense = 232 }
        $this.RequiredStats      = @{ [StatId]::Defense = 139 }
        $this.ExamineString      = 'A glorious helm from the halls of Valhalla. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDrakonbaneHel : BEHelmet {
    BEDrakonbaneHel()) : base() {
        $this.Name               = 'Drakonbane Helm'
        $this.MapObjName         = 'drakonbanehelm'
        $this.PurchasePrice      = 25600
        $this.SellPrice          = 12800
        $this.TargetStats        = @{ [StatId]::Defense = 238; [StatId]::MagicDefense = 85 }
        $this.RequiredStats      = @{ [StatId]::Defense = 142; [StatId]::MagicDefense = 51 }
        $this.ExamineString      = 'A powerful helm specifically designed to slay dragons. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BETitanforgedHel : BEHelmet {
    BETitanforgedHel() : base() {
        $this.Name               = 'Titanforged Helm'
        $this.MapObjName         = 'titanforgedhelm'
        $this.PurchasePrice      = 26300
        $this.SellPrice          = 13150
        $this.TargetStats        = @{ [StatId]::Defense = 242 }
        $this.RequiredStats      = @{ [StatId]::Defense = 145 }
        $this.ExamineString      = 'A helm forged in the heart of a titan. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BECelestialDreadHel : BEHelmet {
    BECelestialDreadHel() : base() {
        $this.Name               = 'Celestial Dread Helm'
        $this.MapObjName         = 'celestialdreadhelm'
        $this.PurchasePrice      = 27000
        $this.SellPrice          = 13500
        $this.TargetStats        = @{ [StatId]::Defense = 248; [StatId]::MagicDefense = 90 }
        $this.RequiredStats      = @{ [StatId]::Defense = 148; [StatId]::MagicDefense = 54 }
        $this.ExamineString      = 'A terrifying helm from the celestial realm. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWorldsCoreHel : BEHelmet {
    BEWorldsCoreHel() : base() {
        $this.Name               = 'World''s Core Helm'
        $this.MapObjName         = 'worldscorehelm'
        $this.PurchasePrice      = 27700
        $this.SellPrice          = 13850
        $this.TargetStats        = @{ [StatId]::Defense = 252 }
        $this.RequiredStats      = @{ [StatId]::Defense = 151 }
        $this.ExamineString      = 'A helm said to contain a fragment of the world''s core. Phenomenally resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BECosmicNovaHel : BEHelmet {
    BECosmicNovaHel() : base() {
        $this.Name               = 'Cosmic Nova Helm'
        $this.MapObjName         = 'cosmicnovahelm'
        $this.PurchasePrice      = 28400
        $this.SellPrice          = 14200
        $this.TargetStats        = @{ [StatId]::Defense = 258; [StatId]::MagicDefense = 95 }
        $this.RequiredStats      = @{ [StatId]::Defense = 154; [StatId]::MagicDefense = 57 }
        $this.ExamineString      = 'A helm radiating the power of a cosmic nova. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEImmortalKingsHel : BEHelmet {
    BEImmortalKingsHel() : base() {
        $this.Name               = 'Immortal King''s Helm'
        $this.MapObjName         = 'immortalkingshelm'
        $this.PurchasePrice      = 29100
        $this.SellPrice          = 14550
        $this.TargetStats        = @{ [StatId]::Defense = 262 }
        $this.RequiredStats      = @{ [StatId]::Defense = 157 }
        $this.ExamineString      = 'A helm worn by an immortal king. Grants peerless physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESoulReaverHel : BEHelmet {
    BESoulReaverHel() : base() {
        $this.Name               = 'Soul Reaver Helm'
        $this.MapObjName         = 'soulreaverhelm'
        $this.PurchasePrice      = 29800
        $this.SellPrice          = 14900
        $this.TargetStats        = @{ [StatId]::Defense = 268; [StatId]::MagicDefense = 100 }
        $this.RequiredStats      = @{ [StatId]::Defense = 160; [StatId]::MagicDefense = 60 }
        $this.ExamineString      = 'A sinister helm that drains the souls of foes. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEZenithApexHel : BEHelmet {
    BEZenithApexHel() : base() {
        $this.Name               = 'Zenith Apex Helm'
        $this.MapObjName         = 'zenithapexhelm'
        $this.PurchasePrice      = 30500
        $this.SellPrice          = 15250
        $this.TargetStats        = @{ [StatId]::Defense = 272 }
        $this.RequiredStats      = @{ [StatId]::Defense = 163 }
        $this.ExamineString      = 'The ultimate helm, representing the zenith of apex protection. Unmatched resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDivineJudgmentHel : BEHelmet {
    BEDivineJudgmentHel() : base() {
        $this.Name               = 'Divine Judgment Helm'
        $this.MapObjName         = 'divinejudgmenthelm'
        $this.PurchasePrice      = 31200
        $this.SellPrice          = 15600
        $this.TargetStats        = @{ [StatId]::Defense = 278; [StatId]::MagicDefense = 105 }
        $this.RequiredStats      = @{ [StatId]::Defense = 166; [StatId]::MagicDefense = 63 }
        $this.ExamineString      = 'A helm used to deliver divine judgment. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BECataclysmHelm : BEHelmet {
    BECataclysmHelm() : base() {
        $this.Name               = 'Cataclysm Helm'
        $this.MapObjName         = 'cataclysmhelmm'
        $this.PurchasePrice      = 31900
        $this.SellPrice          = 15950
        $this.TargetStats        = @{ [StatId]::Defense = 282 }
        $this.RequiredStats      = @{ [StatId]::Defense = 169 }
        $this.ExamineString      = 'A helm that survived a cataclysm. Provides phenomenal physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEStarfallGuardian : BEHelmet {
    BEStarfallGuardian() : base() {
        $this.Name               = 'Starfall Guardian'
        $this.MapObjName         = 'starfallguardianm'
        $this.PurchasePrice      = 32600
        $this.SellPrice          = 16300
        $this.TargetStats        = @{ [StatId]::Defense = 288; [StatId]::MagicDefense = 110 }
        $this.RequiredStats      = @{ [StatId]::Defense = 172; [StatId]::MagicDefense = 66 }
        $this.ExamineString      = 'A helm that guards against falling stars. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEHellborneHelm : BEHelmet {
    BEHellborneHelm() : base() {
        $this.Name               = 'Hellborne Helm'
        $this.MapObjName         = 'hellbornehelmm'
        $this.PurchasePrice      = 33300
        $this.SellPrice          = 16650
        $this.TargetStats        = @{ [StatId]::Defense = 292 }
        $this.RequiredStats      = @{ [StatId]::Defense = 175 }
        $this.ExamineString      = 'A helm forged in the depths of hell. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BELightbringerHelm : BEHelmet {
    BELightbringerHelm() : base() {
        $this.Name               = 'Lightbringer Helm'
        $this.MapObjName         = 'lightbringerhelmm'
        $this.PurchasePrice      = 34000
        $this.SellPrice          = 17000
        $this.TargetStats        = @{ [StatId]::Defense = 298; [StatId]::MagicDefense = 115 }
        $this.RequiredStats      = @{ [StatId]::Defense = 178; [StatId]::MagicDefense = 69 }
        $this.ExamineString      = 'A radiant helm that banishes darkness. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEAbyssalProtectorHelm : BEHelmet {
    BEAbyssalProtectorHelm() : base() {
        $this.Name               = 'Abyssal Protector Helm'
        $this.MapObjName         = 'abyssalprotectorhelmm'
        $this.PurchasePrice      = 34700
        $this.SellPrice          = 17350
        $this.TargetStats        = @{ [StatId]::Defense = 302 }
        $this.RequiredStats      = @{ [StatId]::Defense = 181 }
        $this.ExamineString      = 'A helm that protects against the abyss. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEPhoenixGuardianHelm : BEHelmet {
    BEPhoenixGuardianHelm() : base() {
        $this.Name               = 'Phoenix Guardian Helm'
        $this.MapObjName         = 'phoenixguardianhelmm'
        $this.PurchasePrice      = 35400
        $this.SellPrice          = 17700
        $this.TargetStats        = @{ [StatId]::Defense = 308; [StatId]::MagicDefense = 120 }
        $this.RequiredStats      = @{ [StatId]::Defense = 184; [StatId]::MagicDefense = 72 }
        $this.ExamineString      = 'A helm guarded by the spirit of a phoenix. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEVoidWalkerHelm : BEHelmet {
    BEVoidWalkerHelm() : base() {
        $this.Name               = 'Void Walker Helm'
        $this.MapObjName         = 'voidwalkerhelmm'
        $this.PurchasePrice      = 36100
        $this.SellPrice          = 18050
        $this.TargetStats        = @{ [StatId]::Defense = 312 }
        $this.RequiredStats      = @{ [StatId]::Defense = 187 }
        $this.ExamineString      = 'A helm worn by those who walk the void. Phenomenally resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESovereignEmperorHelm : BEHelmet {
    BESovereignEmperorHelm() : base() {
        $this.Name               = 'Sovereign Emperor Helm'
        $this.MapObjName         = 'sovereignemperorhelmm'
        $this.PurchasePrice      = 36800
        $this.SellPrice          = 18400
        $this.TargetStats        = @{ [StatId]::Defense = 318; [StatId]::MagicDefense = 125 }
        $this.RequiredStats      = @{ [StatId]::Defense = 190; [StatId]::MagicDefense = 75 }
        $this.ExamineString      = 'A helm befitting a sovereign emperor. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BECosmicConquerorHelm : BEHelmet {
    BECosmicConquerorHelm() : base() {
        $this.Name               = 'Cosmic Conqueror Helm'
        $this.MapObjName         = 'cosmicconquerorhelmm'
        $this.PurchasePrice      = 37500
        $this.SellPrice          = 18750
        $this.TargetStats        = @{ [StatId]::Defense = 322 }
        $this.RequiredStats      = @{ [StatId]::Defense = 193 }
        $this.ExamineString      = 'A helm for those who conquer the cosmos. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEGrandmasterHelm : BEHelmet {
    BEGrandmasterHelm() : base() {
        $this.Name               = 'Grandmaster Helm'
        $this.MapObjName         = 'grandmasterhelmm'
        $this.PurchasePrice      = 38200
        $this.SellPrice          = 19100
        $this.TargetStats        = @{ [StatId]::Defense = 328; [StatId]::MagicDefense = 130 }
        $this.RequiredStats      = @{ [StatId]::Defense = 196; [StatId]::MagicDefense = 78 }
        $this.ExamineString      = 'A helm worn by grandmasters. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEGodKingsHelm : BEHelmet {
    BEGodKingsHelm() : base() {
        $this.Name               = 'God King''s Helm'
        $this.MapObjName         = 'godkingshelmm'
        $this.PurchasePrice      = 38900
        $this.SellPrice          = 19450
        $this.TargetStats        = @{ [StatId]::Defense = 332 }
        $this.RequiredStats      = @{ [StatId]::Defense = 199 }
        $this.ExamineString      = 'A helm fit for a king among gods. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BETrueHeroHelm : BEHelmet {
    BETrueHeroHelm() : base() {
        $this.Name               = 'True Hero Helm'
        $this.MapObjName         = 'trueherohelmm'
        $this.PurchasePrice      = 39600
        $this.SellPrice          = 19800
        $this.TargetStats        = @{ [StatId]::Defense = 338; [StatId]::MagicDefense = 135 }
        $this.RequiredStats      = @{ [StatId]::Defense = 202; [StatId]::MagicDefense = 81 }
        $this.ExamineString      = 'A helm worn by true heroes. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BELegendaryTitanHelm : BEHelmet {
    BELegendaryTitanHelm() : base() {
        $this.Name               = 'Legendary Titan Helm'
        $this.MapObjName         = 'legendarytitanhelmm'
        $this.PurchasePrice      = 40300
        $this.SellPrice          = 20150
        $this.TargetStats        = @{ [StatId]::Defense = 342 }
        $this.RequiredStats      = @{ [StatId]::Defense = 205 }
        $this.ExamineString      = 'A legendary helm forged by titans. Phenomenally resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDivineChampionHelm : BEHelmet {
    BEDivineChampionHelm() : base() {
        $this.Name               = 'Divine Champion Helm'
        $this.MapObjName         = 'divinechampionhelmm'
        $this.PurchasePrice      = 41000
        $this.SellPrice          = 20500
        $this.TargetStats        = @{ [StatId]::Defense = 348; [StatId]::MagicDefense = 140 }
        $this.RequiredStats      = @{ [StatId]::Defense = 208; [StatId]::MagicDefense = 84 }
        $this.ExamineString      = 'A helm worn by divine champions. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEElementalLordHelm : BEHelmet {
    BEElementalLordHelm() : base() {
        $this.Name               = 'Elemental Lord Helm'
        $this.MapObjName         = 'elementallordhelmm'
        $this.PurchasePrice      = 41700
        $this.SellPrice          = 20850
        $this.TargetStats        = @{ [StatId]::Defense = 352 }
        $this.RequiredStats      = @{ [StatId]::Defense = 211 }
        $this.ExamineString      = 'A helm befitting a lord of the elements. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEDragonlordHelm : BEHelmet {
    BEDragonlordHelm() : base() {
        $this.Name               = 'Dragonlord Helm'
        $this.MapObjName         = 'dragonlordhelmm'
        $this.PurchasePrice      = 42400
        $this.SellPrice          = 21200
        $this.TargetStats        = @{ [StatId]::Defense = 358; [StatId]::MagicDefense = 145 }
        $this.RequiredStats      = @{ [StatId]::Defense = 214; [StatId]::MagicDefense = 87 }
        $this.ExamineString      = 'A helm worn by a dragonlord. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BESkybreakerHelm : BEHelmet {
    BESkybreakerHelm() : base() {
        $this.Name               = 'Skybreaker Helm'
        $this.MapObjName         = 'skybreakerhelmm'
        $this.PurchasePrice      = 43100
        $this.SellPrice          = 21550
        $this.TargetStats        = @{ [StatId]::Defense = 362 }
        $this.RequiredStats      = @{ [StatId]::Defense = 217 }
        $this.ExamineString      = 'A helm that can break the very sky. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEWorldsWardenHelm : BEHelmet {
    BEWorldsWardenHelm() : base() {
        $this.Name               = 'World''s Warden Helm'
        $this.MapObjName         = 'worldswardenhelmm'
        $this.PurchasePrice      = 43800
        $this.SellPrice          = 21900
        $this.TargetStats        = @{ [StatId]::Defense = 368; [StatId]::MagicDefense = 150 }
        $this.RequiredStats      = @{ [StatId]::Defense = 220; [StatId]::MagicDefense = 90 }
        $this.ExamineString      = 'A helm that guards the world. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BECosmicSentinelHelm : BEHelmet {
    BECosmicSentinelHelm() : base() {
        $this.Name               = 'Cosmic Sentinel Helm'
        $this.MapObjName         = 'cosmic_sentinelhelmm'
        $this.PurchasePrice      = 44500
        $this.SellPrice          = 22250
        $this.TargetStats        = @{ [StatId]::Defense = 372 }
        $this.RequiredStats      = @{ [StatId]::Defense = 223 }
        $this.ExamineString      = 'A sentinel against cosmic threats. Phenomenally resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEAbsoluteDominatorHelm : BEHelmet {
    BEAbsoluteDominatorHelm() : base() {
        $this.Name               = 'Absolute Dominator Helm'
        $this.MapObjName         = 'absolutedominatorhelmm'
        $this.PurchasePrice      = 45200
        $this.SellPrice          = 22600
        $this.TargetStats        = @{ [StatId]::Defense = 378; [StatId]::MagicDefense = 155 }
        $this.RequiredStats      = @{ [StatId]::Defense = 226; [StatId]::MagicDefense = 93 }
        $this.ExamineString      = 'A helm for the absolute dominator. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEStarfireHelm : BEHelmet {
    BEStarfireHelm() : base() {
        $this.Name               = 'Starfire Helm'
        $this.MapObjName         = 'starfirehelmm'
        $this.PurchasePrice      = 45900
        $this.SellPrice          = 22950
        $this.TargetStats        = @{ [StatId]::Defense = 382 }
        $this.RequiredStats      = @{ [StatId]::Defense = 229 }
        $this.ExamineString      = 'A helm burning with starfire. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BESoulboundProtector : BEHelmet {
    BESoulboundProtector() : base() {
        $this.Name               = 'Soulbound Protector'
        $this.MapObjName         = 'soulboundprotectorm'
        $this.PurchasePrice      = 46600
        $this.SellPrice          = 23300
        $this.TargetStats        = @{ [StatId]::Defense = 388; [StatId]::MagicDefense = 160 }
        $this.RequiredStats      = @{ [StatId]::Defense = 232; [StatId]::MagicDefense = 96 }
        $this.ExamineString      = 'A helm bound to the wearer''s soul. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEEternityHelm : BEHelmet {
    BEEternityHelm() : base() {
        $this.Name               = 'Eternity Helm'
        $this.MapObjName         = 'eternityhelmm'
        $this.PurchasePrice      = 47300
        $this.SellPrice          = 23650
        $this.TargetStats        = @{ [StatId]::Defense = 392 }
        $this.RequiredStats      = @{ [StatId]::Defense = 235 }
        $this.ExamineString      = 'A helm that seems to last for eternity. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BELegendaryDefender : BEHelmet {
    BELegendaryDefender() : base() {
        $this.Name               = 'Legendary Defender'
        $this.MapObjName         = 'legendarydefenderm'
        $this.PurchasePrice      = 48000
        $this.SellPrice          = 24000
        $this.TargetStats        = @{ [StatId]::Defense = 398; [StatId]::MagicDefense = 165 }
        $this.RequiredStats      = @{ [StatId]::Defense = 238; [StatId]::MagicDefense = 99 }
        $this.ExamineString      = 'A helm worn by legendary defenders. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEDivineCreatorHelm : BEHelmet {
    BEDivineCreatorHelm() : base() {
        $this.Name               = 'Divine Creator Helm'
        $this.MapObjName         = 'divinecreatorhelmm'
        $this.PurchasePrice      = 48700
        $this.SellPrice          = 24350
        $this.TargetStats        = @{ [StatId]::Defense = 402 }
        $this.RequiredStats      = @{ [StatId]::Defense = 241 }
        $this.ExamineString      = 'A helm blessed by a divine creator. Phenomenally resilient.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEGenesisHelm : BEHelmet {
    BEGenesisHelm() : base() {
        $this.Name               = 'Genesis Helm'
        $this.MapObjName         = 'genesishelmm'
        $this.PurchasePrice      = 49400
        $this.SellPrice          = 24700
        $this.TargetStats        = @{ [StatId]::Defense = 408; [StatId]::MagicDefense = 170 }
        $this.RequiredStats      = @{ [StatId]::Defense = 244; [StatId]::MagicDefense = 102 }
        $this.ExamineString      = 'A helm from the very beginning. Offers exceptional all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEOblivionSentinel : BEHelmet {
    BEOblivionSentinel() : base() {
        $this.Name               = 'Oblivion Sentinel'
        $this.MapObjName         = 'oblivionsentinelm'
        $this.PurchasePrice      = 50100
        $this.SellPrice          = 25050
        $this.TargetStats        = @{ [StatId]::Defense = 412 }
        $this.RequiredStats      = @{ [StatId]::Defense = 247 }
        $this.ExamineString      = 'A sentinel against the void of oblivion. Grants peerless physical resilience.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BECosmicGenesisHelm : BEHelmet {
    BECosmicGenesisHelm() : base() {
        $this.Name               = 'Cosmic Genesis Helm'
        $this.MapObjName         = 'cosmicgenesishelmm'
        $this.PurchasePrice      = 50800
        $this.SellPrice          = 25400
        $this.TargetStats        = @{ [StatId]::Defense = 418; [StatId]::MagicDefense = 175 }
        $this.RequiredStats      = @{ [StatId]::Defense = 250; [StatId]::MagicDefense = 105 }
        $this.ExamineString      = 'A helm from the genesis of the cosmos. Offers incredible defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEUltimateHelm : BEHelmet {
    BEUltimateHelm() : base() {
        $this.Name               = 'Ultimate Helm'
        $this.MapObjName         = 'ultimatehelmm'
        $this.PurchasePrice      = 51500
        $this.SellPrice          = 25750
        $this.TargetStats        = @{ [StatId]::Defense = 422 }
        $this.RequiredStats      = @{ [StatId]::Defense = 253 }
        $this.ExamineString      = 'The ultimate physical helm. Provides unmatched physical protection.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
    }
}

Class BEAbsoluteGodHelm : BEHelmet {
    BEAbsoluteGodHelm() : base() {
        $this.Name               = 'Absolute God Helm'
        $this.MapObjName         = 'absolutegodhelmm'
        $this.PurchasePrice      = 52200
        $this.SellPrice          = 26100
        $this.TargetStats        = @{ [StatId]::Defense = 428; [StatId]::MagicDefense = 180 }
        $this.RequiredStats      = @{ [StatId]::Defense = 256; [StatId]::MagicDefense = 108 }
        $this.ExamineString      = 'The absolute in head protection. Offers superb all-around defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

























# Generated PowerShell classes for Female Helmets

# Generated PowerShell classes for Female Helmets
# Assumes BEHelmet class is defined elsewhere (e.g., in EldpriaAlpha.ps1)

Class BEClothHood : BEHelmet {
    BEClothHood() {
        $this.Name               = 'Cloth Hood'
        $this.MapObjName         = 'clothhood'
        $this.PurchasePrice      = 120
        $this.SellPrice          = 60
        $this.TargetGender       = [Gender]::Female
        $this.TargetStats        = @{ [StatId]::Defense = 4; [StatId]::MagicDefense = 3 }
        $this.RequiredStats      = @{ [StatId]::Defense = 2; [StatId]::MagicDefense = 1 }
        $this.ExamineString      = 'A soft cloth hood, offering basic protection with a hint of magic defense.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDEF"
    }
}

Class BEWoodenMask : BEHelmet {
    BEWoodenMask() {
        $this.Name = 'Wooden Mask'
        $this.PurchasePrice = 180
        $this.SellPrice = 90
        $this.DefensivePower = 6
        $this.MagicDefensivePower = 5
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 3
        $this.RequiredMagicDefensivePower = 3
        $this.ExamineString = "A mask carved from light wood, providing a balanced defense."
    }
}

Class BEMithrilHelm : BEHelmet {
    BEMithrilHelm() {
        $this.Name = "Mithril Helm (F)"
        $this.PurchasePrice = 600
        $this.SellPrice = 300
        $this.DefensivePower = 18
        $this.MagicDefensivePower = 5
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 11
        $this.RequiredMagicDefensivePower = 3
        $this.ExamineString = "A light but strong helm made of mithril, offering good defense."
    }
}

Class BEWizardsHat : BEHelmet {
    BEWizardsHat() {
        $this.Name = "Wizard's Hat (F)"
        $this.PurchasePrice = 550
        $this.SellPrice = 275
        $this.DefensivePower = 8
        $this.MagicDefensivePower = 20
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 4
        $this.RequiredMagicDefensivePower = 12
        $this.ExamineString = "A pointed hat favored by spellcasters, offering significant magic defense."
    }
}

Class BERuneHelm : BEHelmet {
    BERuneHelm() {
        $this.Name = "Rune Helm (F)"
        $this.PurchasePrice = 850
        $this.SellPrice = 425
        $this.DefensivePower = 20
        $this.MagicDefensivePower = 18
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 12
        $this.RequiredMagicDefensivePower = 10
        $this.ExamineString = "A helm etched with glowing runes, providing balanced defenses."
    }
}

Class BEShadowHood : BEHelmet {
    BEShadowHood() {
        $this.Name = "Shadow Hood (F)"
        $this.PurchasePrice = 1050
        $this.SellPrice = 525
        $this.DefensivePower = 15
        $this.MagicDefensivePower = 25
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 9
        $this.RequiredMagicDefensivePower = 15
        $this.ExamineString = "A dark hood that blends into shadows, excellent for magic defense."
    }
}

Class BECrystalHelm : BEHelmet {
    BECrystalHelm() {
        $this.Name = "Crystal Helm (F)"
        $this.PurchasePrice = 1400
        $this.SellPrice = 700
        $this.DefensivePower = 25
        $this.MagicDefensivePower = 30
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 15
        $this.RequiredMagicDefensivePower = 18
        $this.ExamineString = "A helm crafted from shimmering crystal, offering strong magical protection."
    }
}

Class BECrownOfWisdom : BEHelmet {
    BECrownOfWisdom() {
        $this.Name = "Crown of Wisdom (F)"
        $this.PurchasePrice = 1600
        $this.SellPrice = 800
        $this.DefensivePower = 18
        $this.MagicDefensivePower = 35
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 10
        $this.RequiredMagicDefensivePower = 21
        $this.ExamineString = "A beautiful crown that enhances the wearer's wisdom and magic defense."
    }
}

Class BEAngelicCirclet : BEHelmet {
    AngelicCirclet() {
        $this.Name = "Angelic Circlet (F)"
        $this.PurchasePrice = 1900
        $this.SellPrice = 950
        $this.DefensivePower = 20
        $this.MagicDefensivePower = 40
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 12
        $this.RequiredMagicDefensivePower = 24
        $this.ExamineString = "A holy circlet radiating a gentle glow, offering strong magic defense."
    }
}

Class BESpiritHood : BEHelmet {
    SpiritHood() {
        $this.Name = "Spirit Hood (F)"
        $this.PurchasePrice = 1850
        $this.SellPrice = 925
        $this.DefensivePower = 12
        $this.MagicDefensivePower = 45
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 7
        $this.RequiredMagicDefensivePower = 27
        $this.ExamineString = "A light hood that channels spiritual energy, providing immense magic defense."
    }
}

Class BECelestialHelm : BEHelmet {
    CelestialHelm() {
        $this.Name = "Celestial Helm (F)"
        $this.PurchasePrice = 2400
        $this.SellPrice = 1200
        $this.DefensivePower = 30
        $this.MagicDefensivePower = 50
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 18
        $this.RequiredMagicDefensivePower = 30
        $this.ExamineString = "A helm imbued with celestial power, offering balanced, powerful defense."
    }
}

Class BEArchmagesHat : BEHelmet {
    ArchmagesHat() {
        $this.Name = "Archmage's Hat (F)"
        $this.PurchasePrice = 2500
        $this.SellPrice = 1250
        $this.DefensivePower = 15
        $this.MagicDefensivePower = 55
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 9
        $this.RequiredMagicDefensivePower = 33
        $this.ExamineString = "The hat of an archmage, granting exceptional magical protection."
    }
}

Class BESorcerersHood : BEHelmet {
    SorcerersHood() {
        $this.Name = "Sorcerer's Hood (F)"
        $this.PurchasePrice = 2700
        $this.SellPrice = 1350
        $this.DefensivePower = 18
        $this.MagicDefensivePower = 60
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 11
        $this.RequiredMagicDefensivePower = 36
        $this.ExamineString = "A hood that amplifies a sorcerer's power, offering superb magic defense."
    }
}

Class BEElementalHelm : BEHelmet {
    ElementalHelm() {
        $this.Name = "Elemental Helm (F)"
        $this.PurchasePrice = 3200
        $this.SellPrice = 1600
        $this.DefensivePower = 40
        $this.MagicDefensivePower = 65
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 24
        $this.RequiredMagicDefensivePower = 39
        $this.ExamineString = "A helm infused with elemental forces, providing potent defense."
    }
}

Class BEOraclesCrown : BEHelmet {
    OraclesCrown() {
        $this.Name = "Oracle's Crown (F)"
        $this.PurchasePrice = 3300
        $this.SellPrice = 1650
        $this.DefensivePower = 20
        $this.MagicDefensivePower = 70
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 12
        $this.RequiredMagicDefensivePower = 42
        $this.ExamineString = "A prophetic crown, granting incredible magic defense and foresight."
    }
}

Class BEWarlocksVisage : BEHelmet {
    WarlocksVisage() {
        $this.Name = "Warlock's Visage (F)"
        $this.PurchasePrice = 3600
        $this.SellPrice = 1800
        $this.DefensivePower = 22
        $this.MagicDefensivePower = 75
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 13
        $this.RequiredMagicDefensivePower = 45
        $this.ExamineString = "A dark and powerful visage, offering formidable magic defense."
    }
}

Class BEMythicHelm : BEHelmet {
    MythicHelm() {
        $this.Name = "Mythic Helm (F)"
        $this.PurchasePrice = 4200
        $this.SellPrice = 2100
        $this.DefensivePower = 50
        $this.MagicDefensivePower = 80
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 30
        $this.RequiredMagicDefensivePower = 48
        $this.ExamineString = "A helm from ancient myths, providing legendary defensive power."
    }
}

Class BEGrandSorcerersHat : BEHelmet {
    GrandSorcerersHat() {
        $this.Name = "Grand Sorcerer's Hat (F)"
        $this.PurchasePrice = 4300
        $this.SellPrice = 2150
        $this.DefensivePower = 25
        $this.MagicDefensivePower = 85
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 15
        $this.RequiredMagicDefensivePower = 51
        $this.ExamineString = "The pinnacle of sorcerous headwear, offering supreme magic defense."
    }
}

Class BEEldersHood : BEHelmet {
    EldersHood() {
        $this.Name = "Elder's Hood (F)"
        $this.PurchasePrice = 4600
        $this.SellPrice = 2300
        $this.DefensivePower = 28
        $this.MagicDefensivePower = 90
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 17
        $this.RequiredMagicDefensivePower = 54
        $this.ExamineString = "A wise elder's hood, immeasurably boosting magical resistance."
    }
}

Class BEAstralHelm : BEHelmet {
    AstralHelm() {
        $this.Name = "Astral Helm (F)"
        $this.PurchasePrice = 5200
        $this.SellPrice = 2600
        $this.DefensivePower = 55
        $this.MagicDefensivePower = 95
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 33
        $this.RequiredMagicDefensivePower = 57
        $this.ExamineString = "A helm connected to the astral plane, offering extraordinary defense."
    }
}

Class BEStarSeersTiara : BEHelmet {
    StarSeersTiara() {
        $this.Name = "Star Seer's Tiara (F)"
        $this.PurchasePrice = 5300
        $this.SellPrice = 2650
        $this.DefensivePower = 30
        $this.MagicDefensivePower = 100
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 18
        $this.RequiredMagicDefensivePower = 60
        $this.ExamineString = "A tiara that grants glimpses of the stars, providing ultimate magic defense."
    }
}

Class BEMysticHood : BEHelmet {
    MysticHood() {
        $this.Name = "Mystic Hood (F)"
        $this.PurchasePrice = 5600
        $this.SellPrice = 2800
        $this.DefensivePower = 32
        $this.MagicDefensivePower = 105
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 19
        $this.RequiredMagicDefensivePower = 63
        $this.ExamineString = "A hood woven with mystic threads, enhancing magical resistance."
    }
}

Class BEChaosHelm : BEHelmet {
    ChaosHelm() {
        $this.Name = "Chaos Helm (F)"
        $this.PurchasePrice = 6200
        $this.SellPrice = 3100
        $this.DefensivePower = 60
        $this.MagicDefensivePower = 110
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 36
        $this.RequiredMagicDefensivePower = 66
        $this.ExamineString = "A chaotic helm, offering unpredictable yet potent defense."
    }
}

Class BESagesHeadband : BEHelmet {
    SagesHeadband() {
        $this.Name = "Sage's Headband (F)"
        $this.PurchasePrice = 6300
        $this.SellPrice = 3150
        $this.DefensivePower = 35
        $this.MagicDefensivePower = 115
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 21
        $this.RequiredMagicDefensivePower = 69
        $this.ExamineString = "A simple headband worn by sages, providing immense magical protection."
    }
}

Class BELichsPhylactery : BEHelmet {
    LichsPhylactery() {
        $this.Name = "Lich's Phylactery (F)"
        $this.PurchasePrice = 6600
        $this.SellPrice = 3300
        $this.DefensivePower = 38
        $this.MagicDefensivePower = 120
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 22
        $this.RequiredMagicDefensivePower = 72
        $this.ExamineString = "A horrifying yet powerful phylactery, granting unholy magical defense."
    }
}

Class BECosmicHelm : BEHelmet {
    CosmicHelm() {
        $this.Name = "Cosmic Helm (F)"
        $this.PurchasePrice = 7200
        $this.SellPrice = 3600
        $this.DefensivePower = 65
        $this.MagicDefensivePower = 125
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 39
        $this.RequiredMagicDefensivePower = 75
        $this.ExamineString = "A helm imbued with cosmic energy, offering universal defense."
    }
}

Class BEVisionarysDiadem : BEHelmet {
    VisionarysDiadem() {
        $this.Name = "Visionary's Diadem (F)"
        $this.PurchasePrice = 7300
        $this.SellPrice = 3650
        $this.DefensivePower = 40
        $this.MagicDefensivePower = 130
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 24
        $this.RequiredMagicDefensivePower = 78
        $this.ExamineString = "A diadem that grants profound visions, providing exceptional magic defense."
    }
}

Class BEArcaneCirclet : BEHelmet {
    ArcaneCirclet() {
        $this.Name = "Arcane Circlet (F)"
        $this.PurchasePrice = 7600
        $this.SellPrice = 3800
        $this.DefensivePower = 42
        $this.MagicDefensivePower = 135
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 25
        $this.RequiredMagicDefensivePower = 81
        $this.ExamineString = "A circlet pulsating with arcane power, offering superior magic defense."
    }
}

Class BESpectralHood : BEHelmet {
    SpectralHood() {
        $this.Name = "Spectral Hood (F)"
        $this.PurchasePrice = 7800
        $this.SellPrice = 3900
        $this.DefensivePower = 45
        $this.MagicDefensivePower = 140
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 27
        $this.RequiredMagicDefensivePower = 84
        $this.ExamineString = "A ghostly hood that phases through attacks, providing excellent magic defense."
    }
}

Class BESpiritWeaversCrown : BEHelmet {
    SpiritWeaversCrown() {
        $this.Name = "Spirit Weaver's Crown (F)"
        $this.PurchasePrice = 8300
        $this.SellPrice = 4150
        $this.DefensivePower = 48
        $this.MagicDefensivePower = 145
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 28
        $this.RequiredMagicDefensivePower = 87
        $this.ExamineString = "A crown worn by spirit weavers, offering profound spiritual protection."
    }
}

Class BEEnchantedCirclet : BEHelmet {
    EnchantedCirclet() {
        $this.Name = "Enchanted Circlet (F)"
        $this.PurchasePrice = 8600
        $this.SellPrice = 4300
        $this.DefensivePower = 50
        $this.MagicDefensivePower = 150
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 30
        $this.RequiredMagicDefensivePower = 90
        $this.ExamineString = "A masterfully enchanted circlet, offering unparalleled magical resistance."
    }
}

Class BEShadowWhisperHood : BEHelmet {
    ShadowWhisperHood() {
        $this.Name = "Shadow Whisper Hood (F)"
        $this.PurchasePrice = 8800
        $this.SellPrice = 4400
        $this.DefensivePower = 52
        $this.MagicDefensivePower = 155
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 31
        $this.RequiredMagicDefensivePower = 93
        $this.ExamineString = "A hood that muffles whispers of shadows, providing incredible magic defense."
    }
}

Class BEDreamWeaversTiara : BEHelmet {
    DreamWeaversTiara() {
        $this.Name = "Dream Weaver's Tiara (F)"
        $this.PurchasePrice = 9300
        $this.SellPrice = 4650
        $this.DefensivePower = 55
        $this.MagicDefensivePower = 160
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 33
        $this.RequiredMagicDefensivePower = 96
        $this.ExamineString = "A tiara that weaves dreams into reality, offering exceptional protection."
    }
}

Class BEMysticDreamcatcher : BEHelmet {
    MysticDreamcatcher() {
        $this.Name = "Mystic Dreamcatcher (F)"
        $this.PurchasePrice = 9600
        $this.SellPrice = 4800
        $this.DefensivePower = 58
        $this.MagicDefensivePower = 165
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 34
        $this.RequiredMagicDefensivePower = 99
        $this.ExamineString = "A delicate yet powerful dreamcatcher, guarding against magical onslaughts."
    }
}

Class BEDarkstoneHelm : BEHelmet {
    DarkstoneHelm() {
        $this.Name = "Darkstone Helm (F)"
        $this.PurchasePrice = 9800
        $this.SellPrice = 4900
        $this.DefensivePower = 60
        $this.MagicDefensivePower = 170
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 36
        $this.RequiredMagicDefensivePower = 102
        $this.ExamineString = "A helm crafted from darkstone, absorbing hostile magic."
    }
}

Class BESoulboundHelm : BEHelmet {
    SoulboundHelm() {
        $this.Name = "Soulbound Helm (F)"
        $this.PurchasePrice = 10300
        $this.SellPrice = 5150
        $this.DefensivePower = 62
        $this.MagicDefensivePower = 175
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 37
        $this.RequiredMagicDefensivePower = 105
        $this.ExamineString = "A helm bound to the wearer's soul, sharing its resilience."
    }
}

Class BEChronosHelm : BEHelmet {
    ChronosHelm() {
        $this.Name = "Chronos Helm (F)"
        $this.PurchasePrice = 10600
        $this.SellPrice = 5300
        $this.DefensivePower = 65
        $this.MagicDefensivePower = 180
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 39
        $this.RequiredMagicDefensivePower = 108
        $this.ExamineString = "A helm that bends time to its wearer's will, offering supreme defense."
    }
}

Class BEAetherialHood : BEHelmet {
    AetherialHood() {
        $this.Name = "Aetherial Hood (F)"
        $this.PurchasePrice = 10800
        $this.SellPrice = 5400
        $this.DefensivePower = 68
        $this.MagicDefensivePower = 185
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 40
        $this.RequiredMagicDefensivePower = 111
        $this.ExamineString = "A hood woven from aether, providing ethereal protection."
    }
}

Class BEStarlightTiara : BEHelmet {
    StarlightTiara() {
        $this.Name = "Starlight Tiara (F)"
        $this.PurchasePrice = 11300
        $this.SellPrice = 5650
        $this.DefensivePower = 70
        $this.MagicDefensivePower = 190
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 42
        $this.RequiredMagicDefensivePower = 114
        $this.ExamineString = "A tiara glittering with starlight, offering celestial protection."
    }
}

Class BESeraphicCirclet : BEHelmet {
    SeraphicCirclet() {
        $this.Name = "Seraphic Circlet (F)"
        $this.PurchasePrice = 11600
        $this.SellPrice = 5800
        $this.DefensivePower = 72
        $this.MagicDefensivePower = 195
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 43
        $this.RequiredMagicDefensivePower = 117
        $this.ExamineString = "A circlet of angelic origins, offering divine magical defense."
    }
}

Class BENightshadeHood : BEHelmet {
    NightshadeHood() {
        $this.Name = "Nightshade Hood (F)"
        $this.PurchasePrice = 11800
        $this.SellPrice = 5900
        $this.DefensivePower = 75
        $this.MagicDefensivePower = 200
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 45
        $this.RequiredMagicDefensivePower = 120
        $this.ExamineString = "A hood that thrives in darkness, providing formidable magic defense."
    }
}

Class BESpiritGuardiansCrown : BEHelmet {
    SpiritGuardiansCrown() {
        $this.Name = "Spirit Guardian's Crown (F)"
        $this.PurchasePrice = 12300
        $this.SellPrice = 6150
        $this.DefensivePower = 78
        $this.MagicDefensivePower = 205
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 46
        $this.RequiredMagicDefensivePower = 123
        $this.ExamineString = "A crown that summons spirit guardians, offering profound protection."
    }
}

Class BEArcaneSentinelHelm : BEHelmet {
    ArcaneSentinelHelm() {
        $this.Name = "Arcane Sentinel Helm (F)"
        $this.PurchasePrice = 12600
        $this.SellPrice = 6300
        $this.DefensivePower = 80
        $this.MagicDefensivePower = 210
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 48
        $this.RequiredMagicDefensivePower = 126
        $this.ExamineString = "A helm acting as an arcane sentinel, providing exceptional magical defense."
    }
}

Class BEWhisperingHood : BEHelmet {
    WhisperingHood() {
        $this.Name = "Whispering Hood (F)"
        $this.PurchasePrice = 12800
        $this.SellPrice = 6400
        $this.DefensivePower = 82
        $this.MagicDefensivePower = 215
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 49
        $this.RequiredMagicDefensivePower = 129
        $this.ExamineString = "A hood that whispers secrets, providing potent magical resistance."
    }
}

Class BESoulHarvestHelm : BEHelmet {
    SoulHarvestHelm() {
        $this.Name = "Soul Harvest Helm (F)"
        $this.PurchasePrice = 13300
        $this.SellPrice = 6650
        $this.DefensivePower = 85
        $this.MagicDefensivePower = 220
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 51
        $this.RequiredMagicDefensivePower = 132
        $this.ExamineString = "A helm that draws power from souls, offering immense magical defense."
    }
}

Class BECosmicWanderersHood : BEHelmet {
    CosmicWanderersHood() {
        $this.Name = "Cosmic Wanderer's Hood (F)"
        $this.PurchasePrice = 13600
        $this.SellPrice = 6800
        $this.DefensivePower = 88
        $this.MagicDefensivePower = 225
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 52
        $this.RequiredMagicDefensivePower = 135
        $this.ExamineString = "A hood worn by cosmic wanderers, providing boundless magical protection."
    }
}

Class BEShadowfellHelm : BEHelmet {
    ShadowfellHelm() {
        $this.Name = "Shadowfell Helm (F)"
        $this.PurchasePrice = 13800
        $this.SellPrice = 6900
        $this.DefensivePower = 90
        $this.MagicDefensivePower = 230
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 54
        $this.RequiredMagicDefensivePower = 138
        $this.ExamineString = "A helm from the shadowy realms, offering formidable resistance."
    }
}

Class BETrueSightHelm : BEHelmet {
    TrueSightHelm() {
        $this.Name = "True Sight Helm (F)"
        $this.PurchasePrice = 14300
        $this.SellPrice = 7150
        $this.DefensivePower = 92
        $this.MagicDefensivePower = 235
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 55
        $this.RequiredMagicDefensivePower = 141
        $this.ExamineString = "A helm that grants true sight, protecting against illusions and magic."
    }
}

Class BEArcaneOmniHelm : BEHelmet {
    ArcaneOmniHelm() {
        $this.Name = "Arcane Omni-Helm (F)"
        $this.PurchasePrice = 14600
        $this.SellPrice = 7300
        $this.DefensivePower = 95
        $this.MagicDefensivePower = 240
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 57
        $this.RequiredMagicDefensivePower = 144
        $this.ExamineString = "A helm that defends against all forms of arcane attack."
    }
}

Class BEVoidreaversHood : BEHelmet {
    VoidreaversHood() {
        $this.Name = "Voidreaver's Hood (F)"
        $this.PurchasePrice = 14800
        $this.SellPrice = 7400
        $this.DefensivePower = 98
        $this.MagicDefensivePower = 245
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 58
        $this.RequiredMagicDefensivePower = 147
        $this.ExamineString = "A hood that reaves the void, offering ultimate magic defense."
    }
}

Class BEStarforgedHelm : BEHelmet {
    StarforgedHelm() {
        $this.Name = "Starforged Helm (F)"
        $this.PurchasePrice = 15300
        $this.SellPrice = 7650
        $this.DefensivePower = 100
        $this.MagicDefensivePower = 250
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 60
        $this.RequiredMagicDefensivePower = 150
        $this.ExamineString = "A helm forged from compressed starlight, offering unparalleled defense."
    }
}

Class BEMysticVeil : BEHelmet {
    MysticVeil() {
        $this.Name = "Mystic Veil (F)"
        $this.PurchasePrice = 400
        $this.SellPrice = 200
        $this.DefensivePower = 7
        $this.MagicDefensivePower = 10
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 4
        $this.RequiredMagicDefensivePower = 6
        $this.ExamineString = "A light veil imbued with minor mystic protections."
    }
}

Class BESeersCirclet : BEHelmet {
    SeersCirclet() {
        $this.Name = "Seer's Circlet (F)"
        $this.PurchasePrice = 950
        $this.SellPrice = 475
        $this.DefensivePower = 12
        $this.MagicDefensivePower = 28
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 7
        $this.RequiredMagicDefensivePower = 16
        $this.ExamineString = "A delicate circlet that amplifies a seer's intuition and magic defense."
    }
}

Class BEEnchantressHat : BEHelmet {
    EnchantressHat() {
        $this.Name = "Enchantress Hat (F)"
        $this.PurchasePrice = 1500
        $this.SellPrice = 750
        $this.DefensivePower = 18
        $this.MagicDefensivePower = 38
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 10
        $this.RequiredMagicDefensivePower = 22
        $this.ExamineString = "A stylish hat favored by enchantresses, offering good magical protection."
    }
}

Class BESylvaniCrown : BEHelmet {
    SylvaniCrown() {
        $this.Name = "Sylvani Crown (F)"
        $this.PurchasePrice = 2100
        $this.SellPrice = 1050
        $this.DefensivePower = 22
        $this.MagicDefensivePower = 48
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 13
        $this.RequiredMagicDefensivePower = 28
        $this.ExamineString = "A crown woven from forest vines, providing natural magical resistance."
    }
}

Class BEMoonpetalCirclet : BEHelmet {
    MoonpetalCirclet() {
        $this.Name = "Moonpetal Circlet (F)"
        $this.PurchasePrice = 2700
        $this.SellPrice = 1350
        $this.DefensivePower = 28
        $this.MagicDefensivePower = 58
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 16
        $this.RequiredMagicDefensivePower = 34
        $this.ExamineString = "A circlet adorned with moonpetals, offering significant magic defense."
    }
}

Class BEStardustVeil : BEHelmet {
    StardustVeil() {
        $this.Name = "Stardust Veil (F)"
        $this.PurchasePrice = 3400
        $this.SellPrice = 1700
        $this.DefensivePower = 32
        $this.MagicDefensivePower = 68
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 19
        $this.RequiredMagicDefensivePower = 40
        $this.ExamineString = "A veil woven from stardust, providing celestial magical protection."
    }
}

Class BEAuroraHelm : BEHelmet {
    AuroraHelm() {
        $this.Name = "Aurora Helm (F)"
        $this.PurchasePrice = 4100
        $this.SellPrice = 2050
        $this.DefensivePower = 38
        $this.MagicDefensivePower = 78
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 22
        $this.RequiredMagicDefensivePower = 46
        $this.ExamineString = "A helm shimmering with aurora lights, offering potent magic defense."
    }
}

Class BEGemstoneTiara : BEHelmet {
    GemstoneTiara() {
        $this.Name = "Gemstone Tiara (F)"
        $this.PurchasePrice = 4900
        $this.SellPrice = 2450
        $this.DefensivePower = 42
        $this.MagicDefensivePower = 88
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 25
        $this.RequiredMagicDefensivePower = 52
        $this.ExamineString = "A tiara embedded with rare gemstones, amplifying magical resistance."
    }
}

Class BESoulfireHood : BEHelmet {
    SoulfireHood() {
        $this.Name = "Soulfire Hood (F)"
        $this.PurchasePrice = 5600
        $this.SellPrice = 2800
        $this.DefensivePower = 48
        $this.MagicDefensivePower = 98
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 28
        $this.RequiredMagicDefensivePower = 58
        $this.ExamineString = "A hood radiating soulfire, offering incredible magical protection."
    }
}

Class BEOraclesEmbrace : BEHelmet {
    OraclesEmbrace() {
        $this.Name = "Oracle's Embrace (F)"
        $this.PurchasePrice = 6400
        $this.SellPrice = 3200
        $this.DefensivePower = 52
        $this.MagicDefensivePower = 108
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 31
        $this.RequiredMagicDefensivePower = 64
        $this.ExamineString = "A helm that feels like an oracle's embrace, providing profound defense."
    }
}

Class BEDreamersBand : BEHelmet {
    DreamersBand() {
        $this.Name = "Dreamer's Band (F)"
        $this.PurchasePrice = 7100
        $this.SellPrice = 3550
        $this.DefensivePower = 58
        $this.MagicDefensivePower = 118
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 34
        $this.RequiredMagicDefensivePower = 70
        $this.ExamineString = "A simple band worn by dreamers, offering vast magical resilience."
    }
}

Class BESkyweaverHood : BEHelmet {
    SkyweaverHood() {
        $this.Name = "Skyweaver Hood (F)"
        $this.PurchasePrice = 7900
        $this.SellPrice = 3950
        $this.DefensivePower = 62
        $this.MagicDefensivePower = 128
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 37
        $this.RequiredMagicDefensivePower = 76
        $this.ExamineString = "A hood woven from sky threads, providing an ethereal defense."
    }
}

Class BECrystalBloomTiara : BEHelmet {
    CrystalBloomTiara() {
        $this.Name = "Crystal Bloom Tiara (F)"
        $this.PurchasePrice = 8700
        $this.SellPrice = 4350
        $this.DefensivePower = 68
        $this.MagicDefensivePower = 138
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 40
        $this.RequiredMagicDefensivePower = 82
        $this.ExamineString = "A tiara blooming with crystal flowers, offering strong magic defense."
    }
}

Class BEPhantomVeil : BEHelmet {
    PhantomVeil() {
        $this.Name = "Phantom Veil (F)"
        $this.PurchasePrice = 9400
        $this.SellPrice = 4700
        $this.DefensivePower = 72
        $this.MagicDefensivePower = 148
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 43
        $this.RequiredMagicDefensivePower = 88
        $this.ExamineString = "A veil that appears and disappears, providing elusive magical protection."
    }
}

Class BEEmpressCrown : BEHelmet {
    EmpressCrown() {
        $this.Name = "Empress Crown (F)"
        $this.PurchasePrice = 10200
        $this.SellPrice = 5100
        $this.DefensivePower = 78
        $this.MagicDefensivePower = 158
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 46
        $this.RequiredMagicDefensivePower = 94
        $this.ExamineString = "A majestic crown fit for an empress, offering supreme magical defense."
    }
}

Class BESerenityCirclet : BEHelmet {
    SerenityCirclet() {
        $this.Name = "Serenity Circlet (F)"
        $this.PurchasePrice = 10900
        $this.SellPrice = 5450
        $this.DefensivePower = 82
        $this.MagicDefensivePower = 168
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 49
        $this.RequiredMagicDefensivePower = 100
        $this.ExamineString = "A circlet that instills serenity, providing complete magical resistance."
    }
}

Class BEMoonlitVeil : BEHelmet {
    MoonlitVeil() {
        $this.Name = "Moonlit Veil (F)"
        $this.PurchasePrice = 11600
        $this.SellPrice = 5800
        $this.DefensivePower = 88
        $this.MagicDefensivePower = 178
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 52
        $this.RequiredMagicDefensivePower = 106
        $this.ExamineString = "A veil kissed by moonlight, offering profound magical protection."
    }
}

Class BEDivineOracleTiara : BEHelmet {
    DivineOracleTiara() {
        $this.Name = "Divine Oracle Tiara (F)"
        $this.PurchasePrice = 12300
        $this.SellPrice = 6150
        $this.DefensivePower = 92
        $this.MagicDefensivePower = 188
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 55
        $this.RequiredMagicDefensivePower = 112
        $this.ExamineString = "A tiara blessed by divine oracles, providing exceptional magical defense."
    }
}

Class BEWhisperwindHood : BEHelmet {
    WhisperwindHood() {
        $this.Name = "Whisperwind Hood (F)"
        $this.PurchasePrice = 13000
        $this.SellPrice = 6500
        $this.DefensivePower = 98
        $this.MagicDefensivePower = 198
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 58
        $this.RequiredMagicDefensivePower = 118
        $this.ExamineString = "A hood that captures the whisper of winds, offering subtle yet strong defense."
    }
}

Class BEStarlightWeaver : BEHelmet {
    StarlightWeaver() {
        $this.Name = "Starlight Weaver (F)"
        $this.PurchasePrice = 13700
        $this.SellPrice = 6850
        $this.DefensivePower = 102
        $this.MagicDefensivePower = 208
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 61
        $this.RequiredMagicDefensivePower = 124
        $this.ExamineString = "A helm woven from starlight, providing an ethereal yet robust defense."
    }
}

Class BECelestialGraceHelm : BEHelmet {
    CelestialGraceHelm() {
        $this.Name = "Celestial Grace Helm (F)"
        $this.PurchasePrice = 14400
        $this.SellPrice = 7200
        $this.DefensivePower = 108
        $this.MagicDefensivePower = 218
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 64
        $this.RequiredMagicDefensivePower = 130
        $this.ExamineString = "A helm radiating celestial grace, offering divine magical resistance."
    }
}

Class BEDreamcatcherCirclet : BEHelmet {
    DreamcatcherCirclet() {
        $this.Name = "Dreamcatcher Circlet (F)"
        $this.PurchasePrice = 15100
        $this.SellPrice = 7550
        $this.DefensivePower = 112
        $this.MagicDefensivePower = 228
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 67
        $this.RequiredMagicDefensivePower = 136
        $this.ExamineString = "A circlet that captures nightmares, providing unparalleled magic defense."
    }
}

Class BESpiritBlossomVeil : BEHelmet {
    SpiritBlossomVeil() {
        $this.Name = "Spirit Blossom Veil (F)"
        $this.PurchasePrice = 15800
        $this.SellPrice = 7900
        $this.DefensivePower = 118
        $this.MagicDefensivePower = 238
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 70
        $this.RequiredMagicDefensivePower = 142
        $this.ExamineString = "A veil blooming with spirit energy, offering profound spiritual protection."
    }
}

Class BEEnchantedEmpressCrown : BEHelmet {
    EnchantedEmpressCrown() {
        $this.Name = "Enchanted Empress Crown (F)"
        $this.PurchasePrice = 16500
        $this.SellPrice = 8250
        $this.DefensivePower = 122
        $this.MagicDefensivePower = 248
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 73
        $this.RequiredMagicDefensivePower = 148
        $this.ExamineString = "An ancient, powerful crown worn by legendary empresses."
    }
}

Class BELunarPriestessHood : BEHelmet {
    LunarPriestessHood() {
        $this.Name = "Lunar Priestess Hood (F)"
        $this.PurchasePrice = 17200
        $this.SellPrice = 8600
        $this.DefensivePower = 128
        $this.MagicDefensivePower = 258
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 76
        $this.RequiredMagicDefensivePower = 154
        $this.ExamineString = "A hood of a lunar priestess, channeling the moon's magical power."
    }
}

Class BESunstoneWeaverTiara : BEHelmet {
    SunstoneWeaverTiara() {
        $this.Name = "Sunstone Weaver Tiara (F)"
        $this.PurchasePrice = 17900
        $this.SellPrice = 8950
        $this.DefensivePower = 132
        $this.MagicDefensivePower = 268
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 79
        $this.RequiredMagicDefensivePower = 160
        $this.ExamineString = "A tiara woven with sunstones, offering brilliant magical resistance."
    }
}

Class BEShadowBloomVeil : BEHelmet {
    ShadowBloomVeil() {
        $this.Name = "Shadow Bloom Veil (F)"
        $this.PurchasePrice = 18600
        $this.SellPrice = 9300
        $this.DefensivePower = 138
        $this.MagicDefensivePower = 278
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 82
        $this.RequiredMagicDefensivePower = 166
        $this.ExamineString = "A veil blooming in shadows, providing potent magical protection."
    }
}

Class BEGoddesssFavorHelm : BEHelmet {
    GoddesssFavorHelm() {
        $this.Name = "Goddess's Favor Helm (F)"
        $this.PurchasePrice = 19300
        $this.SellPrice = 9650
        $this.DefensivePower = 142
        $this.MagicDefensivePower = 288
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 85
        $this.RequiredMagicDefensivePower = 172
        $this.ExamineString = "A helm bestowed by a goddess, granting ultimate magical defense."
    }
}

Class BECosmicDreamerCirclet : BEHelmet {
    CosmicDreamerCirclet() {
        $this.Name = "Cosmic Dreamer Circlet (F)"
        $this.PurchasePrice = 20000
        $this.SellPrice = 10000
        $this.DefensivePower = 148
        $this.MagicDefensivePower = 298
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 88
        $this.RequiredMagicDefensivePower = 178
        $this.ExamineString = "A circlet that taps into cosmic dreams, offering boundless protection."
    }
}

Class BESoulSirenTiara : BEHelmet {
    SoulSirenTiara() {
        $this.Name = "Soul Siren Tiara (F)"
        $this.PurchasePrice = 20700
        $this.SellPrice = 10350
        $this.DefensivePower = 152
        $this.MagicDefensivePower = 308
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 91
        $this.RequiredMagicDefensivePower = 184
        $this.ExamineString = "A tiara resonating with siren songs, offering enchanting defense."
    }
}

Class BEStarlightOracleHood : BEHelmet {
    StarlightOracleHood() {
        $this.Name = "Starlight Oracle Hood (F)"
        $this.PurchasePrice = 21400
        $this.SellPrice = 10700
        $this.DefensivePower = 158
        $this.MagicDefensivePower = 318
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 94
        $this.RequiredMagicDefensivePower = 190
        $this.ExamineString = "A hood worn by starlight oracles, offering supreme magical insights."
    }
}

Class BECelestialSeraphHelm : BEHelmet {
    CelestialSeraphHelm() {
        $this.Name = "Celestial Seraph Helm (F)"
        $this.PurchasePrice = 22100
        $this.SellPrice = 11050
        $this.DefensivePower = 162
        $this.MagicDefensivePower = 328
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 97
        $this.RequiredMagicDefensivePower = 196
        $this.ExamineString = "A helm from the celestial seraphim, offering divine protection."
    }
}

Class BEMysticSpiritCrown : BEHelmet {
    MysticSpiritCrown() {
        $this.Name = "Mystic Spirit Crown (F)"
        $this.PurchasePrice = 22800
        $this.SellPrice = 11400
        $this.DefensivePower = 168
        $this.MagicDefensivePower = 338
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 100
        $this.RequiredMagicDefensivePower = 202
        $this.ExamineString = "A crown that channels mystic spirits, providing incredible defense."
    }
}

Class BERadiantEmpressTiara : BEHelmet {
    RadiantEmpressTiara() {
        $this.Name = "Radiant Empress Tiara (F)"
        $this.PurchasePrice = 23500
        $this.SellPrice = 11750
        $this.DefensivePower = 172
        $this.MagicDefensivePower = 348
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 103
        $this.RequiredMagicDefensivePower = 208
        $this.ExamineString = "A tiara of a radiant empress, shining with immense protective power."
    }
}

Class BELunarShadowHood : BEHelmet {
    LunarShadowHood() {
        $this.Name = "Lunar Shadow Hood (F)"
        $this.PurchasePrice = 24200
        $this.SellPrice = 12100
        $this.DefensivePower = 178
        $this.MagicDefensivePower = 358
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 106
        $this.RequiredMagicDefensivePower = 214
        $this.ExamineString = "A hood that draws power from lunar shadows, offering deep magical defense."
    }
}

Class BEDivineBlossomHelm : BEHelmet {
    DivineBlossomHelm() {
        $this.Name = "Divine Blossom Helm (F)"
        $this.PurchasePrice = 24900
        $this.SellPrice = 12450
        $this.DefensivePower = 182
        $this.MagicDefensivePower = 368
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 109
        $this.RequiredMagicDefensivePower = 220
        $this.ExamineString = "A helm blooming with divine energy, providing profound protection."
    }
}

Class BEAetherialDreamTiara : BEHelmet {
    AetherialDreamTiara() {
        $this.Name = "Aetherial Dream Tiara (F)"
        $this.PurchasePrice = 25600
        $this.SellPrice = 12800
        $this.DefensivePower = 188
        $this.MagicDefensivePower = 378
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 112
        $this.RequiredMagicDefensivePower = 226
        $this.ExamineString = "A tiara that weaves aetherial dreams, offering boundless magical defense."
    }
}

Class BEEmpresssWhisper : BEHelmet {
    EmpresssWhisper() {
        $this.Name = "Empress's Whisper (F)"
        $this.PurchasePrice = 26300
        $this.SellPrice = 13150
        $this.DefensivePower = 192
        $this.MagicDefensivePower = 388
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 115
        $this.RequiredMagicDefensivePower = 232
        $this.ExamineString = "A helm that echoes an empress's whisper, granting subtle but immense power."
    }
}

Class BEStarweaverCrown : BEHelmet {
    StarweaverCrown() {
        $this.Name = "Starweaver Crown (F)"
        $this.PurchasePrice = 27000
        $this.SellPrice = 13500
        $this.DefensivePower = 198
        $this.MagicDefensivePower = 398
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 118
        $this.RequiredMagicDefensivePower = 238
        $this.ExamineString = "A crown that weaves the fabric of starlight, offering supreme defense."
    }
}

Class BECelestialOracleHelm : BEHelmet {
    CelestialOracleHelm() {
        $this.Name = "Celestial Oracle Helm (F)"
        $this.PurchasePrice = 27700
        $this.SellPrice = 13850
        $this.DefensivePower = 202
        $this.MagicDefensivePower = 408
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 121
        $this.RequiredMagicDefensivePower = 244
        $this.ExamineString = "A helm of the celestial oracle, providing divine insights and protection."
    }
}

Class BEDreamWeaversVisage : BEHelmet {
    DreamWeaversVisage() {
        $this.Name = "Dream Weaver's Visage (F)"
        $this.PurchasePrice = 28400
        $this.SellPrice = 14200
        $this.DefensivePower = 208
        $this.MagicDefensivePower = 418
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 124
        $this.RequiredMagicDefensivePower = 250
        $this.ExamineString = "A visage that embodies dreams, offering unparalleled magical defense."
    }
}

Class BELunarSeraphimTiara : BEHelmet {
    LunarSeraphimTiara() {
        $this.Name = "Lunar Seraphim Tiara (F)"
        $this.PurchasePrice = 29100
        $this.SellPrice = 14550
        $this.DefensivePower = 212
        $this.MagicDefensivePower = 428
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 127
        $this.RequiredMagicDefensivePower = 256
        $this.ExamineString = "A tiara worn by lunar seraphim, radiating heavenly protection."
    }
}

Class BESoulSeekerHelm : BEHelmet {
    SoulSeekerHelm() {
        $this.Name = "Soul Seeker Helm (F)"
        $this.PurchasePrice = 29800
        $this.SellPrice = 14900
        $this.DefensivePower = 218
        $this.MagicDefensivePower = 438
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 130
        $this.RequiredMagicDefensivePower = 262
        $this.ExamineString = "A helm that seeks out souls, offering formidable magical defense."
    }
}

Class BERadiantSpiritHood : BEHelmet {
    RadiantSpiritHood() {
        $this.Name = "Radiant Spirit Hood (F)"
        $this.PurchasePrice = 30500
        $this.SellPrice = 15250
        $this.DefensivePower = 222
        $this.MagicDefensivePower = 448
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 133
        $this.RequiredMagicDefensivePower = 268
        $this.ExamineString = "A hood shimmering with radiant spirits, providing immense magical protection."
    }
}

Class BEEmpressOfLightCrown : BEHelmet {
    EmpressOfLightCrown() {
        $this.Name = "Empress of Light Crown (F)"
        $this.PurchasePrice = 31200
        $this.SellPrice = 15600
        $this.DefensivePower = 228
        $this.MagicDefensivePower = 458
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 136
        $this.RequiredMagicDefensivePower = 274
        $this.ExamineString = "The crown of the Empress of Light, embodying pure defensive power."
    }
}

Class BEVoidWeaversTiara : BEHelmet {
    VoidWeaversTiara() {
        $this.Name = "Void Weaver's Tiara (F)"
        $this.PurchasePrice = 31900
        $this.SellPrice = 15950
        $this.DefensivePower = 232
        $this.MagicDefensivePower = 468
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 139
        $this.RequiredMagicDefensivePower = 280
        $this.ExamineString = "A tiara that weaves the void, offering ultimate magical resilience."
    }
}

Class BEStarBlossomHelm : BEHelmet {
    StarBlossomHelm() {
        $this.Name = "Star Blossom Helm (F)"
        $this.PurchasePrice = 32600
        $this.SellPrice = 16300
        $this.DefensivePower = 238
        $this.MagicDefensivePower = 478
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 142
        $this.RequiredMagicDefensivePower = 286
        $this.ExamineString = "A helm blossoming with starlight, offering celestial protection."
    }
}

Class BECosmicEchoHelm : BEHelmet {
    CosmicEchoHelm() {
        $this.Name = "Cosmic Echo Helm (F)"
        $this.PurchasePrice = 33300
        $this.SellPrice = 16650
        $this.DefensivePower = 242
        $this.MagicDefensivePower = 488
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 145
        $this.RequiredMagicDefensivePower = 292
        $this.ExamineString = "A helm that echoes cosmic energies, providing profound magical defense."
    }
}

Class BEDivineSeerCrown : BEHelmet {
    DivineSeerCrown() {
        $this.Name = "Divine Seer Crown (F)"
        $this.PurchasePrice = 34000
        $this.SellPrice = 17000
        $this.DefensivePower = 248
        $this.MagicDefensivePower = 498
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 148
        $this.RequiredMagicDefensivePower = 298
        $this.ExamineString = "A crown of the divine seer, granting ultimate magical insights and defense."
    }
}

Class BEMoonstoneEmpressHelm : BEHelmet {
    MoonstoneEmpressHelm() {
        $this.Name = "Moonstone Empress Helm (F)"
        $this.PurchasePrice = 34700
        $this.SellPrice = 17350
        $this.DefensivePower = 252
        $this.MagicDefensivePower = 508
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 151
        $this.RequiredMagicDefensivePower = 304
        $this.ExamineString = "A helm crafted from moonstone, providing incredible lunar protection."
    }
}

Class BESpectralEnchantressHood : BEHelmet {
    SpectralEnchantressHood() {
        $this.Name = "Spectral Enchantress Hood (F)"
        $this.PurchasePrice = 35400
        $this.SellPrice = 17700
        $this.DefensivePower = 258
        $this.MagicDefensivePower = 518
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 154
        $this.RequiredMagicDefensivePower = 310
        $this.ExamineString = "A hood of spectral enchantresses, offering powerful ghostly defense."
    }
}

Class BECelestialDreamWeaver : BEHelmet {
    CelestialDreamWeaver() {
        $this.Name = "Celestial Dream Weaver (F)"
        $this.PurchasePrice = 36100
        $this.SellPrice = 18050
        $this.DefensivePower = 262
        $this.MagicDefensivePower = 528
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 157
        $this.RequiredMagicDefensivePower = 316
        $this.ExamineString = "A helm that weaves celestial dreams, offering unparalleled protection."
    }
}

Class BEEmpressOfTheStars : BEHelmet {
    EmpressOfTheStars() {
        $this.Name = "Empress of the Stars (F)"
        $this.PurchasePrice = 36800
        $this.SellPrice = 18400
        $this.DefensivePower = 268
        $this.MagicDefensivePower = 538
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 160
        $this.RequiredMagicDefensivePower = 322
        $this.ExamineString = "The crown of the Empress of the Stars, embodying cosmic power."
    }
}

Class BEAbsoluteOracleTiara : BEHelmet {
    AbsoluteOracleTiara() {
        $this.Name = "Absolute Oracle Tiara (F)"
        $this.PurchasePrice = 37500
        $this.SellPrice = 18750
        $this.DefensivePower = 272
        $this.MagicDefensivePower = 548
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 163
        $this.RequiredMagicDefensivePower = 328
        $this.ExamineString = "An absolute tiara of foresight, providing ultimate magical defense."
    }
}

Class BESoulBlossomCrown : BEHelmet {
    SoulBlossomCrown() {
        $this.Name = "Soul Blossom Crown (F)"
        $this.PurchasePrice = 38200
        $this.SellPrice = 19100
        $this.DefensivePower = 278
        $this.MagicDefensivePower = 558
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 166
        $this.RequiredMagicDefensivePower = 334
        $this.ExamineString = "A crown blooming with pure soul energy, offering profound spiritual defense."
    }
}

Class BEEternalSeraphHelm : BEHelmet {
    EternalSeraphHelm() {
        $this.Name = "Eternal Seraph Helm (F)"
        $this.PurchasePrice = 38900
        $this.SellPrice = 19450
        $this.DefensivePower = 282
        $this.MagicDefensivePower = 568
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 169
        $this.RequiredMagicDefensivePower = 340
        $this.ExamineString = "A helm of eternal seraphim, radiating unending divine protection."
    }
}

Class BEDivineWisdomCrown : BEHelmet {
    DivineWisdomCrown() {
        $this.Name = "Divine Wisdom Crown (F)"
        $this.PurchasePrice = 39600
        $this.SellPrice = 19800
        $this.DefensivePower = 288
        $this.MagicDefensivePower = 578
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 172
        $this.RequiredMagicDefensivePower = 346
        $this.ExamineString = "A crown overflowing with divine wisdom, granting ultimate insights and defense."
    }
}

Class BECosmicQueenHelm : BEHelmet {
    CosmicQueenHelm() {
        $this.Name = "Cosmic Queen Helm (F)"
        $this.PurchasePrice = 40300
        $this.SellPrice = 20150
        $this.DefensivePower = 292
        $this.MagicDefensivePower = 588
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 175
        $this.RequiredMagicDefensivePower = 352
        $this.ExamineString = "A helm fit for a queen of the cosmos, embodying universal power."
    }
}

Class BEEmpressOfCreation : BEHelmet {
    EmpressOfCreation() {
        $this.Name = "Empress of Creation (F)"
        $this.PurchasePrice = 41000
        $this.SellPrice = 20500
        $this.DefensivePower = 298
        $this.MagicDefensivePower = 598
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 178
        $this.RequiredMagicDefensivePower = 358
        $this.ExamineString = "The crown of the Empress of Creation, manifesting raw defensive power."
    }
}

Class BEStarfireWeaverHelm : BEHelmet {
    StarfireWeaverHelm() {
        $this.Name = "Starfire Weaver Helm (F)"
        $this.PurchasePrice = 41700
        $this.SellPrice = 20850
        $this.DefensivePower = 302
        $this.MagicDefensivePower = 608
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 181
        $this.RequiredMagicDefensivePower = 364
        $this.ExamineString = "A helm woven from starfire, offering blazing magical protection."
    }
}

Class BESoulboundOracleHelm : BEHelmet {
    SoulboundOracleHelm() {
        $this.Name = "Soulbound Oracle Helm (F)"
        $this.PurchasePrice = 42400
        $this.SellPrice = 21200
        $this.DefensivePower = 308
        $this.MagicDefensivePower = 618
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 184
        $this.RequiredMagicDefensivePower = 370
        $this.ExamineString = "A helm bound to the oracle's soul, sharing its profound wisdom and defense."
    }
}

Class BEInfinityCrown : BEHelmet {
    InfinityCrown() {
        $this.Name = "Infinity Crown (F)"
        $this.PurchasePrice = 43100
        $this.SellPrice = 21550
        $this.DefensivePower = 312
        $this.MagicDefensivePower = 628
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 187
        $this.RequiredMagicDefensivePower = 376
        $this.ExamineString = "A crown representing infinity, offering boundless magical resilience."
    }
}

Class BELegendarySeerHelm : BEHelmet {
    LegendarySeerHelm() {
        $this.Name = "Legendary Seer Helm (F)"
        $this.PurchasePrice = 43800
        $this.SellPrice = 21900
        $this.DefensivePower = 318
        $this.MagicDefensivePower = 638
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 190
        $this.RequiredMagicDefensivePower = 382
        $this.ExamineString = "A helm worn by legendary seers, granting ultimate magical insights."
    }
}

Class BEDivineGenesisCrown : BEHelmet {
    DivineGenesisCrown() {
        $this.Name = "Divine Genesis Crown (F)"
        $this.PurchasePrice = 44500
        $this.SellPrice = 22250
        $this.DefensivePower = 322
        $this.MagicDefensivePower = 648
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 193
        $this.RequiredMagicDefensivePower = 388
        $this.ExamineString = "A crown from divine genesis, embodying the very essence of creation."
    }
}

Class BECosmicOriginHelm : BEHelmet {
    CosmicOriginHelm() {
        $this.Name = "Cosmic Origin Helm (F)"
        $this.PurchasePrice = 45200
        $this.SellPrice = 22600
        $this.DefensivePower = 328
        $this.MagicDefensivePower = 658
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 196
        $this.RequiredMagicDefensivePower = 394
        $this.ExamineString = "A helm from the cosmic origin, offering foundational magical defense."
    }
}

Class BEUltimateEmpressHelm : BEHelmet {
    UltimateEmpressHelm() {
        $this.Name = "Ultimate Empress Helm (F)"
        $this.PurchasePrice = 45900
        $this.SellPrice = 22950
        $this.DefensivePower = 332
        $this.MagicDefensivePower = 668
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 199
        $this.RequiredMagicDefensivePower = 400
        $this.ExamineString = "The ultimate helm for an empress, providing unparalleled protection."
    }
}

Class BEAbsoluteGoddessHelm : BEHelmet {
    AbsoluteGoddessHelm() {
        $this.Name = "Absolute Goddess Helm (F)"
        $this.PurchasePrice = 46600
        $this.SellPrice = 23300
        $this.DefensivePower = 338
        $this.MagicDefensivePower = 678
        $this.ApplicableGender = "Female"
        $this.RequiredDefensivePower = 202
        $this.RequiredMagicDefensivePower = 406
        $this.ExamineString = "A helm befitting an absolute goddess, radiating supreme divine power."
    }
}