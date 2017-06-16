[![Build Status](https://travis-ci.org/cristiannomartins/Tree-Sets.svg?branch=master)](https://travis-ci.org/cristiannomartins/Tree-Sets)
[![GitHub issues](https://img.shields.io/github/issues/cristiannomartins/Tree-Sets.svg)](https://github.com/cristiannomartins/Tree-Sets/issues)
[![GitHub forks](https://img.shields.io/github/forks/cristiannomartins/Tree-Sets.svg)](https://github.com/cristiannomartins/Tree-Sets/network)
[![GitHub stars](https://img.shields.io/github/stars/cristiannomartins/Tree-Sets.svg)](https://github.com/cristiannomartins/Tree-Sets/stargazers) <!---[![Code Climate](https://codeclimate.com/github/cristiannomartins/Tree-Sets/badges/gpa.svg)](https://codeclimate.com/github/cristiannomartins/Tree-Sets)-->
[![Issue Count](https://codeclimate.com/github/cristiannomartins/Tree-Sets/badges/issue_count.svg)](https://codeclimate.com/github/cristiannomartins/Tree-Sets)
![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/cristiannomartins/Tree-Sets/master/License.md)

# Tree-Sets
Tree sets is an iOS app written in Swift 3.0. It serves as a fast, lightweight and offline catalogue for information about all trainers and Pokémon on the Battle Tree facility, on Pokémon Sun and Moon versions.

![battletree image](https://www.serebii.net/sunmoon/battletree.jpg)

## Table of content

- [The Battle Tree](#the-battle-tree)
- [The Tree Sets App](#the-tree-sets-app)
    - [The Trainers and Pkmn Lists](#the-trainers-and-pkmn-lists)
    - [The Details View](#the-details-view)
- [License](#license)

## The Battle Tree
The Battle Tree can be found on Poni Island in Alola, on Generation 7 of Pokémon main games. It is a facility similar to the Battle Maison, from Generation 6 games, and works in the same way: after becoming the champion of the region, the trainer can challenge the facility and try to build a long streak of victories against random NPC that appear, one after the other.

There are 3 battle formats available on the Battle Tree (single, double or multi battles), each one giving the option of 2 levels of difficulty (Normal or Super), but, although there are a lot of trainers that can appear at the Tree, these trainers, and the Pokémon sets they use against you are not random: each trainer has unique characteristics, including name, salutations (greetings, and goodbyes for whether they win or loose), Pokémon they can use, sets of these Pokémon they have access to, and minimum and maximum streak size in which they can appear, among other things.

That being said, this app aspires to be a catalogue of trainers and Pokémon the Battle Tree can throw at us during a challenge.

## The Tree Sets App
The main view of this app is a TabBar, which gives the options of listing the database by trainers (where all Pokémon Sets available to that trainer could be displayed), or by Pokémon (where all sets for each Pokémon are displayed). The last tab has a form for updating the trainers' data.

### The Trainers and Pkmn Lists
<img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/TreeSetsShot.png?raw=true" width="400"/> <img src="https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/PkmnSelected.png?raw=true" width="400"/>

The left image above shows the Trainers list. There is a search bar hidden above the list to help find a specific trainer, and it is accessible if the user pull down the list. It is possible to see the trainer category, and the verified minimum and maximum streak size when that trainer is known to appear. It is important to notice that this last information is still being collected, thus some trainers might appear out of their respective [min-max] streak interval.

Only one trainer can be selected at a time. After selecting one of them, the list of Pokémon available to them is displayed. This list is similar to the one showed at the right side of the image above. On this view, multiple Pokémon can be selected and it is possible to see the name of the chosen trainer at the top of the screen, along with two buttons: left, you can deselect all previously selected lines, and right, you can go to the Details view, where information about the selected Pokémon will be displayed.

There are around 250 different Pokémon species available to the NPC trainers on the Tree, and each of these species have up to 4 distinct sets for the NPC to own, and each set can differ in EVs distribution, held item, nature, and movesets; abilities are random, and any Pokémon have access to any of their abilities -- even unreleased ones.

As the trainers list, the Pokémon list has a hidden search bar accessed by pulling down the list. At the right of the Pokémon species name, all available sets for that species are show on a comma-separated list of ids (a number between 1 and 4 that serves as unique identification for each Pokémon Set); in case all sets for a specific Pokémon are available, "All" is displayed instead.

The Pokémon list have swipe capabilities too: swiping right will bring the Details View for the selected Pokémon, and swiping left will bring back the Trainers list.

### The Details View
There is a lot of information available on the Details view: 

![details gif](https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/details.gif?raw=true)

Since some items can interfere on Pokémons stats, it is possible to consider the effect of the item being used/lost by simply touching the held item icon on the Details view of Pokémon Sets, and the stats for that set will be updated accordingly, as shown at the image below:

![item lost](https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/itemLost.png?raw=true)

### The Update View
The Update tab has a very simple form-like interface and is used for incrementing the data about trainers, such as their sex, category, and earlier or later streak count you've found them. The search can be performed by touching the _Search_ button or by pressing _enter_.

![update view](https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/update.png?raw=true)

When ready to save the modifications, touch the _Done_ button and the new information will be saved, and the app will go back to the trainers list. There is also the option to export the data collected by the app to a csv file, which can be imported back to Tree Sets via an App Extension.

![app extension](https://github.com/cristiannomartins/Tree-Sets/blob/master/Screenshots/appExtension.png?raw=true)

## License
The source icons are © Nintendo/Creatures Inc./GAME FREAK Inc.
Everything else is licensed under the terms of the MIT license.
