Welcome to the Eldoria game repository! Please keep in mind that this project is currently under active development and is not in a finished state. You can download and run the game program on your own computer, but be aware that none of the scripts are signed and it's currently not in a ready-to-use state. That said, if you do decide to download and use it, feedback is always welcome!

Please read the GitHub wiki for more information.

# Prerequisites

* Windows 10 or greater OR Windows Server 2019 or greater
* PowerShell Core 7.3.0 or greater
* Windows Terminal 1.21.X or greater

# Setup

* Download this repository in its entirety or clone the master branch into a local directory on your computer.
* Open Windows Terminal and navigate to the directory where the repository is located at.
* Run the script as follows: Set-ExecutionPolicy Bypass -Scope Process -Force; .\EldoriaDev.ps1

# Navigating the World Map

The map can be navigated using the command "move" followed by a cardinal direction: north, south, east, or west.

<img width="744" alt="Screenshot 2025-01-13 at 5 34 28 PM" src="https://github.com/user-attachments/assets/e9866e3b-2656-48db-bb5b-eccb4d2dc063" />

The movement commands can be abbreviated. The word "move" can be shortened to simply "m", and each of the cardinal directions can be abbreviated to "n", "s", "e", and "w" respectively:

<img width="744" alt="Screenshot 2025-01-13 at 5 35 34 PM" src="https://github.com/user-attachments/assets/757ac60a-2019-4761-ad23-d8c4fc57fec4" />

If a door, or some other kind of entrance, is on a tile, you can enter or exit it with either the "enter" or "exit" keywords (abbr. "en" or "ex" respectively):

<img width="744" alt="Screenshot 2025-01-13 at 5 41 46 PM" src="https://github.com/user-attachments/assets/6c733e44-98be-40ca-9e83-942771ee806c" />

<img width="744" alt="Screenshot 2025-01-13 at 5 44 07 PM" src="https://github.com/user-attachments/assets/c90729ac-3e4d-47f6-8acc-d3ef141b0698" />

# Interacting with Items on Tiles

Items on a tile can be determined using the "look" keyword (abbr. "l"):

<img width="744" alt="Screenshot 2025-01-13 at 5 36 19 PM" src="https://github.com/user-attachments/assets/982eb70a-1de0-4839-91e2-ca638ebd9918" />

Items on a tile can be examined for further details using the "examine" keyword (abbr. "exa"):

<img width="744" alt="Screenshot 2025-01-13 at 5 37 04 PM" src="https://github.com/user-attachments/assets/b25ad2ee-55dd-4b84-9996-4c1fd092bb3c" />

Certain items can be picked up and placed into the Player's inventory using either the "take" or "get" keywords (abbr "t" or "g" respectively):

<img width="744" alt="Screenshot 2025-01-13 at 5 38 03 PM" src="https://github.com/user-attachments/assets/96b8509f-18df-44cd-a6de-530de3a5400f" />

Items from the Player's inventory can be used on items in the current tile. For example, you can tie a Rope from your inventory to a Tree using the "use" keyword (abbr. "u") followed by "rope" and then "tree":

<img width="744" alt="Screenshot 2025-01-13 at 6 33 26 PM" src="https://github.com/user-attachments/assets/c0102e14-42e5-4a4c-8502-ef746663dd3a" />

# Player's Inventory

The Player's inventory can be accessed from the Navigation Screen using the "inventory" keyword (abbr. "i"):

<img width="744" alt="Screenshot 2025-01-13 at 6 36 36 PM" src="https://github.com/user-attachments/assets/658ba259-11d0-4cfe-ad01-4318f97a7619" />

The Inventory Screen works very much like a book. Each page of the inventory contains at most 10 items. If there are more than 10 items, pages are created to the right of the first one (indicated by the yellow chevron in the top-right corner). Each item has a description which is dynamically updated in the bottom portion of the window.

<img width="744" alt="Screenshot 2025-01-13 at 6 37 05 PM" src="https://github.com/user-attachments/assets/ea388f1f-5ba4-4b66-a24d-daf195a54053" />

Subsequent pages can be accessed by turning right (D) or turning left (A):

