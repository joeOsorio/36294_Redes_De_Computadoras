# Laboratorio


- 1 buscar y actualizar ficheros

sudo apt update

- 2 Instalar la herramienta de wireless-tools
sudo apt install wireless-tools

- 3 iwconfig

- 4 iw dev Interface

- 5 sudo airmon-ng

- 6 sudo airmon-ng check

- 7 sudo airmon-ng start wlan0

- 8 sudo wifite --kill

- 9 sudo airmon-ng stop wlan0

- 10 sudo system restart NetworkManager

- 11 sudo apt install hcxdumptool

- 12 sudo apt install hcxtools

- 13 sudo wifite --help

- 14 sudo wifite --kill

// nota cambiar kalijoe por tu usuario
- 15  cp /usr/share/wordlists/rockyou.txt.gz /home/kali/Desktop/
- 16  gunzip /home/kalijoe/Desktop/rockyou.txt.gz
- 17 sudo wifite --kill --dict /home/kalijoe/Destop/rockyou.txt

# investigar que hacen

- wps pixie-dust
- wps NULL PIN
- wps Pin attack
- pmkid: capture
- wpa: handshake