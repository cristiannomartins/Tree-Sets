[![Build Status](https://travis-ci.org/cristiannomartins/Tree-Sets.svg?branch=master)](https://travis-ci.org/cristiannomartins/Tree-Sets)
![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)
[![License](https://img.shields.io/badge/license-GPL%20License-brightgreen.svg)](https://opensource.org/licenses/GPL-3.0)

# Tree-Sets
Tree sets is an iOS app written in Swift 3.0. It serves as a catalogue for information about all trainers and Pokémon on the Battle Tree facility, on Pokémon Sun and Moon versions.

![battletree image](https://www.serebii.net/sunmoon/battletree.jpg)

## Table of content

- [The Battle Tree](#the-battle-tree)
- [The Tree Sets App](#the-tree-sets-app)
- [License](#license)

## The Battle Tree
The Battle Tree can be found on Poni Island in Alola, on Generation 7 of Pokémon main games. It is a facility similar to the Battle Maison, from Generation 6 games, and works in the same way: after becoming the champion of the region, the trainer can challenge the facility and try to build a long streak of victories against random NPC that appear, one after the other.

There are 3 battle formats available on the Battle Tree (single, double or multi battles), each one giving the option of 2 levels of difficulty (Normal or Super), but, although there are a lot of trainers that can appear at the Tree, these trainers, and the Pokémon sets they use against you are not random: each trainer has unique characteristics, including name, salutations (greetings, and goodbyes for whether they win or loose), Pokémon they can use, sets of these Pokémon they have access to, and minimum and maximum streak size in which they can appear, among other things.

That being said, this app aspires to be a catalogue of trainers and Pokémon the Battle Tree can throw at us during a challenge.

## The Tree Sets App
The main view of this app is a TabBar, which gives the options of listing the database by trainers (where all Pokémon Sets available to that trainer could be displayed), or by Pokémon (where all sets for each Pokémon are displayed). The last tab has a form for updating the trainers' data.

<img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/TreeSetsShot.png?raw=true" width="400"/> <img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/PokemonSets.png?raw=true" width="400"/>

There are around 250 different Pokémon species available to the NPC trainers on the Tree, and each of these species have up to 4 distinct sets for the NPC to own, and each set can differ in EVs distribution, held item, nature, and movesets. Since some items can interfere on Pokémons stats, it is possible to consider the effect of the item being used/lost by simply touching the held item icon on the Details view of Pokémon Sets, and the stats for that set will be updated accordingly.

<img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/TreeSetsShot.png?raw=true" width="400"/> > <img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/PokemonSets.png?raw=true" width="400"/>
<img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/Details.png?raw=true" width="400"/> <img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Tree%20Sets/Assets.xcassets/Screenshots/Screenshots.imageset/DetailsWPUsed.png?raw=true" width="400"/>

## License
The Tree Sets app is licensed under the terms of the GPL Open Source license and is available for free.
