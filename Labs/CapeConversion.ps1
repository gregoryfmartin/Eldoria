Class BETatteredCape : BECape {
	BETatteredCape() : base() {
		$this.Name               = 'Tattered Cape'
		$this.MapObjName         = 'tatteredcape'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A worn and torn cape, offering minimal protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEClothCape : BECape {
	BEClothCape() : base() {
		$this.Name               = 'Cloth Cape'
		$this.MapObjName         = 'clothcape'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cloth cape, light and unassuming.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BELeatherCape : BECape {
	BELeatherCape() : base() {
		$this.Name               = 'Leather Cape'
		$this.MapObjName         = 'leathercape'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy leather cape, providing a touch of defense.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BETravelerCape : BECape {
	BETravelerCape() : base() {
		$this.Name               = 'Traveler Cape'
		$this.MapObjName         = 'travelercape'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A durable cape designed for long journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEHunterCape : BECape {
	BEHunterCape() : base() {
		$this.Name               = 'Hunter Cape'
		$this.MapObjName         = 'huntercape'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cape favored by trackers and hunters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BERogueCape : BECape {
	BERogueCape() : base() {
		$this.Name               = 'Rogue Cape'
		$this.MapObjName         = 'roguecape'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cape, ideal for blending into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BESorcererCape : BECape {
	BESorcererCape() : base() {
		$this.Name               = 'Sorcerer Cape'
		$this.MapObjName         = 'sorcerercape'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flowing cape, subtly enhancing magical flow.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEPriestessCape : BECape {
	BEPriestessCape() : base() {
		$this.Name               = 'Priestess Cape'
		$this.MapObjName         = 'priestesscape'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure white cape, imbued with a gentle blessing.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEWarriorCape : BECape {
	BEWarriorCape() : base() {
		$this.Name               = 'Warrior Cape'
		$this.MapObjName         = 'warriorcape'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust cape, offering minor protection in combat.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEKnightCape : BECape {
	BEKnightCape() : base() {
		$this.Name               = 'Knight Cape'
		$this.MapObjName         = 'knightcape'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy cape, signifying duty and honor.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEElvenweaveCape : BECape {
	BEElvenweaveCape() : base() {
		$this.Name               = 'Elvenweave Cape'
		$this.MapObjName         = 'elvenweavecape'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Speed = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely woven cape, light and graceful.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDwarvenHearthCape : BECape {
	BEDwarvenHearthCape() : base() {
		$this.Name               = 'Dwarven Hearth Cape'
		$this.MapObjName         = 'dwarvenhearthcape'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick, warm cape from dwarven forges.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

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

Class BESunlitCape : BECape {
	BESunlitCape() : base() {
		$this.Name               = 'Sunlit Cape'
		$this.MapObjName         = 'sunlitcape'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that glows faintly with solar energy, inspiring hope.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEMoonwhisperCape : BECape {
	BEMoonwhisperCape() : base() {
		$this.Name               = 'Moonwhisper Cape'
		$this.MapObjName         = 'moonwhispercape'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark cape that seems to hum with lunar power, aiding intuition.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEDragonscaleCape : BECape {
	BEDragonscaleCape() : base() {
		$this.Name               = 'Dragonscale Cape'
		$this.MapObjName         = 'dragonscalecape'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape crafted from the durable scales of a dragon.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEPhoenixwingCape : BECape {
	BEPhoenixwingCape() : base() {
		$this.Name               = 'Phoenixwing Cape'
		$this.MapObjName         = 'phoenixwingcape'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape made from the vibrant feathers of a phoenix, surprisingly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEBlessedHeroCape : BECape {
	BEBlessedHeroCape() : base() {
		$this.Name               = 'Blessed Hero Cape'
		$this.MapObjName         = 'blessedherocape'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape worn by a legendary hero, imbued with divine favor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEStarlightWeaveCape : BECape {
	BEStarlightWeaveCape() : base() {
		$this.Name               = 'Starlight Weave Cape'
		$this.MapObjName         = 'starlightweavecape'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape woven from threads infused with starlight, subtly enhancing luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEVoidTouchedCape : BECape {
	BEVoidTouchedCape() : base() {
		$this.Name               = 'Void Touched Cape'
		$this.MapObjName         = 'voidtouchedcape'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that seems to draw power from the void, unsettling yet potent.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}

Class BEWhisperingWoodsCape : BECape {
	BEWhisperingWoodsCape() : base() {
		$this.Name               = 'Whispering Woods Cape'
		$this.MapObjName         = 'whisperingwoodscape'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape woven from ancient forest materials, attuned to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BEStormfrontCape : BECape {
	BEStormfrontCape() : base() {
		$this.Name               = 'Stormfront Cape'
		$this.MapObjName         = 'stormfrontcape'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that crackles with faint static, hinting at elemental power.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BEGlacierwindCape : BECape {
	BEGlacierwindCape() : base() {
		$this.Name               = 'Glacierwind Cape'
		$this.MapObjName         = 'glacierwindcape'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape that feels perpetually cold, offering resistance to heat.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}

Class BECrimsonSorceressCape : BECape {
	BECrimsonSorceressCape() : base() {
		$this.Name               = 'Crimson Sorceress Cape'
		$this.MapObjName         = 'crimsonsorceresscape'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep red cape, favored by powerful female magic users.'
		$this.PlayerEffectString = "  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}

Class BERoyalSentinelCape : BECape {
	BERoyalSentinelCape() : base() {
		$this.Name               = 'Royal Sentinel Cape'
		$this.MapObjName         = 'royalsentinelcape'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely embroidered cape, worn by the elite royal guard.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}

