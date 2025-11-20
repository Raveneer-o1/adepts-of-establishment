# Adepts of Establishment 

[![GPLv3 License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://opensource.org/licenses/)
[![Godot Engine](https://img.shields.io/badge/Godot-4.5%2B-%23478cbf)](https://godotengine.org)

## Project Overview
**A free open-source spiritual successor to Disciples II**

*Turn-based strategy with evolution based progression in a dark fantasy world*

### If you're unfamiliar with the Disciples series:
Disciples is a dark fantasy strategy series blending turn-based empire-building, tactical combat, and rich RPG storytelling. The series initially drew comparisons to Heroes of Might & Magic but carved its niche through grim aesthetics and unit evolution system. These games combine strategic city management, hero development, and JRPG-like battles with unit positioning and evolution. The series is famed for its grim art style (by Patrick Lambert), and a "no-movement" combat system that emphasizes pre-planning over real-time tactics.

**Adepts of Establishment** carries this legacy forward with an open-source approach. I aim to create a game made by fans for fans.

Here is the tree of units planned for this project. The main bulk of it was copied from Disciples II but I added a few tweaks.
<details>
  <summary>Unit trees</summary>

  ```mermaid
  graph TD
    subgraph Empire
        undead_empire[ ] ~~~ Squire["Squire"]
        undead_empire ~~~ Apprentice["Apprentice"]
        undead_empire ~~~ Archer["Archer"]
        undead_empire ~~~ Acolyte["Acolyte"]
        style undead_empire height:0px

        Squire --> Knight["Knight"]
        Knight --> Knight_Master["Knight Master"]
        Knight_Master --> Angel_Knight["Angel Knight"]
        Knight --> Horseman["Horseman"]
        Horseman --> Royal_Cavalier["Royal Cavalier"]
        Royal_Cavalier --> Paladin["Paladin"]
        
        Squire --> Witch_Hunter["Witch hunter"]
        Witch_Hunter --> Inquisitor["Inquisitor"]
        Inquisitor --> Grand_Inquisitor["Grand Inquisitor"]
        Witch_Hunter --> Samurai["Samurai"]
        Samurai --> Blade_Saint["Blade Saint"]
        
        Apprentice --> Elementalist["Elementalist"]
        Elementalist --> Ritualist["Ritualist"]
        Apprentice --> Mage["Mage"]
        Mage --> Wizard["Wizard"]
        Wizard --> White_Mage["White Mage"]
        White_Mage --> Keeper_of_Knowledge["Keeper of Knowledge"]
        White_Mage --> Arcanist["Arcanist"]
        
        Archer --> Marksman["Marksman"]
        Marksman --> Assassin["Assassin"]
        Marksman --> Scout["Scout"]
        Scout --> Imperial_Ranger["Imperial Ranger"]
        
        Acolyte --> Cleric["Cleric"]
        Cleric --> Matriarch["Matriarch"]
        Matriarch --> Prophetess["Prophetess"]
        Acolyte --> Priest["Priest"]
        Priest --> Imperial_priest["Imperial priest"]
        Imperial_priest --> Hierophant["Hierophant"]
    end
    subgraph Undead
        undead_root[ ] ~~~ Warrior["Warrior"]
        undead_root ~~~ Death_Acolyte["Death Acolyte"]
        undead_root ~~~ Ghost["Ghost"]
        undead_root ~~~ Wyvern["Wyvern"]
        style undead_root height:0px

        Warrior --> Zombie["Zombie"]
        Zombie --> Phantom_warrior["Phantom warrior"]
        Zombie --> Skeleton["Skeleton"]
        Skeleton --> Skeleton_warrior["Skeleton warrior"]
        Skeleton_warrior --> Skeleton_champion["Skeleton champion"]
        Warrior --> Templar["Templar"]
        Templar --> Fallen_inquisitor["Fallen inquisitor"]
        Fallen_inquisitor --> Dark_lord["Dark lord"]

        Death_Acolyte --> Necromancer["Necromancer"]
        Necromancer --> Vampire["Vampire"]
        Vampire --> Elder_vampire["Elder vampire"]
        Elder_vampire --> Vampire_Lord["Vampire Lord"]
        Elder_vampire --> Blood_spawn["Blood spawn"]
        Necromancer --> Lich["Lich"]
        Lich --> Archlich["Archlich"]
        Death_Acolyte --> Dark_Mage["Dark Mage"]
        Dark_Mage --> Wraith["Wraith"]
        Wraith --> Herald_of_Death["Herald of Death"]
        
        Ghost --> Specter["Specter"]
        Specter --> Will_o_Wisp["Will-o’-Wisp"]
        Will_o_Wisp --> The_eternal["The eternal"]
        Specter --> Shadow["Shadow"]
        Shadow --> Vision_of_Darkness["Vision of Darkness"]
        
        Wyvern --> Doomdrake["Doomdrake"]
        Doomdrake --> Gluttonous_Serpent["Gluttonous Serpent"]
        Gluttonous_Serpent --> The_Devourer["The Devourer"]
        Doomdrake --> Dreadwyrm["Dreadwyrm"]
        Dreadwyrm --> Undying_Nighthunter["Undying Nighthunter"]
        Undying_Nighthunter --> Dracolich["Dracolich"]
    end
  ```

  [Unit trees (old)](UnitStatsManager/unit%20trees.svg)
  
</details>

## A Note on AI-Generated Content

* **Art Assets (Placeholders):** The unit portraits in this build are AI-generated. They are temporary stand-ins to visualize the game during development and are **not** intended for the final product. The source repository does not include these image files for this reason. My goal is to eventually find an artist to create all final assets.

* **Documentation & Comments:** To save time, I use Large Language Models (LLMs) to help draft documentation and code comments. The logic and architecture of the code itself are human-written. If you find any comments that are unhelpful, redundant, or unclear, please feel free to correct them in a Pull Request!

## Getting Started
### Prerequisites
1. Download and install the [Godot Engine](https://godotengine.org/). Current version is being developed with Godot 4.5  
2. Ensure Git LFS is installed on your system

### Installation Steps
1. Clone the repository using:
   ```bash
   git clone https://github.com/Raveneer-o1/adepts-of-establishment.git
   ```
2. Launch Godot Engine and use the Project Manager to open the cloned directory
3. If PNG files fail to load properly, verify your Git LFS installation:
   ```bash
   git lfs version
   ```
   Check the [Git LFS official instructions](https://git-lfs.com/) if you need more help.
   
   Update LFS-tracked files with:
   ```bash
   git lfs pull
   ```

## How to Contribute
I encourage any contributions to the project, whether you're a programmer, artist, or just someone passionate about strategy games. Contributions can range from improving the codebase, adding assets, or suggesting new gameplay features (see below).

The codebase is thoroughly commented using Godot's built-in documentation format and I do my best to maintain clear and understandable code. However, if you find any part of the code unclear or difficult to follow, feel free to open an issue. We’ll discuss and work together to improve it.

### Where to start
Once you open the project, run it to get the idea of what the game is about and how it works. Then find the documentation on the main elements. By default, `F1` key opens Godot's 'Search help' window. Start with `CombatSystem`, then go to through `Attack`, `Unit`, `UnitAttack`.

If you are new to programming or godot or just want something to start with, please check out the [guides](docs/contributing).

### What is needed specifically
All help welcome! No contribution too small. But here's a small selection of what I personally think needs to be done (in *itallics* are non-urgent tasks).

#### **UI/UX**
- The game doesn't have good interface right now. There is no consistent art style for UI, no thought behind any of the UX decisions, it's a mess
#### **Art**:
- Environment tilesets. There is a rudimentary tiles drawn by me but they don't look particularly good
- Unit potraits. We don't have any at the moment
- *Pixel art units improvements*
*(currently the game is implemented with 32x32 pixel art sprites)*
#### **Sound**:
- Sound design is very unfamiliar territory to me, anything would be helpful
#### **Game Design**:
- New, unique effects for units
- Balance units and factions
#### **Testing**:
- Bug reports, compatibility checks

## License
This project is licensed under the [GNU General Public License v3 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.html). By contributing to the project, you agree to license your contributions under the same license.

## Acknowledgments
- Inspired by **Disciples II** (2002, Strategy First)
- Built with [Godot Engine](https://godotengine.org)