<img width="744" alt="Screenshot 2025-01-13 at 6 39 49 PM" src="https://github.com/user-attachments/assets/e5b4cee4-1aab-401f-83f3-0ad3b477c1ec" />

Items that can be used on the Player themselves offer more specific information regarding their effects on stats:

<img width="744" alt="Screenshot 2025-01-13 at 6 40 27 PM" src="https://github.com/user-attachments/assets/100fe319-9b58-4e44-b0d6-e0a527e77aa9" />

Item's effects are randomized:

<img width="744" alt="Screenshot 2025-01-13 at 6 40 45 PM" src="https://github.com/user-attachments/assets/0f6fe3a3-4355-4752-aca5-364114da1e4a" />

When the Player issues a "use" command from the Navigation Screen, the very first instance of a matching item is used. Unsafe items can be dropped from the Player's inventory by pressing the S key. A beep will indicate a successful drop. Be aware that some items can't be dropped (these are called Key Items).

<img width="744" alt="Screenshot 2025-01-13 at 6 42 12 PM" src="https://github.com/user-attachments/assets/d27438ab-76b5-424c-b133-436402a9f51e" />

The Inventory Screen can be exited by pressing the Escape key.

# Player Status/Action Equip Screen

The Player's status and inventory technique selection screen is bundled into one. It can be accessed from the Navigation Screen by using the keyword "status" (abbreviation. "sta"):

<img width="744" alt="Screenshot 2025-01-13 at 6 43 38 PM" src="https://github.com/user-attachments/assets/5acc75a8-3d7c-4e7c-8943-3d29d6d902b6" />

<img width="744" alt="Screenshot 2025-01-13 at 6 43 53 PM" src="https://github.com/user-attachments/assets/fdceb3bb-5236-4189-ba3b-b66d2b56464f" />

The box in the bottom-left allows you to move the chevron up/down to select a technique to replace. Position the chevron using the up/down arrow keys and press Enter to access the Battle Action Inventory:

<img width="744" alt="Screenshot 2025-01-13 at 6 45 01 PM" src="https://github.com/user-attachments/assets/6ac94d96-0e58-49c2-babc-7b64a0b05562" />

This inventory window behaves much the same as the Item Inventory window, just smaller and displaying information specific to the Battle Action you have selected. When you find a technique you want to use instead, press the Enter key again to equip the new action. If you don't wish to equip any actions, press the Escape key to return:

<img width="744" alt="Screenshot 2025-01-13 at 6 46 34 PM" src="https://github.com/user-attachments/assets/fa09580b-20cc-449e-a196-1b64897bc229" />

<img width="744" alt="Screenshot 2025-01-13 at 6 47 02 PM" src="https://github.com/user-attachments/assets/0ccd1fbf-9b59-461f-832c-9c43bce80be7" />

To exit the Player's Status Screen, press the Escape key until you're back at the Navigation Screen (at most 2 times).

# Battle

Battle encounters are random and can occur on tile moves. If you do encounter an enemy, a BATTLE COMMENCE message will appear and then the battle will start.

<img width="744" alt="Screenshot 2025-01-13 at 6 50 57 PM" src="https://github.com/user-attachments/assets/605d43cc-bacd-4926-a132-27454b70c710" />

Enemies are randomly assigned each time a battle starts. Battles are turn based. Whomever has the current turn will have their window highlighted yellow. When it's the enemy's turn, they will randomly select an attack and use it against the Player. When it's the Player's turn, you can use the up/down arrow keys to select an action and press Enter to use it:

<img width="744" alt="Screenshot 2025-01-13 at 6 52 39 PM" src="https://github.com/user-attachments/assets/e7b30856-7b0f-4104-9b99-434df3169b11" />

<img width="744" alt="Screenshot 2025-01-13 at 6 52 42 PM" src="https://github.com/user-attachments/assets/63fb10e2-611d-4b89-aeaa-cf70a2d8e5d1" />

When the Player wins a battle, spoils are given and you're prompted to press the Enter key to return to the Navigation Screen. If the Player loses a battle, the game is over.




