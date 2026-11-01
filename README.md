# Chat Sound Customizer

Chat Sound Customizer adds configurable sound notifications to World of Warcraft chat, so you can hear incoming messages without constantly watching the chat window.

Choose different sounds for incoming and outgoing messages, individual players, player groups, and chat channels. The required libraries and extra sound packs are included.

## Features

- Separate incoming and outgoing sounds for guild, officer, whisper, Battle.net whisper, party, raid, instance, community, say, yell, and emote messages where supported by the game client.
- Sound settings for General, Trade, Local Defense, Newcomer Chat, and custom channels.
- Custom sounds for individual players and user-defined groups of players.
- An ignore list for player names and words. Matching messages do not trigger notifications.
- A configurable notification interval to limit repeated sounds, with independent intervals for each zone or custom channel.
- Output through the Master, Sound Effects, Music, Ambience, or Dialog audio channel.
- Multiple chat types can be selected together to change their sounds in one step.
- Twelve built-in CSC sounds, Murloc Aggro, and four extra sound packs containing 148 sounds.
- Access to sounds registered by other addons through LibSharedMedia.
- Saved configuration profiles, a minimap launcher, and temporary muting.
- A LibDataBroker launcher for compatible display addons.

## Supported game versions

The addon currently declares the following interface versions:

| Game client | Interface |
| --- | ---: |
| Retail / Midnight | 120105 |
| Mists of Pandaria Classic | 50504 |
| Classic Era | 11509 |
| WoW: Forever / Camelot | 16001 |

All four clients use the same addon folder and `.toc` file. Chat types and mentor/newcomer features depend on what the client provides.

Forever support includes recognition of the player's own messages using its name and surname system. In-game validation of the recent compatibility changes is still pending. If the client restricts access to a sender's name or message text, rules that depend on that information cannot inspect it; a restricted sender is treated as an incoming message.

## Installation

1. Extract the addon into the `Interface/AddOns` folder of the WoW client you use.
2. Confirm that the resulting path is `Interface/AddOns/Chat_Sound_Customizer/Chat_Sound_Customizer.toc`.
3. Enable **Chat Sound Customizer** in the game's addon list.
4. Log in and open the configuration with `/csc ui`.

Keep the `libs`, `audios`, `icons`, `modules`, and `sound-packs` folders inside `Chat_Sound_Customizer`.

## How to use

Open the configuration by left-clicking the minimap icon or entering `/csc ui`. `/chatsound ui` opens the same window. The addon also registers a page in the game's addon settings.

1. Open **Chat** and select the chat type you want to configure.
2. Choose a sound for receiving messages and, optionally, another sound for sending messages. Select **None** to leave that direction silent.
3. Choose the audio output channel and notification interval. The interval is measured in milliseconds; `1000` means one second.
4. Use **Multi Selection** to apply a sound to several chat types together.

Use **Customized** to add individual players or create groups with their own sounds. Use **Custom Channel** for named chat channels, and **Ignore List** to suppress notifications from specific players or messages containing ignored words. Option names are translated in supported locales.

Ignored words are case-sensitive and matched with word boundaries. Characters such as `%`, `[` and `+` are treated literally.

Right-click the minimap icon to mute or unmute the addon temporarily. Temporary mute resets after reloading the UI. The configuration also lets you hide the minimap icon and manage saved profiles.

## Sound packs

All four bundled packs are **enabled by default**:

| Pack | Sounds |
| --- | ---: |
| Effect Pack 01 | 61 |
| Notification Pack 01 | 48 |
| Notification Pack 02 | 27 |
| StarCraft Pack | 12 |
| **Total** | **148** |

Open **Sound packs** in the configuration to enable or disable individual packs, then click **Reload UI** or enter `/reload` to apply the change.

Pack preferences apply to all configuration profiles. Disabling a pack preserves your saved sound selections, but its sounds become unavailable after reloading until you enable it again. Enabling a pack adds its sounds to the selection lists; it does not replace your configured notifications.

The packs are integrated into the main addon and do not need separate installation. Enabled packs register their sounds with LibSharedMedia, making them available to other compatible addons as well.

## Languages

The source includes English and Brazilian Portuguese text. Missing translations fall back to English. Release packaging also includes localization hooks for additional languages.

## Development

The sound-pack regression tests cover enabled defaults, saved preferences, reload behavior, independent activation, registration paths, and the 148 bundled sounds. Run them from the addon directory with Lua 5.3 or later:

```sh
lua tests/sound_packs.lua
```

The tests simulate the addon environment. Actual audio playback and client-specific behavior must be checked in WoW.

## Support

See the [changelog](CHANGELOG.md) for release history.

Please report problems through the [GitHub issue tracker](https://github.com/Canettieri/chat-sound/issues). Include the WoW game version, character locale, any error message, and the chat type or sound pack involved.

## Credits

Created by Canettieri and Eliote.

## Donations

If you would like to support continued development, you can [donate through PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=7AEAZ7XG7WVDS&lc=US&item_name=Chat%20Sound%20Customizer&currency_code=USD).
