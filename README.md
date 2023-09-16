# Vehicle Whitelist v3
> Advanced FiveM Vehicle Whitelist System

All code has been redone from scratch and uses sql instead of badgerAPI. This script contains a simple and straight forward config file that allows server developers to whitelist a vehicle to a specific player via their discord ID, which then allows them to use the in game trust system features. The trust system contains two command; `/trust` *(trust a specified player via their in game ID to have access to your whitelisted vehicle)* and `/untrust` *(revoke a specified player via their in game ID access to your whitelisted vehicle)* - both commands are configurable via the config file. All trust data is stored via a SQL database then stored in an array locally on the client *(trusted vehicle data is collected upon the player joining the server).*<br><br>

### Dependencies
- [menuv](https://github.com/ThymonA/menuv/releases/tag/v1.4.1)
 
### Features:

- Standalone
- Easy to setup config file, which has a brief description of what all config options will do.
- User friendly - easy and straight forward to use.
- Optimised (0ms) - minimal performance impact on the client.
- SQL data storing.
- Auto database setup
- Ability to limit how many times a player can trust another player to use their whitelisted vehicle.
- A user friendly, easy to navigate menu that shows all vehicles a player has access to.

*And much more!*
