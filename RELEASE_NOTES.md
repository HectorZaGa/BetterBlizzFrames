# BetterBlizzFrames 2.0.0d
## The Burning Crusade
### Bugfix
- Fix party frame alpha setting not sticking on reloads. (This needs a few more tweaks, for pet frames etc, need to look at blizz code)

# BetterBlizzFrames 2.0.0c
## The Burning Crusade
### Bugfix
- Fix some errors and do some early adjustments for the new TBC patch. Please report issues.

# BetterBlizzFrames 2.0.0b
## Midnight
### Tweak
- OCD Tweaks: Change the position of level text slightly for Player/Target/FocusFrame. Should hopefully be properly positioned for everyone now.
## The Burning Crusade
### Tweak
- Add a fix for Blizzards sloppy code that positions FocusFrame healthbar center statusbar text wrong if the frame was small (Large Frame disabled in Edit Mode).

# BetterBlizzFrames 2.0.0
## Midnight
### New
- Add buff/debuff max limit setting for Target/Focus in Buffs & Debuffs section.
- Add Personal Resource Display settings. Legacy Style PRD that reverts the look back to how it was pre 12.0.7 (Misc) and re-texture settings (Font & Texture). These settings already exist in BBP but now also in BBF for people without BBP.
### Tweak
- Add a workaround fix to stop showing double names when HealthBarColor addon was also enabled.
- Add a workaround fix for "Arena Names" for ToT frame names.
- Fix "Stealth Indicator" texture for the no portrait settings.
- Some minor tweaks for Classic Frames setting (gaps around bars)
- Update Nahj profile (www.twitch.tv/nahj)
- Update Dissonance profile (www.twitch.tv/dissonancewow)
### Bugfix
- Classic Frames: Fix statusbar text and level text not being positioned correctly on chinese client with Classic Frames setting on.
- Fix potential lua error from entering/leaving arena while in combat with Minimap Hider setting on.
- Fix purge texture recolor not working.
## The Burning Crusade
### Tweak
- Remove Wyvern Sting DoT (not CC) spell ids from LoC CC list.