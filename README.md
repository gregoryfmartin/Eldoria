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

# Interacting with Items on Tiles

Items on a tile can be determined using the "look" keyword (abbr. "l"):

<img width="803" height="596" alt="image" src="https://github.com/user-attachments/assets/6f074013-8c59-4045-97fc-9742c6fdd97e" />

Items on a tile can be examined for further details using the "examine" keyword (abbr. "exa"):

<img width="804" height="602" alt="image" src="https://github.com/user-attachments/assets/a1b698ea-2992-4980-9ba5-75c6cfb5e960" />

Certain items can be picked up and placed into the Player's inventory using either the "take" or "get" keywords (abbr "t" or "g" respectively):

<img width="803" height="597" alt="image" src="https://github.com/user-attachments/assets/931b5e77-c624-4ef4-ae79-406d0bf2bbf7" />

Items from the Player's inventory can be used on items in the current tile. For example, you can tie a Rope from your inventory to a Tree using the "use" keyword (abbr. "u") followed by "rope" and then "tree". In this example, the player doesn't have a rope in their inventory, so the game informs them:

<img width="803" height="599" alt="image" src="https://github.com/user-attachments/assets/e86cbb1e-0b4b-4bce-9dfc-a121ce3ae11b" />

# Player's Inventory

The Player's inventory can be accessed from the Navigation Screen using the "inventory" keyword (abbr. "i"):

<img width="803" height="600" alt="image" src="https://github.com/user-attachments/assets/e45e54f3-9a7e-459f-8abf-9bb496070858" />

The Inventory Screen works very much like a book. Each page of the inventory contains at most 10 items. If there are more than 10 items, pages are created to the right of the first one (indicated by the yellow chevron in the top-right corner). Each item has a description which is dynamically updated in the bottom portion of the window.

<img width="807" height="486" alt="image" src="https://github.com/user-attachments/assets/9bc68c9f-5dea-4d62-8c5b-ac34937ccee9" />

Subsequent pages can be accessed by turning right (D) or turning left (A):

<img width="806" height="483" alt="image" src="https://github.com/user-attachments/assets/6fc1fc51-2d51-408c-8807-b1cbc7657ac7" />

Items that can be used on the Player themselves offer more specific information regarding their effects on stats:

<img width="800" height="478" alt="image" src="https://github.com/user-attachments/assets/a773dafb-c8cb-4544-9378-6382801b9d70" />

Item's effects are randomized:

<img width="798" height="476" alt="image" src="https://github.com/user-attachments/assets/6660b6e9-f008-4ed7-9be0-ba75451531a0" />

When the Player issues a "use" command from the Navigation Screen, the very first instance of a matching item is used. Unsafe items can be dropped from the Player's inventory by pressing the S key. A beep will indicate a successful drop. Be aware that some items can't be dropped (these are called Key Items).

<img width="799" height="474" alt="image" src="https://github.com/user-attachments/assets/1d8c9f8f-8830-4ed1-b04c-2d387149dff4" />

The Inventory Screen can be exited by pressing the Escape key.

# Player Status/Action Equip Screen

The Player's status and inventory technique selection screen is bundled into one. It can be accessed from the Navigation Screen by using the keyword "status" (abbreviation. "sta"):

<img width="797" height="599" alt="image" src="https://github.com/user-attachments/assets/c0cba08a-6003-4cc0-b567-ef50e5c737e9" />

<img width="805" height="388" alt="image" src="https://github.com/user-attachments/assets/211fd4a0-2919-4f27-88de-79bc5703b3ce" />

The box in the bottom-left allows you to move the chevron up/down to select a technique to replace. Position the chevron using the up/down arrow keys and press Enter to access the Battle Action Inventory:

<img width="806" height="385" alt="image" src="https://github.com/user-attachments/assets/a3adae6f-2d24-41a5-81b8-8f8dc5b4e4e1" />

This inventory window behaves much the same as the Item Inventory window, just smaller and displaying information specific to the Battle Action you have selected. When you find a technique you want to use instead, press the Enter key again to equip the new action. If you don't wish to equip any actions, press the Escape key to return:

<img width="806" height="382" alt="image" src="https://github.com/user-attachments/assets/e369fa24-46de-4699-8a70-78c6a1c8a238" />

To exit the Player's Status Screen, press the Escape key until you're back at the Navigation Screen (at most 2 times).

# Battle

Battle encounters are random and can occur on tile moves. If you do encounter an enemy, a BATTLE COMMENCE message will appear and then the battle will start.

<img width="815" height="570" alt="image" src="https://github.com/user-attachments/assets/5cbfc2af-f785-42a8-bb15-fc28fb599f7b" />

Enemies are randomly assigned each time a battle starts. Battles are turn based. Whomever has the current turn will have their window highlighted yellow. When it's the enemy's turn, they will randomly select an attack and use it against the Player. When it's the Player's turn, you can use the up/down arrow keys to select an action and press Enter to use it:

<img width="815" height="574" alt="image" src="https://github.com/user-attachments/assets/094c870b-d750-46c4-885d-d58d81f72ca7" />

When the Player wins a battle, spoils are given and you're prompted to press the Enter key to return to the Navigation Screen. If the Player loses a battle, the game is over.
