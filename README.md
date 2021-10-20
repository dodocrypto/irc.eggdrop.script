[ 0DAY (xc) Our ] v1.0  Production Released 

#Make sure Tcl AND it’s dev packages are installed on your #system. On Debian-based systems, this is done with:

sudo apt-get install tcl tcl-dev

#It is also STRONGLY recommended to have openssl installed, #to enable SSL/TLS protection:

sudo apt-get install openssl libssl-dev

##### TO USE IT :
Download Lastest eggdrop
Currently 1.8.4 : https://www.eggheads.org/
wget http://ftp.eggheads.org/pub/eggdrop/source/1.8/eggdrop-1.8.4.tar.gz

#### Installing
tar -zxvf eggdrop-1.8.4.tar.gz
cd eggdrop-1.8.4
./configure
./make config
./make 
./make install

##### To Support SSL
./make sslcert

#### Setting Up
cd ~/eggdrop
mv 0dev.cfg at ~/eggdrop
mv alltools.tcl scripts/alltools.tcl
mv action.fix.tcl scripts/action.fix.tcl
mv 0dev.tcl scripts/0dev.tcl
mv urltitle scripts/urltitle.tcl
mv g_base64.tcl scripts/g_base64.tcl
mv gcap.tcl scripts/g_cap.tcl

### EDIT SETTING ###

vi ~/eggdrop/0dev.cfg

### Start IT With
cd ~/eggdrop
./eggdrop -m ./0dev.cfg


contact : https://discord.me/0dev or irc.libera.chat channel #0dev


