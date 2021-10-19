PUT ALL THIS SCRIPTS TO YOUR ~/eggdrop/scripts directory

ENJOY: 

./scripts/g_base64.tcl
./scripts/g_ircv3.tcl
./scripts/g_cap.tcl
./scripts/http-title.tcl
./scripts/0dev.tcl
./scripts/g_scram.tcl
./scripts/g_atheme_need.tcl
./scripts/g_pbkdf2.tcl

Eggdrop 1.8 SASL script:

    For convenience, download this entire repository with git clone https://github.com/grawity/eggdrop-sasl

    Get Eggdrop 1.8 from Git. Compile and install.

    The preinit-server patch was merged into Eggdrop 1.8 recently, so you do not need to patch it manually anymore.

    From your Eggdrop config, source the scripts and set the SASL information.

    source "scripts/eggdrop-sasl/g_base64.tcl"
    source "scripts/eggdrop-sasl/g_cap.tcl"

    set sasl-user "username"              #### EDIT THIS AT 0dev.cfg --- your freenode username
    set sasl-pass "password"              #### EDIT THIS AT 0dev.cfg ---- your freenode password  

(For those who still need it, the patch for 1.6.x is still there.)
SCRAM-SHA support

    To enable support for SCRAM-SHA-1 or SCRAM-SHA-256, first ensure tcllib is installed, then load two additional scripts:

    source "scripts/eggdrop-sasl/g_pbkdf2.tcl"
    source "scripts/eggdrop-sasl/g_scram.tcl"

    set sasl-mechanism "SCRAM-SHA-256"

    Connect to the server. Note that the first connection attempt will need to generate the authentication token using PBKDFv2, which is very slow in Tcl so the server may time out. Just wait for Eggdrop to retry, and the second attempt should work fine.

    To improve security and to avoid the initial connection delay, you should remove the plaintext password from your eggdrop.conf and replace it with the generated token.

    You can find this token in your Eggdrop logs, or by running .tcl set sasl-pass on the console after a successful connection. The token will look like this:

    set sasl-pass "scram:a=sha256,s=<etc>,i=<etc>,H=<etc>"

    Note: The script will try to automatically add the token to your config, (although it won't remove the plaintext password – you'll have to do that manually).
