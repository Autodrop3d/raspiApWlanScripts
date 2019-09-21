# Raspberry Pi Wlan/AP Mode Switching Scripts

#### What's all this then?
Well, as the title here says, these scripts enable a Paspberry Pi to switch between station mode (connect to an access point) and Access Point mode (it **_is_** an access point) without needing to reboot the Pi.

#### Ok... Why would I want that?
Well let's say that you want to have a Pi embedded in a thing that has no interface for a user to configure it. You could have a button connected to the Pi that triggers it to switch to AP mode. Then the user can connect to it with their smartphone or whatever and browse to a webserver (that you provide separately!) hosted by the Pi. Or maybe you just want to be able to demo some network functionality when you're not in range of your home or office router.

#### Neat. So how do I make it work?
Run this script as root. Use the -h flag to see usage info.

`./setup_wlan_and_AP_modes.sh -s <station mode SSID> -p <station mode password> -a <AP mode SSID> -r <AP mode password>`

By default, the Pi will boot into station mode. You can change this by including the -d flag when running this script. 

After running this script, you should reboot your Pi.

#### Then...
You can run the `switchToAP.sh` or `switchToWlan.sh` scripts (as root) to do what they say.

#### What if I want to change the station mode AP and passwords later?!
Just rerun the setup_wlan_and_AP_modes.sh script with whatever you need!

---

## Some impartant notes

### These scripts are presently written to work in the US only.
**But** if you live in another country, you can still make this work for you! You only need to edit the country codes. This can be done in two ways: Edit the setup script before running it **OR** edit the wpa-supplicant files after running the setup script.

#### Option 1: Edit the setup script
Simply search for the phrase `country=US`and replace it with `country=XX` where `XX` is **your** two letter country code. There are two places where you must make this change.

#### Option 2: Edit the wpa-supplicant files after running the setup script
As root, edit two files, both are in the /etc/wpa_supplicant/ directory:
1. wpa_supplicant-wlan0.conf

   This file is used for configuration when the Pi is in station mode (connecting to an access point). As above, replace `country=US` with whatever is appropriate for you.

2. wpa_supplicant-ap0.conf

   This file is used for configuration when the Pi is in AP mode (acting as an access point). Just as with the other wpa_supplicant file, edit the contry code as appropriate.

### This script sets an AP mode IP address that you might not like.
That's just like, your opinion, man. I like using 192.168.4.1. But if you don't, that's ok. You can choose whatever IP address you want to use by either editing the script or editing a file after you run the script.

#### Option 1: Edit the setup script
Simply search for the phrase `192.168.4.1` and replace it with your preferred IP address.

#### Option 2: Edit /etc/systemd/network/12-ap0.network
Same as the last option. Search this file for `192.168.4.1` and replace it with your preferred IP address.
