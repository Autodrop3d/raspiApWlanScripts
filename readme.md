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
Just rerun the `setup_wlan_and_AP_modes.sh script with whatever you need!
