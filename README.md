Welcome to the Eldoria game repository! Please keep in mind that this project is currently under active development and is not in a finished state. You can download and run the game program on your own computer, but be aware that it's currently not in an entirely ready state. That said, if you do decide to download and use it, feedback is always welcome!

Please read the wiki for more information.

# Prerequisites

## Operating System

* Windows 10 or greater (currently testing with new codebase)
* Windows Server 2019 or greater (currently testing with new codebase)
* MacOS (latest version)
* Linux (currently testing with new codebase)

## Terminal Emulators

### MacOS

* Kitty (latest version)

## Caveats

### MacOS

* Font selection matters for this game. The game has been tested on Kitty with the Monaco font. RMV with other fonts, especially those that support ligatures.

# Setup

Eldoria can be started by cloning the repository and running the following:


## MacOS/Linux

```bash
git clone https://github.com/gregoryfmartin/Eldoria.git
cd Eldoria
python3 -m venv .venv
source .venv/bin/activate
pip install miniaudio

python3 main.py

-- or --

python3 -m eldoria_py
```

## Windows (PowerShell)

```powershell
git clone https://github.com/gregoryfmartin/Eldoria.git
cd Eldoria
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install miniaudio

python main.py

-- or --

python -m eldoria_py
```

# Splash/Cinematic

Eldoria has a nice little title sequence and animation:

<img width="480" height="393" alt="EldoriaSplashCinematic" src="https://github.com/user-attachments/assets/d044ecfe-6978-47af-a534-32322dfa97d1" />

# Title Screen

Eldoria's title screen allows you to start a new game, load a previously saved game, configure some options, view credits, and quit back to the terminal:

<img width="480" height="393" alt="EldoriaTitleScreen" src="https://github.com/user-attachments/assets/e330d366-0fe8-4f2d-8092-c1b339d38bb6" />

# New Game

Eldoria now supports a player party of up to five characters. At a minimum, you need at one, and you can certainly attempt to play the game this way, but it's recommended you have a full party.

You can walk through creating a character of your own:

<img width="480" height="393" alt="EldoriaCharWizard" src="https://github.com/user-attachments/assets/2713d9cb-78a1-40ba-b1c0-46c05c12a46b" />

Alternatively, you can use the stock party by pressing the R key:

<img width="480" height="393" alt="EldoriaDefaultParty" src="https://github.com/user-attachments/assets/ad134443-d104-49d5-8cbc-2236e916e391" />

With the default party, you can go back and customize specific properties, or continue onto world creation by pressing the Spacebar.

<img width="954" height="781" alt="Screenshot 2026-10-18 at 18 34 42" src="https://github.com/user-attachments/assets/1688375a-dcff-400c-b136-9cd10b3b4638" />

The world in Eldoria is procedurally generated, and the total map size, along with certain other features, are dictated by it. There are currently four map sizes:

* Quick - The smallest map size possible. A vast portion of quests, towns, castles, and items are unavailable in this size. Use this to get a handle on how to play the game generally or if you just feel like it.
* Standard - The normal size for Eldoria. All features are available on this map size and within reasonable distances. Some biomes may not be available in this size.
* Odyssey - A larger than normal map size. Points of Interest are spread further apart from each other, meaning reliance on the Compass Conch is higher. More biomes and enemy diversity.
* Colossal - A joke size map. Its size could make playing difficult as Points of Interest are spread pretty far apart. Stocking up on Compass Conchs is required. All biome varieties are available here.

Below is an example of creating a new Colossal map.

<img width="480" height="393" alt="EldoriaWorldCreation" src="https://github.com/user-attachments/assets/38feb15d-9396-4f77-b728-4372072d00aa" />

# Navigating the World Map

The player can move around the world map with the arrow keys on the keyboard.

<img width="480" height="393" alt="EldoriaWorldMapNav" src="https://github.com/user-attachments/assets/e990823b-d0d7-4756-950c-94fa2d512b2b" />

Various Points of Interest on the world map can be interacted with by pressing the Enter key. In this case, a town is next to the player. You move over top the town icon and press Enter to enter the town.

<img width="480" height="393" alt="EldoriaEnterTown" src="https://github.com/user-attachments/assets/5ed403ca-4611-4aa7-9a07-e3e8dec47e0a" />

There are other POI the player can interact with including towns, caves, and castles.

## Towns

