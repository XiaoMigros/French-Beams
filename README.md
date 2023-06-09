# [French Beams](https://musescore.org/en/project/french-beams)
A plugin for MuseScore 3 & 4 that creates/removes French Beams.

**Before**
![Before running the plugin](/examples/before.png)

**After**
![After running the plugin](/examples/after.png)

## Changelog
### v2.0 (2023-09-06)
- The plugin now accounts for surrounding notes when calculating the stem length, sizing stems on the edge of beams or sub-beams appropriately.

## Usage
Select the notes of which you wish the beam length to change (or the whole score), and run the plugin. <br>Running once will create French beams, running the plugin again will remove them.

## Note for MuseScore 4 Users
If you are using MuseScore 4 and your score has the 'Beam Distance' option set to 'Wide', you will need to set the 'useWideBeams' variable to true.

## Installation
Download the [latest release](https://github.com/XiaoMigros/french-beams/archive/main.zip) and move the file(s) to MuseScore's 'Plugins' folder, then follow the standard plugin installation process for your MuseScore version.
[Guide for MuseScore 3](https://musescore.org/handbook/3/plugins#installation) | [Guide for MuseScore 4](https://musescore.org/handbook/4/plugins#installation)
