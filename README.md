# Docker OpenTTD patchpack

This is a docker container to run a gameplay server for OpenTTD JGR patchpack.

---
OpenTTD is a transport simulation game based upon the popular game Transport Tycoon Deluxe, written by Chris Sawyer. It attempts to mimic the original game as closely as possible while extending it with new features.

See [official OpenTTD website](https://www.openttd.org).

---
OpenTTD Patchpack is a special release with a collection of patches applied to OpenTTD to add of some features.

See [official OpenTTD patchpack repository](https://github.com/JGRennison/OpenTTD-patches)

---

## Enviroment variables

### DEBUG

See [official OpenTTD documentation](https://wiki.openttd.org/Debugging) for possible values

### COPY_CONFIG

Copies all content of provided directory, used for import data inside a docker volume.

### BAN_LIST

Filename that contains list of banned user

### LOADGAME

Define if load a savegame, possible values:
- false start a new game every times
- last-autosave load last autosave gameplay
- exit load autosave on exit
- {savename} load passed filename of saved gameplay

### SCENARIO

When start a new game, load specified filename scenario