<img width="954" height="781" alt="Screenshot 2026-10-19 at 09 11 53" src="https://github.com/user-attachments/assets/365ca089-8e92-496c-8dbd-f54988309378" />

Scattered across the world map are several towns the player can enter. In each town are several NPCs the player can interact with. Some will provide local context, others will provide side quests. There are several shops the player can interact with: inns to entirely heal the party for a fee, herbalists will buy and sell general purpose items and tools, armorers will buy and sell all kinds of equipment, and barkeepers will just yap your ear off.

<img width="480" height="393" alt="EldoriaTownNav" src="https://github.com/user-attachments/assets/fd508043-4033-4841-a038-166f48ff4c0c" />

## Caves

<img width="954" height="781" alt="Screenshot 2026-10-19 at 09 27 04" src="https://github.com/user-attachments/assets/7fb36aa9-5927-4a2f-807c-ebbc15c7b080" />

Caves are variable depth dungeons that contain anywhere from 3 to 9 floors. At the bottom floor of each cave is one of the boss monsters that needs to be defeated to complete the main story quest. Each floor of a cave has a ladder that can be used to traverse between the floors. Once the player defeats the boss character, an escape rope will appear that will teleport the player back to the surface. Note the demonstration below uses developer functionality that isn't available in the final version of the game.

<img width="480" height="393" alt="EldoriaCave" src="https://github.com/user-attachments/assets/a7fb8dfc-58a0-458a-8ccd-886a6995f91c" />

# Battle System

Eldoria features a classic JRPG random encounter battle system. Some maps are able to feature battle encounters, others aren't. Certain biomes have higher encounter rates than others; encounter rates are always higher in caves than anywhere else.

Battles are NvN, meaning that the player's party can be anywhere from 1 to 5 members, and the enemy squads can be anywhere from 1 to 10 enemies. Players will first enter all of the desired commands for each member of their party. Once all the commands have been entered, battle execution order is determined between the party members and the enemies in the squad and played out automatically. A battle scenario will end when either the the player party has defeated all the enemies in the squad or the player's party has fallen. If the player's party falls, the party will be revived and replaced near the start town. Note that for the demonstration here, the developer shortcut to instantly kill all enemies in the squad is not in the production version.

> TODO: Insert GIF of a simple battle here.

# Menu System

Using the System Menu, players can control every aspect of their parties and inventories.

## Status

The first option, Status, shows an overview of your party members, including metadata, HP, MP, XP, attributes, current equipment, and current combat skills/magic. Players can cycle between party members by using the left and right arrow keys.

> TODO: Insert GIF of toggling between party members on the Status screen.

## Items

The Items submenu allows players to manage their general item inventory. Items are distinguished between three categories: Usable, Equip, and Key.

* Usable - Items that can be used either in the Items submenu or in combat directly by the player, targeting either a party member or an enemy in a squad.
* Equip - Equipment that can be equipped to a party member.
* Key - Items that are crucial to a quest. These can't be discarded or sold.

> TODO: Insert GIF of moving between item categories, selecting and using an item within the Item submenu.

## Equipment

The third option, Equipment, allows the player to manage equipped items on each party member. You can view, change, and remove equipment from ten different slots.

> TODO: Insert GIF of navigating and using the Equipment submenu.

## Magic

The Magic submenu allows the player to view and manage currently equipped skills and magic for a given party member.

Skills are differentiated from Magic on a few different dimensions:

* Party members will start with a few innate Skills and Magic.
* Generally, character class will dictate what gets conferred to them upon certain level ups.
* Skills and Magic can also be taught to characters via Skill Trainer (Skills) or Tomes (Magic). Only certain classes can learn certain kinds of Skills and Magic.

> TODO: Insert GIF of navigating and using the Magic submenu.

## Quests

The Quests submenu shows what quest lines the player has available to them. At the start of the game, you have the main storyline quest to defeat all the boss enemies. Aside from this, as you travel between towns and castles, you can obtain side quests from NPCs. A given quest can be tracked so you can focus on one at a time, and the current quest can be displayed quickly on the world map by pressing the Q key.

> TODO: Insert GIF of navigating and using the Quest submenu. Also show the Quest Tracker on the World Map.

## Save

Eldoria tracks three save slots. From the Save menu, you can choose a slot to save your game to.

> TODO: Insert GIF of navigating and using the Save submenu.

## Quit

From the Quit submenu, you can quit to the title, quit to the terminal, or cancel.

> TODO: Insert GIF of navigating and using the Quit submenu.
