# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0] - 2026-11-01

In-game validation of audio playback and the recent Retail and Forever compatibility changes is still pending.

### Added

- WoW: Forever / Camelot interface declaration (16001) and outgoing-message detection using the character name and surname API, with the previous name comparison retained as a fallback.
- Four integrated sound packs containing 148 extra sounds: Effect Pack 01 (61), Notification Pack 01 (48), Notification Pack 02 (27), and StarCraft Pack (12).
- A Sound packs settings page with individual toggles and a Reload UI button, including Brazilian Portuguese text. All packs are enabled by default; preferences are saved across configuration profiles and applied after reloading the UI.
- A README covering features, installation, configuration, game interfaces, sound packs, and support.
- Sound-pack regression tests covering defaults, saved preferences, reload behavior, independent activation, registration paths, and sound counts.

### Changed

- Updated the Retail interface declaration from 120007 to 120105. Retained Mists of Pandaria Classic (50504) and Classic Era (11509).
- Integrated the sound-pack definitions directly into the main addon.
- Sound playback now reads directly from LibSharedMedia instead of depending on the sound-selection widgets' global table.
- Excluded development tests from release packages.
- Adopted the Keep a Changelog structure in `CHANGELOG.md` and configured tagged releases to publish only the matching version's notes.

### Fixed

- Ignored words now treat Lua pattern characters, such as `%`, `[` and `+`, literally while preserving existing case-sensitive word-boundary matching.
- Zone and custom channels now use independent notification intervals, so activity in one channel does not suppress another channel's notifications through the shared CHAT_MSG_CHANNEL timer.
- Missing or invalid sound references are skipped before playback. Failed playback attempts no longer consume the notification interval.
- Channel-specific rules now ignore unrelated chat events and avoid inspecting restricted channel names, IDs, or sender flags.
- Player-specific and ignore-list rules now skip invalid or restricted sender names safely.
- Added a local fallback for clients without the secret-value inspection function.
- Zone and Newcomer Chat settings no longer require their chat colors to be initialized before displaying their labels.

### Removed

- Removed the four standalone sound-pack manifests and four redundant startup files. Each integrated pack now uses one sound-definition file and its audio assets.

## [2.7.1] - 2026-08-02

### Changed

- Updated game interface declarations.

## [2.7] - 2026-02-13

### Changed

- Updated game interface declarations.

### Fixed

- Skipped restricted message text and sender names in rules that need to inspect those values.

[3.0.0]: https://github.com/Canettieri/chat-sound/releases/tag/v3.0.0
[2.7.1]: https://github.com/Canettieri/chat-sound/releases/tag/v2.7.1
[2.7]: https://github.com/Canettieri/chat-sound/releases/tag/v2.7
