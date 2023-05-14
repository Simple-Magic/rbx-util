---
sidebar_position: 1
---

# Getting Started

These Roblox utility modules can be acquired using [Wally](https://wally.run/), a package manager for Roblox.

## Wally Configuration

Once Wally is installed, run `wally init` on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a `wally.toml` file for a project that includes a few of these modules:

```toml
[package]
name = "your_name/your_project"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Maid = "rasmusmerzin/maid@1"
Repository = "rasmusmerzin/repository@1"
StackQueue = "rasmusmerzin/stackqueue@1"
compose = "rasmusmerzin/compose@1"
```

To install these dependencies, run `wally install` within your project. Wally will create a Package folder in your directory with the installed dependencies.

## Rojo Configuration

The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:

```json
{
  "name": "rbx-util-example",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "Packages": {
        "$path": "Packages"
      }
    }
  }
}
```

## Usage Example

The installed dependencies can now be used in scripts, such as the following:

```lua
-- Reference folder with packages:
local Packages = game:GetService("ReplicatedStorage").Packages

-- Require the utility modules:
local Repository = require(Packages.Repository)

-- Use the modules:
local ProfileRepository = Repository.new({ Name = "Profiles" })

function ProfileRepository.Entity:Start(player: Player?)
	if player then self.DisplayName = player.DisplayName end
end
```
