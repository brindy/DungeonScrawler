# DungeonScrawler

A procedurally generated, text based, rogue like game written in Swift.

## Building

You need the Swift compiler installed then run:

`swift build`

## Running

After building run using:

`.build/debug/DungeonScrawler`

You can also pass a seed as the only parameter.

## Scripts

The scripts rebuild and then run the app in some way:

* `maps.sh` will generate maps from level 1 to 10 for a random seed (or seed taken as an argument)
* `play.sh` will play the game for a random seed (or seed taken as an argument)

