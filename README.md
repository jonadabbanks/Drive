# Drive-Bot
# A Software Bot that prevents File Copying  via Bluetooth,Usb ports, Usb cable, Wireless transfer (Wifi) & File sharing via network port.

# Program Written by:  Chigozie Jonadab Emmanuel.
# Built for  Microsoft Powershell,Cmd,RPA Technology & Python 
# Built with  Windows 11

# Machines Supported: Windows 7,10 & 11
                                                  USAGE
# REGISTRATION :   Drive has a Gui interface where a User Registers their Devices (flash_drives,hard_drives,smart_phones, bluetooth_devices etc).After registration, the devices are saved and will be used by the bot as a paremeter to filter out unregistered drives.At the backend, the bot runs in the background, checking each paremeters provided making sure that no devices are allowed into the system without permission.

# ALERT : When an unregistered device is detected, drive sends a mail to the end user, Alerting them of a plugged in device. telling them if its a phone,bluetooth or external drives (flash,ssd,hdd).  drive takes the picture of the intruder (depends on how close the intruder is to the webcam)

# REMOVAL:  When an unregistered device is detected, drive automatically removes it. for example: when an unregistered flash drive or phone is detected, the device is removed, and drive outputs a password for to be entered. until the password is correct, the removed device will not be accesible while still plugged in. when the correct password is entered, the removed device is brought back and can be used to copy files. This process works for devices plugged to the system using a usb port.

