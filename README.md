# signal100-parkingBreakScript
A FiveM script to automatically handle parking brake functionality and vehicle signals for roleplay servers.
Make sure to join our discord at https://discord.gg/s100
---

# Signal 100 Studios -parkingBreakScript

A FiveM script that adds realistic parking brake behavior for vehicles in roleplay servers.

## Features

* Press **G** to toggle the parking brake.
* Vehicles will **roll forward** if the parking brake is not engaged while stopped.
* Leaving the vehicle without engaging the parking brake will also cause it to roll.
* Fully customizable for server roleplay realism.

## Installation

1. Download this repository:
2. Copy the folder to your FiveM server's `resources` directory.
3. Add the resource to your `server.cfg`:

   ```
   ensure signal100-parkingBreakScript
   ```
   
4. Restart your server or start the resource manually:

   ```
   start signal100-parkingBreakScript
   ```

## Usage

* While inside a vehicle, press **G** to engage or release the parking brake.
* If the vehicle is stopped and the parking brake is not on, it will roll forward.
* If you exit the vehicle without engaging the parking brake, it will also roll.

## Configuration

* You can adjust key bindings or behavior in the `config.lua` file.
* Script is lightweight and does not affect other vehicle systems.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---
