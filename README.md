[ 0DAY (xc) Our ] v1.0  Production Released 

#Make sure Tcl AND it’s dev packages are installed on your #system. On Debian-based systems, this is done with:

sudo apt-get install tcl tcl-dev

#It is also STRONGLY recommended to have openssl installed, #to enable SSL/TLS protection:

sudo apt-get install openssl libssl-dev

##### TO USE IT :
1. Download Lastest eggdrop
2. Currently 1.9.1 : https://www.eggheads.org/
3. wget https://ftp.eggheads.org/pub/eggdrop/source/1.9/eggdrop-1.9.1.tar.gz

#### Installing
1. tar -zxvf eggdrop-1.9.1.tar.gz
2. cd eggdrop-1.9.1
3. ./configure
4. ./make config
5. ./make 
6. ./make install

##### To Support SSL
1. ./make sslcert

#### Setting Up
1. cd ~/eggdrop
2. mv 0dev.cfg at ~/eggdrop
3. mv 0dev.tcl scripts/0dev.tcl
4. mv urltitle scripts/urltitle.tcl


### EDIT SETTING ###

1. vi ~/eggdrop/0dev.cfg

### Start IT With
1. cd ~/eggdrop
2. ./eggdrop -m ./0dev.cfg

### Contact us
1. contact : https://discord.me/0dev 
2. ircs://irc.libera.chat channel #0dev
3. irc.libera.chat channel #0dev

