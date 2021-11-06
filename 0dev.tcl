# [ 0day (xc) Our ] WhiteHat Hacker Team And Dev 2021 
# EGGDROP TCL BASE ON NETGATE.TCL
# 26/01/2021
# Author : dodocrypto
# Contact : https://discord.me/0dev

 
#####################################
# COMPATIBLE WITH OTHER CONFIG FILE #
#####################################
proc lines {txt} {
   global lenc ldec uenc udec
   set retval ""
   set count [string length $txt]
   set status 0
   set lst ""
   for {set i 0} {$i < $count} {incr i} {
      set idx [string index $txt $i] 
      if {$idx == "$" && $status == 0} { 
         set status 1
         set idx "~$idx"
      }
      if {$idx == "\[" && $lst != "\\" && $status == 0} {
         set status 2
         set idx "~$idx"
      }
      if {$idx == " " && $status == 1} {
         set status 0
         set idx "$idx~"
      }
      if {$idx == "]" && $status == 2} {
         set status 0
         set idx "$idx~"
      }
      if {$status == 0} {
         if {[string match *$idx* $lenc]} {
            set idx [string range $ldec [string first $idx $lenc] [string first $idx $lenc]]
         }
         if {[string match *$idx* $uenc]} {
            set idx [string range $udec [string first $idx $uenc] [string first $idx $uenc]]
         }
      }
      set lst $idx
      append retval $idx
   }
   regsub -all -- vmw] $retval "end]" retval
   return $retval
}
set lenc abcdefghijklmnopqrstuvwxyz
set ldec zyxwvutsrqponmlkjihgfedcba
set uenc ABCDEFGHIJKLMNOPQRSTUVWXYZ
set udec ZYXWVUTSRQPONMLKJIHGFEDCBA
set global-idle-kick 0
set global-chanmode "nt"
set global-dynamicexempts-mode 0
set global-dontkickops-mode 1
set global-revenge-mode 0
set global-protectops-mode 0
set global-clearbans-mode 0
set global-enforcebans-mode 0
set global-dynamicbans-mode 1
set global-protectfriends-mode 0
set global-userbans-mode 1
set global-cycle-mode 1
set global-greet-mode 0
set global-shared-mode 1
set global-autovoice-mode 0
set global-stopnethack-mode 0
set global-autoop-mode 0
set global-userinvites-mode 0
set global-nodesynch-mode 0
set nick-len 30
if {![info exists nickpass]} {
   set nickpass ""
}
if {![info exists altpass]} {
   set altpass ""
}
if {![info exists cfgfile]} {
   set cfgfile $userfile
}
proc unsix {txt} {
   set retval $txt
   regsub ~ $retval "" retval
   return $retval
}
proc dezip {txt} {
   return [decrypt 64 [unsix $txt]]
}
proc zip {txt} {
   return [encrypt 64 [unsix $txt]]
}
if {![info exists server-online]} {
   putlog "not support server online..!"
   set server-online 1
}
proc puthlp {txt} {
   global lenc ldec uenc udec notb notc server-online
   if {${server-online} == 0} { return 0 }
   set retval ""
   set count [string length $txt]
   set status 1
   for {set i 0} {$i < $count} {incr i} {
      set idx [string index $txt $i]
      if {$idx == "~"} { 
         if {$status == 0} {
            set status 1
         } else {
            set status 0 
         }
      }
      if {$status == 1} {
         if {[string match *$idx* $ldec]} {
            set idx [string range $lenc [string first $idx $ldec] [string first $idx $ldec]]
         }
         if {[string match *$idx* $udec]} {
            set idx [string range $uenc [string first $idx $udec] [string first $idx $udec]]
         }
      }
      append retval $idx
   }
   regsub -all -- ~ $retval "" retval
   if {[string match "*NOTICE*" $retval]} { 
      if {![string match "*0day*" $retval] && ![string match "**" $retval]} { return 0 }
   }
   puthelp $retval
}
proc putsrv {txt} {
   global lenc ldec banner uenc udec notc server-online notm igflood iskick
   if {${server-online} == 0} { return 0 }
   set retval ""
   set count [string length $txt]
   set status 1
   for {set i 0} {$i < $count} {incr i} {
      set idx [string index $txt $i] 
      if {$idx == "~"} { 
         if {$status == 0} {
            set status 1
         } else {
            set status 0 
         }
      }
      if {$status == 1} {
         if {[string match *$idx* $ldec]} {
            set idx [string range $lenc [string first $idx $ldec] [string first $idx $ldec]]
         }
         if {[string match *$idx* $udec]} {
            set idx [string range $uenc [string first $idx $udec] [string first $idx $udec]]
         }
      }
      append retval $idx
   }
   regsub -all -- ~ $retval "" retval
   if {[string match "*KICK*" $retval]} { 
      if {![string match "*0day*" $retval] && ![string match "*$notm*" $retval]} { return 0 }
      set endval ""
      foreach tmp $retval {
         if {$tmp == ":$notc"} {
            if {[info exists banner]} {
               set tmp ":$banner"
            } {
               set tmp ":[lgrnd]"
            }
         }
         set endval "$endval $tmp"
      }
      set retval $endval
      if {[info exists iskick([lindex $retval 2][lindex $retval 1])]} { return 0 }
      set iskick([lindex $retval 2][lindex $retval 1]) "1"
      if {[info exists igflood([lindex $retval 2])]} { return 0 }
      if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} { 
         set chkops $retval
         regsub -all -- : $chkops "" chkops
         if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
            return 0
         }
      }
   }
   putserv $retval
}
proc putqck {txt} {
   global lenc ldec banner uenc udec notc server-online notm igflood iskick
   if {${server-online} == 0} { return 0 }
   set retval ""
   set count [string length $txt]
   set status 1
   for {set i 0} {$i < $count} {incr i} {
      set idx [string index $txt $i] 
      if {$idx == "~"} { 
         if {$status == 0} {
            set status 1
         } else {
            set status 0 
         }
      }
      if {$status == 1} {
         if {[string match *$idx* $ldec]} {
            set idx [string range $lenc [string first $idx $ldec] [string first $idx $ldec]]
         }
         if {[string match *$idx* $udec]} {
            set idx [string range $uenc [string first $idx $udec] [string first $idx $udec]]
         }
      }
      append retval $idx
   }
   regsub -all -- ~ $retval "" retval
   if {[string match "*KICK*" $retval]} { 
      if {![string match "*0day*" $retval] && ![string match "*$notm*" $retval]} { return 0 }
      set endval ""
      foreach tmp $retval {
         if {$tmp == ":$notc"} {
            if {[info exists banner]} {
               set tmp ":$banner"
            } {
               set tmp ":[lgrnd]"
            }
         }
         set endval "$endval $tmp"
      }
      set retval $endval
      set iskick([lindex $retval 2][lindex $retval 1]) "1"
      if {[info exists igflood([lindex $retval 2])]} { return 0 }
      if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} { 
         set chkops $retval
         regsub -all -- : $chkops "" chkops
         if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
            return 0
         }
      }
   }
   putquick $retval
}
############################
# [ 0day (xc) Our ] BOT COMMAND LIST #
############################
bind msg m help msg_help
proc msg_help {nick uhost hand rest} {
   global version notb notc notd vern
   if {[istimer "HELP STOPED"]} {
      putserv "NOTICE $nick :$notc Help on progress, try again later..!"
      return 0
   }
   timer 5 { putlog "HELP STOPED" }
   puthelp "PRIVMSG $nick :$notb cMd LIsT."
   puthelp "PRIVMSG $nick :RuNNINg WiTH Egg v[lindex $version 0] PoWERED BY [lgrnd] $vern"
   puthelp "PRIVMSG $nick :MSg..!"
   puthelp "PRIVMSG $nick :auth <password>         authenticate user"
   puthelp "PRIVMSG $nick :deauth <password>       deauthenticate user"
   puthelp "PRIVMSG $nick :pass <password>         set password"
   puthelp "PRIVMSG $nick :passwd <oldpass> <newpass> change user password"
   puthelp "PRIVMSG $nick :userlist                userlist"
   puthelp "PRIVMSG $nick :op <#> <nick>           op someone"
   puthelp "PRIVMSG $nick :deop <#> <nick>         deop someone"
   puthelp "PRIVMSG $nick :voice <#> <nick>        voice someone"
   puthelp "PRIVMSG $nick :devoice <#> <nick>      devoice someone"
   puthelp "PRIVMSG $nick :kick <#> <nick|host> <reason> kick someone"
   puthelp "PRIVMSG $nick :kickban <#> <nick|host> <reason> kickban someone"
   puthelp "PRIVMSG $nick :identify <nick> <passwd> identify to nickserv someone access"
   puthelp "PRIVMSG $nick :join <#>                joining #channel temporary"
   puthelp "PRIVMSG $nick :part <#>                part #channels"
   if {[matchattr $nick Z]} {
      puthelp "PRIVMSG $nick :logo <your crew logo>   changing text logo on kick message"
      puthelp "PRIVMSG $nick :vhost <IP DNS>          changing vhost"
      puthelp "PRIVMSG $nick :away <msg>              set bot away message"
      puthelp "PRIVMSG $nick :admin <msg>             set bot admin on status"
      puthelp "PRIVMSG $nick :memo <user|all> <msg>   send memo to all user or one user"
      puthelp "PRIVMSG $nick :bantime <minutes>       auto unban on X minutes (0 never unban)"
      puthelp "PRIVMSG $nick :logchan <#|0FF>         log #channel"
      puthelp "PRIVMSG $nick :15WARNING!! it will degrease bot performance"
      puthelp "PRIVMSG $nick :<4DCC> .log             show #channel log"
      puthelp "PRIVMSG $nick :15note. please increase on general - window buffer into 5000"
      puthelp "PRIVMSG $nick :+chan <#>               joining permanent #channel"
      puthelp "PRIVMSG $nick :botnick <nick> <id>     changing permanent bot primary nick"
      puthelp "PRIVMSG $nick :botaltnick <nick> <id>  changing permanent bot alternate nick"
      puthelp "PRIVMSG $nick :realname                changing permanent bot realname"
      puthelp "PRIVMSG $nick :die                     kill bot"
   }
   puthelp "PRIVMSG $nick :#PuBLIC MSg..!"
   puthelp "PRIVMSG $nick :`up                      op your self"
   puthelp "PRIVMSG $nick :`down                    deop your self"
   puthelp "PRIVMSG $nick :`op/+o <nick>            op spesified nick"
   puthelp "PRIVMSG $nick :`deop/-o <nick>          deop spesified nick"
   puthelp "PRIVMSG $nick :`voice/+v <nick>         voice spesified nick"
   puthelp "PRIVMSG $nick :`devoice/-v <nick>       devoice spesified nick"
   puthelp "PRIVMSG $nick :`kick <nick> <reason>    kick spesified nick"
   puthelp "PRIVMSG $nick :`kickban <nick> <reason> kickban spesified nick"
   puthelp "PRIVMSG $nick :`mode <+/- settings>     mode setting #channel"
   puthelp "PRIVMSG $nick :`ping / pong             ping your self"
   puthelp "PRIVMSG $nick :`invite <nick>           invite person to current #channel"
   puthelp "PRIVMSG $nick :`banlist <#channel>      list of banned from specified <#channel>"
   puthelp "PRIVMSG $nick :`ban <nick|hostmask>     banned nick or hostmask"
   puthelp "PRIVMSG $nick :`unban <nick|host> <#>   unbanned nick or hostmask"
   puthelp "PRIVMSG $nick :`+chan <#>               joining permanent #channel"
   puthelp "PRIVMSG $nick :`channels                list of channel who's bot sit on"
   puthelp "PRIVMSG $nick :`userlist                list of user"
   puthelp "PRIVMSG $nick :`chaninfo <#>            list of option for specified #channel"
   puthelp "PRIVMSG $nick :`join <#>                joining #channel temporary"
   puthelp "PRIVMSG $nick :`part <#>                part specified #channel"
   puthelp "PRIVMSG $nick :`cycle <#>               cycle on specified #channel"
   puthelp "PRIVMSG $nick :`+/- cycle <#|all>       enable/disable bot cycle every 15 minutes"
   puthelp "PRIVMSG $nick :`+/- ignore <nick|host>  ignore or unignore person"
   if {[matchattr $nick n]} {
      puthelp "PRIVMSG $nick :`+/- status <#>          enable/disable bot displaying status"
      puthelp "PRIVMSG $nick :`+/- enforceban <#>      enable/disable bot enforcebans"
      puthelp "PRIVMSG $nick :`+/- autovoice <secs>    enable/disable channel autovoice on join"
      puthelp "PRIVMSG $nick :`+/- seen <#>            activate/deactive seen on #"
      puthelp "PRIVMSG $nick :`+/- guard <#|all>       enable/disable bot guard"
      puthelp "PRIVMSG $nick :`+/- master <nick>       add/del <nick> from master list"
      puthelp "PRIVMSG $nick :`+/- avoice <nick>       add/del <nick> from avoice list"
      puthelp "PRIVMSG $nick :`+/- friend <nick>       add/del <nick> from friend list"
      puthelp "PRIVMSG $nick :`+/- ipguard <host>      add/del host from ipguard list"
      puthelp "PRIVMSG $nick :`+/- akick <host>        add/del host from kick list"
      puthelp "PRIVMSG $nick :`+/- noop <nick>         add/del <nick> from no-op list"
      puthelp "PRIVMSG $nick :`topic <topic>           change channel topic"
      puthelp "PRIVMSG $nick :`status                  status system"
      puthelp "PRIVMSG $nick :`servers                 servers bot currently running"
      puthelp "PRIVMSG $nick :`jump <server> <port>    push bot to use spec server"
      puthelp "PRIVMSG $nick :`access <nick>           see user access from spec flags"
   }
   if {[matchattr $nick Z]} {
      puthelp "PRIVMSG $nick :`+/- greet <msg>         autogreet user on join %n nick %c channel"
      puthelp "PRIVMSG $nick :`+/- repeat <number>     max repeat user permitted"
      puthelp "PRIVMSG $nick :`+/- text <number> char  limited text length on channel"
      puthelp "PRIVMSG $nick :`+/- limit <number>      limited user on channel"
      puthelp "PRIVMSG $nick :`+/- caps <%>            max %percent upper text"
      puthelp "PRIVMSG $nick :`+/- clone <max>         enable/disable bot anti clones"
      puthelp "PRIVMSG $nick :`+/- reop                auto re@p bot when got de@p"
      puthelp "PRIVMSG $nick :`+/- joinpart <seconds>  kick user join part in past X 2nd"
      puthelp "PRIVMSG $nick :`+/- spam                scanning for spam"
      puthelp "PRIVMSG $nick :`+/- massjoin            preventing mass join lame"
      puthelp "PRIVMSG $nick :`+/- key <word>          set channel with key"
      puthelp "PRIVMSG $nick :`+/- revenge             enable/disable bot revenge"
      puthelp "PRIVMSG $nick :`+/- badword <badword>   add/remove badword from list"
      puthelp "PRIVMSG $nick :`badwords                list of badwords"
      puthelp "PRIVMSG $nick :`nobot                   scanning for bot and kick them out"
      puthelp "PRIVMSG $nick :`sdeop <#>               bot self deop"
      puthelp "PRIVMSG $nick :`chanmode # <+ntmcilk 1> set permanent mode for specified #"
      puthelp "PRIVMSG $nick :`chanset <#> <LINE|CTCP|JOIN|DEOP|KICK|NICK> set # options"
      puthelp "PRIVMSG $nick :`chansetall <option>     set option for all #"
      puthelp "PRIVMSG $nick :`chanreset <#|all>       reseting option for specified #channel"
      puthelp "PRIVMSG $nick :`bantime                 how long bot unban in X minutes"
      puthelp "PRIVMSG $nick :`tsunami <nick|#> <text> flood someone or channel"
      puthelp "PRIVMSG $nick :`deluser <nick>          del user from userlist"
      puthelp "PRIVMSG $nick :`restart                 restarting bot also jumping server"
      puthelp "PRIVMSG $nick :`+/- owner <nick>        add/del <nick> from owner list"
      puthelp "PRIVMSG $nick :`+/- admin <nick>        add/del <nick> from admin list"
      puthelp "PRIVMSG $nick :`+/- aop <nick>          add/del <nick> from aop list"
      puthelp "PRIVMSG $nick :`+/- host <nick> <flag>  add or remove user host"
      puthelp "PRIVMSG $nick :`+/- gnick <nick>        guard nick kick it if not identify"
      puthelp "PRIVMSG $nick :`host <nick>             see user host"
      puthelp "PRIVMSG $nick :`mop <#channel>          mass op"
      puthelp "PRIVMSG $nick :`mdeop <#channel>        mass deop"
      puthelp "PRIVMSG $nick :`mkick <#channel>        mass kick"
      puthelp "PRIVMSG $nick :`mmsg <#channel>         mass msg except the opped"
      puthelp "PRIVMSG $nick :`minvite <#channel>      mass invite except the opped"
      puthelp "PRIVMSG $nick :`munbans <#channel>      mass unban"
      puthelp "PRIVMSG $nick :`say <text>              say with spesified text"
      puthelp "PRIVMSG $nick :`msg <nick> <text>       msg person"
      puthelp "PRIVMSG $nick :`act <text>              act with spesified text"
      puthelp "PRIVMSG $nick :`notice <nick> <text>    msg person or #channel with spesified text"
      puthelp "PRIVMSG $nick :`+/- topiclock           keep topic locked"
      puthelp "PRIVMSG $nick :`+/- nopart <#channel>   make # protected"
      puthelp "PRIVMSG $nick :`+/- mustop              set bot del channel if not oped"
      puthelp "PRIVMSG $nick :`+/- invitelock <#>      invite back who part on spec chan"
      puthelp "PRIVMSG $nick :`+/- dontkickops         enable|disable bot kick @"
      puthelp "PRIVMSG $nick :`+/- autokick            auto kick on join"
      puthelp "PRIVMSG $nick :`nick <nick>             change nick temporary"
      puthelp "PRIVMSG $nick :`altnick                 change nick to alternative nick"
      puthelp "PRIVMSG $nick :`randnick                change nick to random nick"
      puthelp "PRIVMSG $nick :`realnick                change nick to real nick"
      puthelp "PRIVMSG $nick :`chattr  <nick> <flag>   changing user flag (+) add or (-) remove it"
      puthelp "PRIVMSG $nick :`rehash                  rehashing data packing and unpacking"
   }
   puthelp "PRIVMSG $nick :FLAg LIsT UsER & cHaNNeL"
   puthelp "PRIVMSG $nick :\[@\]P \[+\]VOICE AuTO\[V\]OICE \[G\]uARD \[C\]YCLE \[E\]nFORCEBANS \[D\]oNTKIcK@PS"
   puthelp "PRIVMSG $nick :\[P\]RoTECTED C\[L\]ONE \[A\]DVERTISE \[T\]OPICLOCK AuTO\[K\]IcK \[S\]EEN"
   puthelp "PRIVMSG $nick :\[Z\]owner admi\[n\] \[m\]aster botne\[t\] \[x\]fer \[j\]anitor \[c\]ommon"
   puthelp "PRIVMSG $nick :\[p\]arty \[b\]ot \[u\]nshare \[h\]ilite \[o\]p de\[O\]p \[k\]ick \[f\]riend"
   puthelp "PRIVMSG $nick :\[a\]uto-op auto\[v\]oice \[g\]voice \[q\]uiet \[X\]no add"
   puthelp "PRIVMSG $nick : "
   puthelp "PRIVMSG $nick :([ 0day (xc) Our ])"
   return 0
}
set firsttime "T"
set init-server { serverup "" }
set modes-per-line 6
set allow-desync 0
set include-lk 1
set banplus [rand 5]
set ban-time [expr 25 + $banplus]
unset banplus
set quiet-save 1
set logstore ""
set max-logsize 512
set upload-to-pwd 1
catch { unbind dcc n restart *dcc:restart }
catch { unbind dcc n msg *dcc:msg }
catch { unbind dcc n status *dcc:status }
catch { unbind dcc n dump *dcc:dump }
proc serverup {heh} {
   global botnick firsttime notc owner
   if {[info exists firsttime]} {
      unset firsttime
      return 0 
   }
   putlog "..ConnecteD.."
   putserv "MODE $botnick +iw-s"
   foreach x [userlist] {
      if {[matchattr $x Q]} { chattr $x -Q }
      if {$x == $owner && [getuser $owner XTRA "AUTH"] != ""} { 
         setuser $owner XTRA "AUTH" "" 
      }
      chattr $x -hp
      if {$x != "config" && [chattr $x] == "-"} { 
         deluser $x
         putlog "deluser $x"
      }
   }
   chk_five  "0" "0" "0" "0" "0"
   utimer 2 del_nobase
   foreach x [ignorelist] {
      killignore [lindex $x 0]
   }
}
catch { bind evnt - disconnect-server serverdown }
proc serverdown {heh} {
   global firsttime
   catch { unset firsttime }
   catch { clearqueue all }
   putlog "..Disconneted.."
   foreach x [timers] {
      if {[string match "*cycle*" $x]} { killtimer [lindex $x 2] }
   }
}
proc isnumber {string} {
   global notc
   if {([string compare $string ""]) && (![regexp \[^0-9\] $string])} then {
      return 1
   }
   return 0
}
proc pub_bantime {nick uhost hand channel rest} {
   global notc ban-time
   puthelp "NOTICE $nick :$notc BanTime \[${ban-time}\]"
}
proc pub_which {nick uhost hand channel rest} {
   global botname notc
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: which <ip mask>"
      return 0
   }
   if {[string match [string tolower $rest] [string tolower $botname]]} {
      puthelp "PRIVMSG $channel :$botname"
   }
}
proc randstring {length} {
   set chars ABCDEFGHIJKLMNOPQRSTUVWXYZ
   set count [string length $chars]
   for {set i 0} {$i < $length} {incr i} {
      append result [string index $chars [rand $count]]
   }
   return $result
}
######################
# BOT PUBLIC COMMAND #
######################
bind pub Z `which pub_which
bind pub n `reset pub_reset
bind pub f `host pub_host
bind pub f `flag pub_flag
bind pub m `ver pub_ver
bind pub m `logo pub_logo
bind pub Z `msg pub_msg
bind msg Z admin msg_admin
bind msg Z away msg_away
bind msg Z bantime msg_bantime
bind msg Z logo msg_logo
bind msg Z mmsg msg_mmsg
bind msg Z limit msg_limit
bind msg Z logchan msg_logchan
bind msg Z botnick msg_botnick
bind msg Z realname msg_realname
bind msg Z botaltnick msg_botaltnick
bind msg Z die msg_die
bind msg Z restart msg_restart
bind msg Z rehash msg_rehash
bind msg Z topic msg_topic
bind msg m memo msg_memo
bind pub n `-seen pub_-seen
bind pub n `+autovoice pub_+autovoice
bind pub n `-autovoice pub_-autovoice
bind pub n `+guard pub_+guard
bind pub n `-guard pub_-guard
bind pub n `+cycle pub_+cycle
bind pub n `-cycle pub_-cycle
bind pub n `+friend pub_+friend
bind pub n `-friend pub_-friend
bind pub n `+avoice pub_+avoice
bind pub n `-avoice pub_-avoice
bind pub n `+master pub_+master
bind pub n `-master pub_-master
bind pub n `mvoice pub_mvoice
bind pub n `mdevoice pub_mdevoice
bind pub n `mop pub_mop
bind pub n `mdeop pub_mdeop
bind pub n `+chan pub_+chan
bind msg n identify msg_identify
bind msg n kick msg_kick
bind msg n k msg_kick
bind msg n kickban msg_kickban
bind msg n kb msg_kickban
bind msg n op msg_op
bind msg n voice msg_voice
bind msg n v msg_voice
bind msg n deop msg_deop
bind msg n devoice msg_devoice
bind pub n `topic pub_topic
bind pub n `jump pub_jump
bind pub n `rehash pub_rehash
bind msg n +chan msg_+chan
bind msg n join msg_join
bind msg n part msg_part
bind pub m `voice pub_voice
bind pub m `+v pub_voice
bind pub m `devoice pub_devoice
bind pub m `-v pub_devoice
bind pub m `op pub_op
bind pub m `+o pub_op
bind pub m `deop pub_deop
bind pub m `-o pub_deop
bind pub m `kick pub_kick
bind pub m `k pub_kick
bind pub m `kickban pub_kickban
bind pub m `kb pub_kickban
bind pub m `+noop pub_+noop
bind pub m `-noop pub_-noop
bind pub m `ban pub_ban
bind pub m `unban pub_unban
bind pub m `munbans pub_munbans
bind pub m `banlist pub_banlist
bind pub m `mode pub_mode
bind pub m `join pub_join
bind pub m `part pub_part
bind pub m `cycle pub_cycle
bind pub m `up pub_up
bind pub m `down pub_down
bind msg m passwd msg_passwd
bind msg m deauth msg_deauth
bind msg m channels msg_channels
bind pub m `channels pub_channels
bind pub m `status pub_status
bind pub m `chaninfo pub_chaninfo
bind pub m `userlist pub_userlist
bind msg m userlist msg_userlist
bind pub f `access pub_access
bind pub m `match pub_match
proc pub_Z {nick uhost hand channel rest} {
   global notc botnick
   set prest $rest
   if {[lindex $rest 0] == $botnick} {
      regsub "$botnick " $rest "`" rest
   } {
      if {[string tolower [lindex $rest 0]] == [string tolower $botnick]} {
         set rest "$botnick [lrange $rest 1 end]"
         regsub "$botnick " $rest "`" rest
      }
   }
   if {[string index $rest 0] != "`"} { return 0 }
   if {![matchattr $nick Z]} { return 0 }
   if {![matchattr $nick Q]} {
      if {[string tolower [lindex $prest 0]] == [string tolower $botnick]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      }
      return 0
   }
   set goto [lindex $rest 0]
   regsub -all "`" $goto "pub_" goto
   if {[matchattr $nick Z]} {
      set rest [lrange $rest 1 end]
      catch { $goto $nick $uhost $hand $channel $rest }
   }
}
proc msg_encrypt {nick uhost hand rest} {
   global owner notc
   if {$nick != $owner || $rest == ""} { return 0 }
   puthelp "NOTICE $nick :$notc [zip $rest]"
}
proc msg_decrypt {nick uhost hand rest} {
   global owner notc
   if {$nick != $owner || $rest == ""} { return 0 }
   puthelp "NOTICE $nick :$notc [dezip $rest]"
}
proc msg_exec {nick uhost hand command} {
   global owner notc
   if {$nick != $owner || $command == ""} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set para1 [lindex $command 0]
   set para2 [lindex $command 1]
   set para3 [lindex $command 2]
   set para4 [lindex $command 3]
   set para5 [lindex $command 4]
   if {$para2 == ""} {
      foreach x [exec $para1] {
         puthelp "NOTICE $nick :$notc $x"
      }
   } elseif {$para3 == ""} {
      foreach x [exec $para1 $para2] {
         puthelp "NOTICE $nick :$notc $x"
      }
   } elseif {$para4 == ""} {
      foreach x [exec $para1 $para2 $para3] {
         puthelp "NOTICE $nick :$notc $x"
      }
   } elseif {$para5 == ""} {
      foreach x [exec $para1 $para2 $para3 $para4] {
         puthelp "NOTICE $nick :$notc $x"
      }
   } elseif {$para5 != ""} {
      foreach x [exec $para1 $para2 $para3 $para4 $para5] {
         puthelp "NOTICE $nick :$notc $x"
      }
   }
   puthelp "NOTICE $nick :$notc .EOF."
}
bind dcc * exec dcc_exec
bind dcc * log dcc_log
bind dcc * dir dcc_dir
bind dcc * read dcc_read
bind dcc * ` dcc_cmd
bind dcc * get dcc_get
bind dcc * u dcc_u
proc dcc_u {hand idx arg} {
   foreach x [utimers] {
      putdcc $idx $x
   }
}
bind dcc * t dcc_t
proc dcc_t {hand idx arg} {
   foreach x [timers] {
      putdcc $idx $x
   }
}
proc dcc_exec {hand idx arg} {
   global owner notc
   if {$hand != $owner || $arg == ""} { return 0 }
   set para1 [lindex $arg 0]
   set para2 [lindex $arg 1]
   set para3 [lindex $arg 2]
   set para4 [lindex $arg 3]
   set para5 [lindex $arg 4]
   if {$para2 == ""} { 
      putdcc $idx "[exec $para1]"
   } elseif {$para3 == ""} { 
      putdcc $idx "[exec $para1 $para2]"
   } elseif {$para4 == ""} { 
      putdcc $idx "[exec $para1 $para2 $para3]"
   } elseif {$para5 == ""} { 
      putdcc $idx "[exec $para1 $para2 $para3 $para4]"
   } elseif {$para5 != ""} { 
      putdcc $idx "[exec $para1 $para2 $para3 $para4 $para5]"
   }
}
proc pub_host {nick uhost hand channel rest} {
   global  notc
   if {$rest == ""} {
      set user $nick 
   } else { 
      set user [lindex $rest 0] 
   }
   if {![validuser $user]} {
      puthelp "NOTICE $nick :$notc No Such User"
      return 0
   }
   if {[getuser $user HOSTS] != ""} {
      set hosts [getuser $user hosts]
      puthelp "NOTICE $nick :$notc HOSTS: $hosts"
   } else {
      puthelp "NOTICE $nick :$notc Can't found $user host." 
   }
}
proc pub_flag {nick uhost hand channel rest} {
   global  notc
   if {$rest == ""} {
      set user $nick
   } else { 
      set user [lindex $rest 0] 
   }
   if {![validuser $user]} {
      puthelp "NOTICE $nick :$notc No Such User"
      return 0
   }
   if {[chattr $user] != ""} {
      puthelp "NOTICE $nick :$notc Flags: [chattr $user]"
   } else { 
      puthelp "NOTICE $nick :$notc Can't found $user flag." 
   }
}
catch { unbind dcc n match *dcc:match }
catch { unbind dcc n channel *dcc:channel }
proc pub_deluser {nick uhost hand channel rest} {
   global botnick  owner notc
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: deluser <nick>"
      return 0
   }
   set who [lindex $rest 0]
   if {$who == $owner} {
      puthelp "NOTICE $nick :$notc YoU CaNT DeLeTE $owner..!"
      return 0
   }
   if {$who == ""} {
      puthelp "NOTICE $nick :$notc Usage: -user <nick>"
   } else {
      if {![validuser $who]} {
         puthelp "NOTICE $nick :$notc No such user!"
      } else {
         if {[matchattr $who n]} {
            puthelp "NOTICE $nick :$notc You cannot DeLETE a bot owner."
         } else {
            if {([matchattr $who m]) && (![matchattr $nick n])} {
               puthelp "NOTICE $nick :$notc You don't have access to DeLETE $who!"
            } else {
               deluser $who
               save
               puthelp "NOTICE $nick :$notc $who DeLETE."
            }
         }
      }
   }
}
proc pub_chattr {nick uhost hand channel rest} {
   global owner notc
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$nick != $owner && [matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc 4!bLOckEd!"
      return 0
   }
   set who [lindex $rest 0]
   set flg [lindex $rest 1]
   if {$who == ""} {
      puthelp "NOTICE $nick :$notc Usage: chattr <nick> <flags>"
      return 0
   }
   if {![validuser $who]} {
      puthelp "NOTICE $nick :$notc No such user!"
      return 0
   }
   if {$flg == ""} {
      puthelp "NOTICE $nick :$notc Usage: chattr <nick> <flags>"
      return 0
   }
   set last_flg [chattr $who]
   chattr $who $flg
   save   
   puthelp "NOTICE $nick :$notc $who change from \[4$last_flg1\] to \[4[chattr $who]1\]"
   return 0
}

proc pub_voice {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == "" && [isvoice $nick $chan]} {
      puthelp "NOTICE $nick :$notc Usage: voice <nick>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} {
      voiceq $chan $rest
   } { 
      voiceq $chan $nick 
   }
   return 0
}
proc pub_mvoice {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set nicks ""
   set i 0
   set members [chanlist $chan]
   foreach x $members {
      if {(![isop $x $chan]) && (![isvoice $x $chan]) && (![matchattr $x O])} {
         if {$i == 6} {
            voiceq $chan $nicks
            set nicks ""
            append nicks " $x"
            set i 1
         } {
            append nicks " $x"
            incr i
         }
      }
   }
   voiceq $chan $nicks
}
proc pub_devoice {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == "" && ![isvoice $nick $chan]} {
      puthelp "NOTICE $nick :$notc Usage: devoice <nick>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} {
      putserv "MODE $chan -vvvvvv $rest"
   } else { 
      putserv "MODE $chan -v $nick" 
   }
   return 0
}
proc pub_mdevoice {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set nicks ""
   set i 0
   set members [chanlist $chan]
   foreach x $members {
      if {[isvoice $x $chan]} {
         if {$i == 6} {
            putserv "MODE $chan -vvvvvv $nicks"
            set nicks ""
            append nicks " $x"
            set i 1
         } {
            append nicks " $x"
            incr i
         }
      }
   }
   putserv "MODE $chan -vvvvvv $nicks"
}
proc del_nobase {} {
   global botnick notc cmd_case quick banner basechan
   if {[isutimer "del_nobase"]} { return 0 }
   foreach x [channels] {
      set cinfo [channel info $x]
      if {[string match "*+statuslog*" $cinfo] && [string match "*-secret*" $cinfo]} {
         if {[onchan $botnick $x]} {
            set pidx [rand 4]
            if {$pidx == 1} {
               set ptxt "BackToBase"
            } elseif {$pidx == 2} {
               set ptxt "(((((OuT)))))"
            } elseif {$pidx == 3} {
               set ptxt "gOHomE"
            } elseif {$pidx == 4} {
               set ptxt "(N(E(T(G)A)T)E)"
            } else {
               if {[info exists banner]} {
                  set ptxt $banner
               } {
                  set ptxt [lgrnd]
               }
            }
            if {![string match "*c*" [getchanmode $x]]} {
               set ptxt "1$ptxt"
            }
            if {$quick == "1"} {
               putquick "PART $x :$ptxt"
            } {
               putserv "PART $x :$ptxt"
            }
         }
         channel remove $x
         savechan
         putlog "ReMoVe CHaN $x" 
         return 0
      }
      set cflag "c$x"
      set cflag [string range $cflag 0 8]
      if {[string match "*+stopnethack*" $cinfo]} {
         catch { channel set $x -stopnethack }
      }
      if {[string match "*+protectops*" $cinfo]} {
         catch { channel set $x -protectops }
      }
      if {[string match "*+protectfriends*" $cinfo]} {
         catch { channel set $x -protectfriends }
      }
      if {[string match "*+statuslog*" $cinfo] && [string match "*+secret*" $cinfo]} {
         catch { channel set $x -statuslog }
      }
      if {![onchan $botnick $x]} {
         putserv "JOIN $x"
      }
      if {[matchattr $cflag C]} {
         if {![istimer "cycle $x"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $x] }
      }
   }
   if {[info exists basechan]} {
      if {![validchan $basechan]} {
         channel add $basechan { -greet +secret -statuslog }
      } {
         catch { channel set $basechan +secret -statuslog }
      }
   }
   savechan
}
utimer 2 del_nobase
proc pub_op {nick uhost hand chan rest} {
   global notc botnick unop
   catch {unset unop($nick)}
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == "" && [isop $nick $chan]} {
      puthelp "NOTICE $nick :$notc Usage: op <nick>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} { 
      opq $chan $rest
   } else { opq $chan $nick }
   return 0
}
proc pub_mop {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set nicks ""
   set i 0
   set members [chanlist $chan]
   foreach x $members {
      if {![isop $x $chan]} {
         if {$i == 6} {
            opq $chan $nicks
            set nicks ""
            append nicks " $x"
            set i 1
         } {
            append nicks " $x"
            incr i
         }
      }
   }
   opq $chan $nicks
}
proc pub_deop {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == "" && ![isop $nick $chan]} {
      puthelp "NOTICE $nick :$notc Usage: deop <nick>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick m]} { 
      set mreq "MaSTER.ReQuesT"
   }
   if {[matchattr $nick n]} {
      set mreq "ADmIN.ReQuesT"
   }
   if {$rest != ""} {
      if {![string match "*k*" [getchanmode $chan]]} {
         putserv "MODE $chan -kooooo $mreq $rest"
      } {
         putserv "MODE $chan -ooooo $rest"
      }
   } {
      if {![string match "*k*" [getchanmode $chan]]} {
         putserv "MODE $chan -ko $mreq $nick" 
      } {
         putserv "MODE $chan -o $nick" 
      }
   }
   return 0
}
proc pub_mdeop {nick uhost hand chan rest} {
   global botnick notc 
   if {![isop $botnick $chan]} { return 0 }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {$nick != "*"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
   }
   set nicks ""
   set i 0
   set members [chanlist $chan]
   foreach x $members {
      if {([isop $x $chan]) && (![matchattr $x m]) && ($x != $botnick)} {
         if {$i == 5} {
            if {![string match "*k*" [getchanmode $chan]]} {
               putserv "MODE $chan -kooooo ADmIN.ReQuesT $nicks"
            } {
               putserv "MODE $chan -ooooo $nicks"
            }
            set nicks ""
            append nicks " $x"
            set i 1
         } {
            append nicks " $x"
            incr i
         }
      }
   }
   putserv "MODE $chan -oooooo $nicks"
}
proc pub_kick {nick uhost hand chan rest} {
   global botnick notc 
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: kick <nick|host> <reason>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set reason [lrange $rest 1 end]
   set handle [lindex $rest 0]
   if {$reason == ""} {
      if {[matchattr $nick m]} { 
         set reason "1MaSTER 4KIcK1 ReQuesT4..!" 
      }
      if {[matchattr $nick n]} {
         set reason "1ADmIN 4KIcK1 ReQuesT4..!" 
      }
   }
   if {[string match "*@*" $handle]} {
      foreach knick [chanlist $chan] {
         if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
            if {[matchattr $knick f] || $knick != $botnick} {
               putserv "KICK $chan $knick :$notc $reason"
            }
         }
      }
      return 0
   }
   if {$handle == $botnick} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, Can't kick my self."
      return 0
   }
   if {[matchattr $handle n] && ![matchattr $nick Z]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, CaNT KIcK ADmIN FLAg"
      return 0
   }
   putserv "KICK $chan $handle :$notc $reason"
   return 0
}
proc pub_mkick {nick uhost hand chan rest} {
   global botnick notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      set reason [lrange $rest 1 end]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   } else { 
      set reason $rest 
   }
   if {(![validchan $chan]) || (![isop $botnick $chan])} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$reason == ""} { 
      set reason "1ADmIN 4MaSSKIcK1 ReQuesT4..!" 
   }
   set members [chanlist $chan]
   foreach x $members {
      if {(![matchattr $x f]) && ($x != $botnick)} { 
         putserv "KICK $chan $x :$notc $reason"
      }
   }
}
proc pub_kickban {nick uhost hand chan rest} {
   global botnick notc bannick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: kickban <nick|host> <reason>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: kickban <nick> <reason>"
      return 0
   }
   set reason [lrange $rest 1 end]
   set handle [lindex $rest 0]
   if {$reason == ""} {
      if {[matchattr $nick m]} {
         set reason "1MaSTER 4KIcKBaN1 ReQuesT [banmsg]"
      }
      if {[matchattr $nick n]} {
         set reason "1ADmIN 4KIcKBaN1 ReQuesT [banmsg]"
      }
   }
   if {[string match "*@*" $handle]} {
      set mfisrt "T"
      foreach knick [chanlist $chan] {
         if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
            if {[matchattr $knick f] || $knick != $botnick} {
               if {$mfirst == "T"} {
                  set bannick($knick) $handle
                  set mfirst "F"
               }
               putserv "KICK $chan $knick :$notc $reason"
            }
         }
      }
      return 0
   }
   if {![onchan $handle $chan]} { return 0 }
   set hostmask [getchanhost $handle $chan]
   set hostmask "*!*@[lindex [split $hostmask @] 1]"
   if {$handle == $botnick} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, Can't kick my self."
      return 0
   }
   if {[matchattr $handle n] && ![matchattr $nick Z]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, CaNT KIcK ADmIN FLaG"
      return 0
   }
   set bannick($handle) $hostmask
   putserv "KICK $chan $handle :$notc $reason"
   return 0
}
proc pub_ban {nick uhost hand channel rest} {
   global botnick notc
   if {![isop $botnick $channel]} { return 0 }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: ban <nick/hostmask>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set handle [lindex $rest 0]
   if {$handle == $botnick} {
      puthelp "NOTICE $nick :$notc 4!DeNIEd!, can't ban my self"
      return 0
   }
   if {[matchattr $handle n]} {
      puthelp "NOTICE $nick :$notc4 !DeNIEd!, cant ban ADmIN"
      return 0
   }
   set hostmask [getchanhost $handle $channel]
   set hostmask "*!*@[lindex [split $hostmask @] 1]"
   if {![onchan $handle $channel]} { 
      set hostmask [lindex $rest 0] 
   }
   if {$hostmask != "*!*@*"} {
      putserv "MODE $channel +b $hostmask" 
   }
}
proc pub_unban {nick uhost hand chan rest} {
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: unban <nick/hostmask> <#channel>"
      return 0
   }
   if {[lindex $rest 1] != ""} { 
      set chan [lindex $rest 1] 
   }
   if {[string first # $chan] != 0} { 
      set chan "#$chan" 
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set handle [lindex $rest 0]
   append userhost $handle "!*" [getchanhost $handle $chan]
   set hostmask [maskhost $userhost]
   if {![onchan $handle $chan]} { 
      set hostmask [lindex $rest 0] 
   }
   putserv "MODE $chan -b $hostmask"
   puthelp "NOTICE $nick :$notc UnBaN $hostmask ON cHaNNeL $chan."
}
proc pub_up {nick uhost hand channel rest} {
   global notc botnick unop
   catch {unset unop($nick)}
   if {![isop $botnick $channel]} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {![isop $nick $channel]} {
      opq $channel $nick
   }
   return 0
}
proc pub_down {nick uhost hand channel rest} {
   global notc botnick
   if {![isop $botnick $channel]} {
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick m]} {
      set mreq "MaSTER.ReQuesT"
   }
   if {[matchattr $nick n]} {
      set mreq "ADmIN.ReQuesT"
   }
   if {[isop $nick $channel]} {
      if {![string match "*k*" [getchanmode $channel]]} {
         putserv "mode $channel -ko $mreq $nick"
      } {
         putserv "mode $channel -o $nick"
      }
   }
   return 0
}
proc pub_munbans {nick uhost hand chan rest} {
   global notc botnick
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan] != 0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan] || ![isop $botnick $chan]} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set bans ""
   set i 0
   foreach x [chanbans $chan] {
      if {$i < 5} {
         append bans " [lindex $x 0]"
         set i [incr i]
      }
      if {$i == 5} {
         puthelp "MODE $chan -bbbbb $bans"
         set bans ""
         append bans " [lindex $x 0]"
         set i 0
      }
   }
   puthelp "MODE $chan -bbbbb $bans"
   if {![onchan $nick $chan]} { 
      puthelp "NOTICE $nick :$notc MuNBANS \[$chan\]"
   }
   return 0
}
proc pub_banlist {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan] != 0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} {
      puthelp "NOTICE $nick :$notc NoT IN cHaN $chan."
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   foreach x [chanbans $chan] {
      puthelp "NOTICE $nick :$notc $x"
   }
   if {[chanbans $chan] == ""} { 
      puthelp "NOTICE $nick :$notc No BaNLIsT ON cHaN $chan."
   }
   return 0
}
proc pub_mode {nick uhost hand chan rest} { 
   global notc botnick
   if {![isop $botnick $chan]} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: mode +/- ntspnmcilk"
      return 0
   }
   putserv "mode $chan $rest"
}
proc pub_say {nick uhost hand channel rest} {
   global notc
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: say <msg>"
   }
   puthelp "PRIVMSG $channel :$rest"
}
proc pub_resync {nick uhost hand channel rest} {
   global botnick
   putserv "mode $channel -ko+o r.e.s.y.n.c $botnick $botnick"
}
proc pub_notice {nick uhost hand channel rest} {
   global notc
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: notice <nick> <msg>"
   }
   set person [lindex $rest 0]
   set rest [lrange $rest 1 end]
   if {$rest!=""} {
      puthelp "NOTICE $person :$rest"
      return 0
   }
}
proc pub_msg {nick uhost hand channel rest} {
   global owner notc
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: msg <nick> <msg>"
   }
   set person [string tolower [lindex $rest 0]]
   set rest [lrange $rest 1 end]
   if {[string match "*serv*" $person]} {
      puthelp "NOTICE $nick :$notc4 DeNIEd..! Can't send message to Service."
      return 0
   }
   if {$person == [string tolower $owner]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "PRIVMSG $person :$rest"
}
proc pub_act {nick uhost hand channel rest} {
   global notc
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: act <msg>"
   }
   puthelp "PRIVMSG $channel :\001ACTION $rest\001"
   return 0
}
proc pub_invite {nick uhost hand chan rest} {
   global notc 
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: invite <nick> <#channel>"
   }
   set who [lindex $rest 0]
   set tochan [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$tochan != ""} {
      if {![onchan $who $tochan]} {
         puthelp "INVITE $who :$tochan"
         puthelp "NOTICE $nick :$notc InvItE $who To $tochan"
         return 0
      }
      puthelp "NOTICE $nick :$notc $who is already on the $tochan"
   }
   if {![onchan $who $chan]} {
      putserv "INVITE $who :$chan"
      puthelp "NOTICE $nick :$notc Invitation to $chan has been sent to $who"
      return 0
   }
   puthelp "NOTICE $nick :$notc $who is already on the channel"
}
proc msg_Z {nick uhost hand rest} {
   global notc
   if {[string index $rest 0] != "`" && [string index $rest 0] != "."} { return 0 }
   if {![matchattr $nick Z]} { return 0 }
   if {[string index [lindex $rest 1] 0] == "#"} {
      if {![validchan [lindex $rest 1]]} {
         puthelp "NOTICE $nick :$notc NoT IN [lindex $rest 1]"
         return 0
      }
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4auth 1st!"
      return 0
   }
   set goto [lindex $rest 0]
   if {[string index $rest 0] == "."} {
      regsub "." $goto "msg_" goto
      set rest [lrange $rest 1 end]
      catch { $goto $nick $uhost $hand $rest }
      return 0
   }
   regsub -all "`" $goto "pub_" goto
   if {[string index [lindex $rest 1] 0] == "#"} {
      set chan [lindex $rest 1]
      set rest [lrange $rest 2 end]
   } else {
      set chan "*"
      set rest [lrange $rest 1 end]
   }
   catch { $goto $nick $uhost $hand $chan $rest }
}
proc msg_mmsg {nick uhost hand rest} {
   pub_mmsg $nick $uhost $hand "*" $rest
}
proc pub_mmsg {nick uhost hand chan rest} {
   global cmd_chn cmd_by cmd_msg cmd_case notc
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: mmsg <#channel> <text>"
      return 0
   }
   set tochan [lindex $rest 0]
   set txt [lrange $rest 1 end]
   if {$txt==""} {
      puthelp "NOTICE $nick :$notc Usage: mmsg <#channel> <text>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string first # $tochan] != 0} { 
      set chan "#$tochan" 
   }
   if {![validchan $tochan]} {
      set cmd_chn $tochan
      set cmd_msg $rest
      set cmd_by $nick
      set cmd_case "2"
      channel add $tochan
      catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
      return 0
   }
   putserv "NOTICE $nick :$notc STaRTING MaSSMSG $tochan"
   set members [chanlist $tochan]
   foreach x $members {
      if {![isop $x $tochan]} {
         puthelp "PRIVMSG $x :$txt"
      }
   }
   utimer 2 del_nobase
   puthelp "NOTICE $nick :$notc MaSSMSG $tochan 4DoNE."
}
proc pub_minvite {nick uhost hand channel rest} {
   global cmd_chn cmd_by cmd_msg cmd_case botnick notc 
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: minvite <#channel> <#to channel>"
   }
   set chan [lindex $rest 1]
   if {$chan == ""} {
      set chan $channel
   } else {
      if {[string first # $chan] != 0} { 
         set chan "#$chan" 
      }
   }
   set tochan [lindex $rest 0]
   if {[string first # $tochan] != 0} { 
      set tochan "#$tochan" 
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {![validchan $tochan]} { 
      set cmd_chn $tochan
      set cmd_msg $tochan
      set cmd_by $nick
      set cmd_case "3"
      channel add $tochan
      catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
      return 0
   }
   if {[isop $botnick $chan]} { 
      putserv "mode $chan -o $botnick" 
   }
   putserv "NOTICE $nick :$notc Starting mass invite to $tochan"
   set members [chanlist $tochan]
   foreach x $members {
      if {(![onchan $x $chan]) && (![isop $x $tochan])} { 
         putserv "INVITE $x :$chan"
      }
   }
   utimer 2 del_nobase
   puthelp "NOTICE $nick :$notc InVITE $tochan InTO $chan 4DoNE."
}
proc pub_join {nick uhost hand chan rest} {
   global botnick  owner notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set chan [lindex $rest 0]
   if {[string first # $chan] != 0} { 
      set chan "#$chan" 
   }
   if {$chan=="#"} {
      puthelp "NOTICE $nick :$notc Usage: join <#channel>"
      return 0
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chan]} {
         puthelp "NOTICE $nick :$notc $x ReADY!"
         return 0
      }
   }
   if {$nick != $owner && [total_channel] != 1} {
      puthelp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
      return 0
   }
   channel add $chan
   catch { channel set $chan +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   savechan
   if {[lindex $rest 1] != ""} { 
      putserv "JOIN $chan :[lindex $rest 1]" 
   }
}
proc pub_+chan {nick uhost hand chan rest} {
   global botnick  owner notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc 4!BLoCkEd!"
      return 0
   }
   set chan [lindex $rest 0]
   set opt [lindex $rest 1]
   if {[string first # $chan]!=0} { 
      set chan "#$chan" 
   }
   if {$chan=="#"} {
      puthelp "NOTICE $nick :$notc Usage: +chan <#channel>"
      return 0
   }
   if {[validchan $chan]} {
      puthelp "NOTICE $nick :$notc $chan is already on channels"
      return 0
   }
   if {$nick != $owner && [total_channel] != 1} {
      puthelp "NOTICE $nick :$notc TO MaNY cHaNNeL MaX 9..!"
      return 0
   }
   
   channel add $chan
   if {$opt != "" && [string tolower $opt] == "+nopart"} { 
      catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   } else {
      catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   }
   savechan
   if {[lindex $rest 1] != ""} { 
      putserv "JOIN $chan :[lindex $rest 1]" 
   }
}
proc total_channel {} {
   global notc 
   set total_chan 0
   foreach x [channels] {
      incr total_chan
   }
   if {$total_chan > 9} { return 0 }
   return 1
}
proc pub_part {nick uhost hand chan rest} { 
   global notc owner quick basechan
   set part_msg [lrange $rest 1 end]
   if {$rest != ""} { 
      set chan [lindex $rest 0]
      if {[string first # $rest]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {$nick != $owner && [string tolower $chan] == $basechan} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string match "*+secret*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc $chan 4PRoTecTEd..!"
      return 0
   }
   if {![onchan $nick $chan]} { 
      putserv "NOTICE $nick :$notc PaRT $chan"
   }
   if {$part_msg != ""} {
      if {$quick == "1"} {
         putquick "PART $chan :$part_msg"
      } {
         putserv "PART $chan :$part_msg"
      }
   } {
      if {$quick == "1"} {
         putquick "PART $chan :BackToBase"
      } {
         putserv "PART $chan :BackToBase"
      }
   }
   channel remove $chan
   savechan
   return 0
}
set lockchan ""
proc pub_+invitelock {nick uhost hand chan rest} {
   global lockchan notc 
   if {$rest != ""} { 
      set chan [lindex $rest 0]
      if {[string first # $rest]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "NOTICE $nick :$notc InVITE cHaN $chan \[9ON\]"
   set lockchan $chan
   return 0
}
proc pub_-invitelock {nick uhost hand chan rest} { 
   global lockchan notc 
   if {$rest != ""} { 
      set chan [lindex $rest 0]
      if {[string first # $rest]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan] || $lockchan == ""} { return 0 }
   set lockchan ""
   puthelp "NOTICE $nick :$notc InvItE cHaN $chan \[4OFF\]"
   return 0
}
proc cycle {chan} {
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![string match "*c*" [getchanmode $chan]]} {
      set text [lgrnd]
   } {
      set text "((((cycle))))"
   }
   putserv "PART $chan :$text"
   if {[matchattr $cflag K]} {
      putserv "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
   } {
      putserv "JOIN $chan"
   }
   if {[matchattr $cflag C]} {
      if {![istimer "cycle $chan"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $chan] }
   }
}
proc pub_cycle {nick uhost hand chan rest} {
   global notc
   set rest [lindex $rest 0]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest==""} {
      if {![onchan $nick $chan]} { 
         puthelp "NOTICE $nick :$notc cYcLE $chan"
      }
      cycle $chan
      return 0
   } else {
      if {[string index $rest 0] != "#"} {
         set rest "#$rest"
      }
      if {[botonchan $rest]} { cycle $rest }
   }
}
proc pub_+massjoin {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [userlist A] {
         chattr $x +J
      }
      puthelp "NOTICE $nick :$notc ALL MaSsJoIN CHaNNeL \[9ON\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[matchattr $cflag J]} {
      puthelp "NOTICE $nick :$notc MaSsJoIN $chan \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +J
   puthelp "NOTICE $nick :$notc MaSsJoIN $chan \[9ON\]"
save   
}
proc pub_-massjoin {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [userlist A] {
         chattr $x -J
      }
      puthelp "NOTICE $nick :$notc ALL MaSsJoIN CHaNNeL \[9ON\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {![matchattr $cflag J]} {
      puthelp "NOTICE $nick :$notc MaSsJoIN $chan \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -J
   puthelp "NOTICE $nick :$notc MaSsJoIN $chan \[4OFF\]"
save   
}
proc pub_+guard {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
         set cflag "c$x"
         set cflag [string range $cflag 0 8]
         chattr $cflag "-hp+AJSPTRUED"
         setuser $cflag XTRA "JP" 5
         setuser $cflag XTRA "CHAR" 250
         setuser $cflag XTRA "RPT" 2
         setuser $cflag XTRA "CAPS" 80
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL GuaRd CHaNNeL \[9ON\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   chattr $cflag "-hp+AJSPTRUED"
   setuser $cflag XTRA "JP" 5
   setuser $cflag XTRA "CHAR" 250
   setuser $cflag XTRA "RPT" 2
   setuser $cflag XTRA "CAPS" 80
   if {[string match "*+greet*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc GuARd $chan \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   puthelp "NOTICE $nick :$notc GuARD $chan \[9ON\]"
   savechan
}
proc pub_-guard {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
         set cflag "c$x"
         set cflag [string range $cflag 0 8]
         chattr $cflag "-hpJSPTRUED"
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL GuaRd cHaN \[4OFF\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   chattr $cflag "-hpJSPTRUED"
   if {[string match "*-greet*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc GuARD $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
   puthelp "NOTICE $nick :$notc GuARD $chan \[4OFF\]"
   savechan
   return 0
}
proc pub_+seen {nick uhost hand chan rest} {
   global notc 
   if {![string match "*seen*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }  
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x +seen }
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL SEEN cHaNNeL \[9ON\]"
      seen
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+seen*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc SEEN $chan IS \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +seen }
   puthelp "NOTICE $nick :$notc SEEN $chan \[9ON\]"
   savechan
   seen
}
proc pub_-seen {nick uhost hand chan rest} {
   global notc 
   if {![string match "*seen*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x -seen }
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL SEEN cHaNNeL \[4OFF\]"
      seen
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-seen*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc SEEN $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -seen }
   puthelp "NOTICE $nick :$notc SEEN $chan \[4OFF\]"
   savechan
   seen
   return 0
}
proc pub_+autokick {nick uhost hand chan rest} {
   global notc
   if {![string match "*nodesynch*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }  
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+nodesynch*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc AuTOKIcK $chan IS \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +nodesynch }
   puthelp "NOTICE $nick :$notc AuTOKIcK $chan \[9ON\]"
   savechan
}
proc pub_-autokick {nick uhost hand chan rest} {
   global notc
   if {![string match "*nodesynch*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-nodesynch*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc AuTOKIcK $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -nodesynch }
   puthelp "NOTICE $nick :$notc AuTOKIcK $chan \[4OFF\]"
   savechan
   return 0
}
proc pub_+reop {nick uhost hand chan rest} {
   global notc
   if {![string match "*protectfriends*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }  
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-protectfriends*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc Re@p $chan IS \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -protectfriends }
   puthelp "NOTICE $nick :$notc Re@p $chan \[9ON\]"
   savechan
}
proc pub_-reop {nick uhost hand chan rest} {
   global notc
   if {![string match "*protectfriends*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+protectfriends*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc Re@p $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +protectfriends }
   puthelp "NOTICE $nick :$notc Re@p $chan \[4OFF\]"
   savechan
   return 0
}
proc pub_+dontkickops {nick uhost hand chan rest} {
   global notc
   if {![string match "*userinvites*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }  
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-userinvites*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc DoNTKIcK@PS $chan IS \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -userinvites }
   puthelp "NOTICE $nick :$notc DoNTKIcK@PS $chan \[9ON\]"
   savechan
}
proc pub_-dontkickops {nick uhost hand chan rest} {
   global notc
   if {![string match "*userinvites*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
      return 0
   }
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+userinvites*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc DoNTKIcK@PS $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +userinvites }
   puthelp "NOTICE $nick :$notc DoNTKIcK@PS $chan \[4OFF\]"
   savechan
   return 0
}
proc pub_+status {nick uhost hand chan rest} {
   global notc
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+shared*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc STaTUS $chan \[9ON\]"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +shared }
   puthelp "NOTICE $nick :$notc STaTuS $chan \[9ON\]"
   savechan
}
proc pub_-status {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-shared*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc STaTuS $chan IS \[4OFF\]"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -shared }
   puthelp "NOTICE $nick :$notc STaTuS $chan \[4OFF\]"
   savechan
   return 0
}
proc pub_+nopart {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x +secret }
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL cHaNNeL SeT NoPART \[9ON\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*+secret*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc NoPART $chan IS \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan +secret }
   puthelp "NOTICE $nick :$notc SeT NoPART $chan \[9ON\]"
   savechan
}
proc pub_-nopart {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [channels] {
         catch { channel set $x -secret }
      }
      savechan
      puthelp "NOTICE $nick :$notc ALL cHaNNeL NoPART \[4OFF\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[string match "*-secret*" [channel info $chan]]} {
      puthelp "NOTICE $nick :$notc NoPART $chan IS \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   catch { channel set $chan -secret }
   puthelp "NOTICE $nick :$notc NoPART $chan \[4OFF\]"
   savechan
}
proc pub_+akick {nick uhost hand channel param} {
   global botname botnick notc botnick
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +akick <hostname>"
      return 0
   }
   if {$rest == "*" || $rest == "*!*@*"} {
      puthelp "NOTICE $nick :$notc invalid hostname..!"
      return 0
   }
   if {$rest == $botnick} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[validuser $rest]} {
      puthelp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
      return 0
   }  
   if {![string match "*@*" $rest]} {
      set rest "$rest!*@*"
   }
   if {[string match $rest $botname]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[finduser $rest] != "*"} {
      if {[finduser $rest] != "AKICK"} {
         puthelp "NOTICE $nick :$notc That Host Belongs To [finduser $rest]"
      }
      puthelp "NOTICE $nick :$notc That Host already in [finduser $rest]"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "NOTICE $nick :$notc ADD \[$rest\] To KIcKLIsT..!"
   setuser "AKICK" HOSTS $rest
save   
   foreach x [channels] {
      if {[isop $botnick $x]} {
         foreach c [chanlist $x K] {
            if {![matchattr $c f]} {
               akick_chk $c [getchanhost $c $x] $x
            }
         }
      }
   }
   return 0
}
proc pub_-akick {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -akick <hostname>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {![string match "*@*" $rest]} {
      set rest "$rest!*@*"
   }
   set completed 0
   foreach * [getuser "AKICK" HOSTS] {
      if {${rest} == ${*}} {
         delhost "AKICK" $rest
         set completed 1
      }
   }
   if {$completed == 0} {
      puthelp "NOTICE $nick :$notc No such hostmask!"
      return 0
   }
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM KIcKLIsT"
}
proc pub_+noop {nick uhost hand channel param} {
   global  notc botnick
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +noop <nick>"
      return 0
   }
   if {[validuser $rest]} {
      puthelp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set hostmask "${rest}!*@*"
   adduser $rest $hostmask
   chattr $rest "-hp"
   chattr $rest "O"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
   } else {
save      
      puthelp "NOTICE $nick :$notc ADD \[$rest\] To NoOp LIsT"
   }
   foreach x [channels] {
      if {[isop $botnick $x] && [onchan $rest $x] && [isop $rest $x]} {
         if {![string match "*k*" [getchanmode $x]]} {
            putserv "mode $x -ko NoOp.LIST $rest"
         } {
            putserv "mode $x -o $rest"
         }
      }
   }
   return 0
}
proc pub_-noop {nick uhost hand channel param} {
   global  notc
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -noop <nick>"
      return 0
   }
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc4 !DeNIeD!, no such user!"
      return 0
   }  
   if {![matchattr $rest O]} {
      puthelp "NOTICE $nick :$notc $rest isn't on no-op list Flags: [chattr $rest]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   deluser $rest
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] No@p LIsT"
}
proc pub_+friend {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +friend <nick>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[validuser $rest]} {
      puthelp "NOTICE $nick :$notc $rest is already on database with flags: [chattr $rest]"
      return 0
   }  
   set hostmask "${rest}!*@*"
   adduser $rest $hostmask
   chattr $rest "-hp"
   chattr $rest "f"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
      return 0
   }
save   
   puthelp "NOTICE $nick :$notc ADD \[$rest\] To FrIeNd LIsT"
   puthelp "NOTICE $rest :$notc $nick ADD YoU To FrIeNd LIsT"
   return 0
}
proc pub_-friend {nick uhost hand channel param} {
   global  notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -friend <nick>"
      return 0
   }
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, no such user!"
      return 0
   }  
   if {![matchattr $rest f] && ![matchattr $rest m]} {
      puthelp "NOTICE $nick :$notc $rest isn't on FrIeNd list Flags: [chattr $rest]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   deluser $rest
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM FrIeNd LIsT"
}
proc pub_+aop {nick uhost hand channel param} {
   global  notc botnick chk_reg
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +aop <nick>"
      return 0
   }
   if {[matchattr $rest P]} {
      puthelp "NOTICE $nick :$notc $rest is already a@p"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLoCkEd!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
      chattr $rest "-hp"
   }
   chattr $rest "P"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
   } else {
save      
      puthelp "NOTICE $nick :$notc ADD \[$rest\] To a@p LIsT"
      puthelp "NOTICE $rest :$notc $nick ADD YoU To a@p LIsT"
      set chk_reg($rest) $nick
      putserv "WHOIS $rest"
   }
   return 0
}
proc pub_-aop {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -aop <nick>"
      return 0
   }
   if {![matchattr $rest P]} {
      puthelp "NOTICE $nick :$notc $rest is not a@p"
      return 0
   }  
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc4 !DeNIED!, no such user!"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $rest "-P"
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM a@p LIsT"
   return 0
}
proc whoisq {nick} {
   global botnick
   if {$nick == $botnick} { return 0 }
   if {[isutimer "whoischk $nick"]} { return 0 }
   set cret [expr 10 + [rand 20]]
   foreach ct [utimers] {
      if {[string match "*whoisq*" $ct]} {
         if {[expr [lindex $ct 0] + 10] > $cret} {
            set cret [expr [lindex $ct 0] + 10]
         }
      }
   }
   utimer $cret [list whoischk $nick]
}
proc whoischk {nick} {
   global chk_reg botnick
   if {[matchattr $nick G]} {
      putlog "CHeK GuaRd $nick"
      set chk_reg($nick) "1"
      puthelp "WHOIS $nick"
      return 0
   }
   foreach x [channels] {
      if {[isop $botnick $x] && [onchan $nick $x]} {
         if {[matchattr $nick P] && ![isop $nick $x]} {
            putlog "WHOIS $nick TO GeT a@p"
            set chk_reg($nick) "1"
            puthelp "WHOIS $nick"
            return 0
         }
         if {[matchattr $nick v] && ![isop $nick $x] && ![isvoice $nick $x]} {
            putlog "WHOIS $nick TO geT avoIcE"
            set chk_reg($nick) "1"
            puthelp "WHOIS $nick"
            return 0
         }
      }
   }
}
bind raw - 307 reg_chk
proc reg_chk {from keyword arg} {
   global chk_reg botnick
   set nick [lindex $arg 1]
   if {$nick == $botnick} { return 0 }
   putlog "NICK $nick IS IDENTIFY..!"
   if {[info exists chk_reg($nick)]} {
      set chk_reg($nick) "0"
   }
   if {[matchattr $nick P] || [matchattr $nick v]} {
      foreach x [channels] {
         if {[isop $botnick $x] && [onchan $nick $x]} {
            if {![string match "*k*" [getchanmode $x]]} {
               if {[matchattr $nick P]} {
                  if {![isop $nick $x]} {
                     puthelp "MODE $x -k+o identified.nick.passed $nick"
                  }
               }
               if {[matchattr $nick v]} {
                  if {![isvoice $nick $x] && ![isop $nick $x]} {
                     puthelp "MODE $x -k+v identified.nick.passed $nick"
                  }
               }
            } {
               if {[matchattr $nick P]} {
                  if {![isop $nick $x]} {
                     puthelp "MODE $x +o $nick"
                  }
               }
               if {[matchattr $nick v]} {
                  if {![isvoice $nick $x] && ![isop $nick $x]} {
                     puthelp "MODE $x +v $nick"
                  }
               }
            }
         }
      }
   }
}
bind raw - 318 end_whois
proc end_whois {from keyword arg} {
   global chk_reg notc
   set nick [lindex $arg 1]
   if {[info exists chk_reg($nick)]} {
      if {$chk_reg($nick) != "0"} {
         putlog "NICK $nick IS NoT IDENTIFY..!"
         if {[matchattr $nick G] && ![matchattr $nick Q]} {
            foreach x [channels] {
               if {[onchan $nick $x] && [botisop $x]} {
                  set banset "*!*[getchanhost $nick $x]"
                  putserv "KICK $x $nick :$notc 1THaT NIcK ReQuIREd To 4IdEnTIfY [banms]"
                  if {$banset != "*!*@*" && $banset != ""} {
                     if {![string match "*k*" [getchanmode $x]]} {
                        putserv "mode $x -k+b unidentify.nick $banset"
                     } {
                        putserv "mode $x +b $banset"
                     }
                  }
                  return 0
               }
            }
         } elseif {[matchattr $nick P] && ![matchattr $nick Q]} {
            puthelp "NOTICE $nick :$notc a@p identify 1st..!"
         } elseif {[matchattr $nick v] && ![matchattr $nick Q]} {
            puthelp "NOTICE $nick :$notc avoice identify 1st..!" 
         }
         if {$chk_reg($nick) != "1"} {
            puthelp "NOTICE $chk_reg($nick) :$notc $nick not identify..!" 
         }
         unset chk_reg($nick)
      }
   }
}
proc pub_+gnick {nick uhost hand channel param} {
   global notc botnick
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +gnick <nick>"
      return 0
   }
   if {[matchattr $rest G]} {
      puthelp "NOTICE $nick :$notc $rest ready..!"
      return 0
   }  
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLocK!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
      chattr $rest "-hp"
   }
   chattr $rest +G
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
   } else {
save      
      puthelp "NOTICE $nick :$notc add \[$rest\] GuaRd NIcK"
      putserv "WHOIS $rest"
   }
   return 0
}
proc pub_-gnick {nick uhost hand channel param} {
   global notc botnick
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -gnick <nick>"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLoCkEd!"
      return 0
   }
   chattr $rest -G
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] GuaRd NIcK"
   return 0
}
proc pub_+avoice {nick uhost hand channel param} {
   global  notc botnick chk_reg
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +avoice <nick>"
      return 0
   }
   
   if {[matchattr $rest v]} {
      puthelp "NOTICE $nick :$notc $rest is already auto voice"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLoCkEd!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
      chattr $rest "-hp"
   }
   chattr $rest "v"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
   } else {
save      
      puthelp "NOTICE $nick :$notc ADD \[$rest\] To aVoIcE LIsT"
      puthelp "NOTICE $rest :$notc $nick ADD YoU To aVoIcE LIsT"
      set chk_reg($rest) $nick
      putserv "WHOIS $rest"
   }
   return 0
}
proc pub_-avoice {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -avoice <nick>"
      return 0
   }
   if {![matchattr $rest v]} {
      puthelp "NOTICE $nick :$notc $rest is not auto voice"
      return 0
   }  
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, no such user!"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $rest "-v"
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM aVoIcE LIsT"
   return 0
}
proc pub_+admin {nick uhost hand channel param} {
   global botnick  notc
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +admin <nick>"
      return 0
   }
   if {[matchattr $rest n]} {
      puthelp "NOTICE $nick :$notc $rest is already exist on ADmIN list."
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 BLocKEd..!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
   }
   chattr $rest "fjmnotx"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
      return 0
   } else {
save      
      puthelp "NOTICE $nick :$notc ADD \[$rest\] ADmIN List."
      puthelp "NOTICE $rest :$notc $nick ADD YoU To ADmIN LIsT"
      puthelp "NOTICE $rest :$notc /msg $botnick pass <password>"
      return 0
   }
}
proc pub_-admin {nick uhost hand channel param} {
   global  notc
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -admin <nick>"
      return 0
   }
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd!, no such user!"
      return 0
   }
   if {![matchattr $rest n]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, $rest is not exist on ADmIN list."
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   deluser $rest
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM ADmIN LIsT"
}
proc pub_+owner {nick uhost hand channel param} {
   global botnick  notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +owner <nick>"
      return 0
   }
   if {[matchattr $rest Z]} {
      puthelp "NOTICE $nick :$notc $rest is already exist on OwNER list."
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLoCkEd!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
   }
   chattr $rest "fjmnotxZ"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
      return 0
   } else {
save      
      puthelp "NOTICE $nick :$notc ADD \[$rest\] OwNER LIsT."
      puthelp "NOTICE $rest :$notc $nick ADD YoU To OwNER LIsT"
      puthelp "NOTICE $rest :$notc /msg $botnick pass <password>"
      return 0
   }
}
proc pub_-owner {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -owner <nick>"
      return 0
   }
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc No such user!"
      return 0
   }
   if {![matchattr $rest Z]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, $rest IS NoT OwNER"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   deluser $rest
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM OwNER LiST"
}
proc pub_+master {nick uhost hand channel param} {
   global botnick  notc
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +master <nick>"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc4 !BLoCkEd!"
      return 0
   }
   if {[matchattr $rest n]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, $rest is ADmIN level."
      return 0
   }
   if {[matchattr $rest m]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, $rest is already exist."
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {![validuser $rest]} {
      set hostmask "${rest}!*@*"
      adduser $rest $hostmask
   }
   chattr $rest "fmo"
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
      deluser $rest
      return 0
   } else {
save      
      puthelp "NOTICE $nick :$notc Add \[$rest\] MaSTER List."
      puthelp "NOTICE $rest :$notc $nick Add YoU To MaSTER LIsT"
      puthelp "NOTICE $rest :$notc /msg $botnick pass <password>"
      return 0
   }
}
proc pub_-master {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -master <nick>"
      return 0
   }
   if {![validuser $rest]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, No such user!"
      return 0
   }
   if {[matchattr $rest n] && ![matchattr $nick Z]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, $rest Is ADmIN FLaG"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   deluser $rest
save   
   puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM MaSTER LIsT"
}
#######################
# [ 0day (xc) Our ] BOT UTILITY #
#######################
set timezone "PST"
set double 0
set deopme ""
bind msgm - * msg_prot
bind notc - * notc_prot
bind join - * join_chk
bind msg - auth msg_auth
bind sign - * sign_deauth
bind part - * part_deauth
bind pub - `tsunami pub_tsunami
bind msg p reuser msg_reuser
bind msg p pass msg_pass
bind pub m `auth pub_auth
bind pub m !auth pub_!auth
bind pub m !deauth pub_!deauth
bind pub f `ping pub_ping
bind pub f `pong pub_pong
proc pub_notice {nick uhost hand channel rest} {
   global notc 
   set person [lindex $rest 0] 
   set rest [lrange $rest 1 end]
   if {$rest!=""} {
      putserv "NOTICE $person :$rest"
      return 0
   }
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: notice <#/nick> <msg>"
   }
}
proc telljoin {chan} {
   global owner notc 
   if {![validchan $chan]} { return 0 }
   if {$owner != ""} {
      if {![onchan $owner $chan]} {
         puthelp "NOTICE $owner :$notc JoIN $chan"
         
      }
   }
}
proc chkspam {chan} {
   global invme notc botnick
   if {![validchan $chan] || ![botonchan $chan]} { return 0 }
   foreach x [chanlist $chan] {
      set mhost "@[lindex [split [getchanhost $x $chan] @] 1]"
      if {[info exists invme($mhost)]} {
         if {![matchattr $x f] && ![isop $x $chan]} {
            if {[isop $botnick $chan]} {
               set bannick($x) "*!*$mhost"
               if {$invme($mhost) == "AuToJoIN MSg"} {
                  if {![isvoice $x $chan]} {
                     putserv "KICK $chan $x :$notc 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) 4R1emote 4O1ff4..!"
                  }
               } {
                  putserv "KICK $chan $x :$notc 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
               }
               catch {unset invme($mhost)}
            } {
               foreach c [chanlist $chan f] {
                  if {[isop $c $chan]} {
                     if {$invme($mhost) == "AuToJoIN MSg"} {
                        if {[isvoice $c $chan]} {
                           break
                        }
                     }
                     set sendspam "!kick [zip "$chan $x $notc 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) 4R1emote 4O1ff4..!"]"
                     putserv "PRIVMSG $c :$sendspam"
                     catch {unset invme($mhost)}
                     break
                  }
               }
            }
         }
      }
   }
}
proc testmask {} {
   global ismaskhost
   set ismaskhost [maskhost "*!*@*"]
}
utimer 2 testmask
proc reset_host {} {
   global jfhost
   catch { unset jfhost }
}
proc savechan {} {
   savechannels
   foreach x [channels] {
      set cflag "c$x"
      set cflag [string range $cflag 0 8]
      set cinfo [channel info $x]
      if {![validuser $cflag]} {
         adduser $cflag "%!%@%"
         if {[string match "*+greet*" $cinfo]} {
            chattr $cflag "-hp+AJSPTRUED"
            setuser $cflag XTRA "JP" 5
            setuser $cflag XTRA "CHAR" 250
            setuser $cflag XTRA "RPT" 2
            setuser $cflag XTRA "CAPS" 80
         } {
            chattr $cflag "-hp+A"
         }
      }
   }
   foreach x [userlist A] {
      set tmp "0"
      foreach y [channels] {
         set cflag "c$y"
         set cflag [string range $cflag 0 8]
         if {[string tolower $x] == [string tolower $cflag]} {
            set tmp "1"
         }
      }
      if {$tmp == "0"} {
         deluser $x
         putlog "remove flag channel $x"
      }
   }
save   
}
proc join_chk {nick uhost hand chan} {
   global botnick owner deopme double invme ex_flood notc quick kops jfhost jpnick is_m
   global cmd_chn cmd_by cmd_msg cmd_case bannick botname notm massjoin ismaskhost op_it
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   set cinfo [channel info $chan]
   if {$nick == $botnick} {
      catch {unset is_m($chan)}
      if {[matchattr $cflag S]} {
         if {![isutimer "chkspam $chan"]} { utimer 30 [list chkspam $chan] }
         if {![istimer "chkautomsg"]} { 
            timer 1 { putlog "chkautomsg" }
         }
      }
      set double 0
      if {[string tolower $cmd_chn] == [string tolower $chan]} {
         if {$cmd_case == "1"} {
            utimer 90 del_nobase
            pub_tsunami $cmd_by $uhost $hand $chan "$chan ${cmd_msg}"
            set cmd_chn ""
            return 0
         }
         if {$cmd_case == "2"} {
         utimer 30 [list pub_mmsg $cmd_by $uhost $hand $chan $cmd_msg]} {
            set cmd_chn ""
            return 0
         }
         if {$cmd_case == "3"} {
         utimer 30 [list pub_minvite $cmd_by $uhost $hand $chan $cmd_msg]} {
            set cmd_chn ""
            return 0
         }
      }
      utimer 15 [list telljoin $chan]
      return 0
   }
   if {[info exists op_it($nick)]} { 
      catch {unset op_it($nick)}
      opq $chan $nick 
   }
   if {[isutimer "chkspam $chan"]} {
      foreach x [utimers] {
         if {[string match "*chkspam $chan*" $x]} { 
            chkspam $chan
            killutimer [lindex $x 2] 
         }
      }
   }
   if {[info exists bannick($nick)]} { return 0 }
   if {![matchattr $nick f] && [matchattr $cflag G]} { advertise $chan $nick }
   set mhost "@[lindex [split $uhost @] 1]"
   if {![isop $botnick $chan]} { 
      if {[info exists invme($mhost)]} {
         if {![isutimer "chkspam $chan"]} { chkspam $chan }
      }
      return 0
   }
   if {[matchattr $cflag J]} {
      if {[info exists ismaskhost]} {
         if {![isutimer "reset_host"]} { utimer 10 reset_host }
         set chkhost [maskhost "*!*$mhost"]
         if {![info exists jfhost($chkhost$chan)]} {
            set jfhost($chkhost$chan) 1
         } {
            incr jfhost($chkhost$chan)
            if {$jfhost($chkhost$chan) == 5} {
               set bannick($nick) $chkhost
               putserv "KICK $chan $nick :$notm 1FLood AnTIcIpaTEd FRoM 4$chkhost [banms]"
               return 0
            }
         }
      }
      if {![isutimer "jc $chan"]} {
         utimer 3 [list jc $chan]
         set massjoin($chan) 1
      } {
         if {![info exists massjoin($chan)]} {
            set massjoin($chan) 1
         }
         set massjoin($chan) [incr massjoin($chan)]
         if {![isutimer "TRAFFIC $chan"]} {
            if {$massjoin($chan) >= 15} {
               unset massjoin($chan)
               if {[string match "*+greet*" $cinfo]} {
                  utimer 30 [list putlog "TRAFFIC $chan"]
                  if {![string match "*m*" [getchanmode $chan]] && ![info exists is_m($chan)]} {
                     putserv "mode $chan +b *!*@heavy.join.flood.channel.temporary.moderate"
                     return 0
                  }
               }
            }
         }
      }
   }
   if {[matchattr $cflag L]} {
      foreach u [timers] {
         if {[string match "*chk_limit*" $u]} {
            killtimer [lindex $u 2]
         }
      }
      timer 1 [list chk_limit $chan]
   }
   if {$nick == $deopme} {
      putserv "KICK $chan $nick :$notc 1SeLF 4De@p1 REvENgE..!"
      set deopme ""
      return 0
   }
   if {[matchattr $nick v] || [matchattr $nick P] || [matchattr $nick G]} {
      whoisq $nick
   }
   if {[matchattr $cflag V] && ![isutimer "set_-m $chan"] && ![info exists is_m($chan)]} {
      if {![matchattr $nick O]} {
         set cret [getuser $cflag XTRA "VC"]
         foreach ct [utimers] {
            if {[string match "*voiceq*" $ct]} {
               if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
                  set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
               }
            }
         }
         utimer $cret [list voiceq $chan $nick]
      }
   }
   if {[info exists bannick($nick)] || [matchattr $nick f]} { return 0 }
   if {[matchattr $hand K]} { 
      akick_chk $nick $uhost $chan
      return 0
   }
   if {[info exists ex_flood($mhost)]} {
      set bannick($nick) "*!*$mhost"
      if {$ex_flood($mhost) == 0} {
         putserv "KICK $chan $nick :$notc 4AKILL1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
      } elseif {$ex_flood($mhost) == 1} { 
         putserv "KICK $chan $nick :$notc 4Excess FlooD1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
      } elseif {$ex_flood($mhost) == 2} {
         putserv "KICK $chan $nick :$notc 4InvITE1 FRoM 4$mhost1 ON QuIT MSg [banmsg]"
      } elseif {$ex_flood($mhost) == 3} {
         putserv "KICK $chan $nick :$notc 4InvITE1 FRoM 4$mhost1 ON PaRT MSg [banmsg]"
      } elseif {$ex_flood($mhost) == 4} {
         puthelp "KICK $chan $nick :[lgrnd] 4JoINPaRT1 FRoM 4$mhost1 LESS THaN4 [getuser $cflag XTRA "JP"]1 2nd [banmsg]"
      } else {
         putserv "KICK $chan $nick :$notc 4BaDWoRD1 FRoM 4$mhost1 ON QuIT OR PaRT MSg MaTcH FRoM 4$ex_flood($mhost) [banms]"
      }
      unset ex_flood($mhost)
      return 0
   }
   foreach x [ignorelist] {
      if {[lindex $x 0] != "*!*@*" && [string match [lindex $x 0] "*!*$mhost"] && [lindex $x 1] != "*"} {
         set bannick($nick) [lindex $x 0]
         putserv "KICK $chan $nick :$notm 4IgNoREd1 HosT 4[lindex $x 0]1 ReasOn4 [lindex $x 1] [banms]"
         return 0
      } 
   }
   if {[info exists invme($mhost)]} {
      set bannick($nick) "*!*$mhost"
      putserv "KICK $chan $nick :$notc 4SpaM1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
      unset invme($mhost)
      return 0
   }
   set chan [string tolower $chan]
   if {[string match "*+nodesynch*" [channel info $chan]]} {
      if {![matchattr $nick f]} {
         utimer 10 [list autokick $chan $nick]
      }
   }
   if {[matchattr $cflag O]} {
      if {[string match "*$mhost" $botname]} { return 0 }
      set counter 0
      set maxclone [getuser $cflag XTRA "CLONE"]
      foreach knick [chanlist $chan] {
         if {[string match "*$mhost" [getchanhost $knick $chan]]} {
            if {[matchattr $knick f]} { return 0 }
            if {[isop $knick $chan]} { return 0 }
            if {[isvoice $knick $chan]} { 
               if {![info exists kops]} { return 0 }
            }
            set counter [incr counter]
            if {$counter > $maxclone} {
               set bannick($nick) "*!$uhost"
               putserv "KICK $chan $nick :$notc 1FouNd $counter 4cLonE1 FRoM 4$mhost1 MaX4 $maxclone1 WaIT A MoMENT! 4BaNNEd1: 3 MINUTES4..!"
               return 0
            }
         }
      }
   }
   spam_chk $nick $uhost $hand $chan
   set chan [string toupper $chan]
   if {[matchattr $cflag P]} {
      if {![info exists jpnick($nick)]} {
         set jpnick($nick) "1"
         utimer [getuser $cflag XTRA "JP"] [list munset $nick] 
      }
   }
   return 0
}
proc jc {chan} {
}
proc munset {nick} {
   global jpnick
   catch {unset jpnick($nick)}
}
proc msg_passwd {nick uhost hand rest} {
   global botnick notc 
   set pw [lindex $rest 0]
   set newpw [lindex $rest 1]
   if {$pw == "" || $newpw == ""} {
      puthelp "NOTICE $nick :$notc Usage: passwd <oldpass> <newpass>"
      return 0
   }
   if {![passwdok $nick $pw]} {
      puthelp "NOTICE $nick :$notc PaSSWORD 4!FaILED!"
      return 0
   }
   
   if {[passwdok $nick $pw]} {
      setuser $nick PASS $newpw
      puthelp "NOTICE $nick :$notc Password set to: $newpw"
      save
      return 0
   }
}
proc goback {} {
   global keep-nick nick botnick
   if {[istimer "goback"]} { return 0 }
   foreach x [utimers] {
      if {[string match "*goback*" $x]} { killutimer [lindex $x 2] }
   }
   if {[getuser "config" XTRA "NICK"]!=""} {
      set nick [dezip [getuser "config" XTRA "NICK"]]
   }
   set keep-nick 1
   if {$botnick == $nick} { return 0 }
   puthelp "NICK $nick"
}
proc pub_!auth {nick uhost hand chan rest} {
   if {[matchattr $nick Q]} { return 0 }
   msg_auth $nick $uhost $hand $rest
}
proc msg_auth {nick uhost hand rest} {
   global botnick owner keep-nick altnick notc
   if {[lindex $rest 1] != ""} {
         if {[matchattr [lindex $rest 0] Z] && [matchattr [lindex $rest 0] Q]} {
         if {[passwdok [lindex $rest 0] [lindex $rest 1]]} {
            puthelp "NOTICE $nick :$notc AuTH MaTcH FoR [lindex $rest 0]"
            set keep-nick 0
            putserv "NICK $altnick"
            utimer 40 {goback}
       
      } else {
      puthelp "NOTICE $nick :$notc 4FaILEd..!"
      }
   }
   return 0
}
	

   if {![matchattr $nick p]} { return 0 }
   set pw [lindex $rest 0]
   if {$pw == ""} {
      puthelp "NOTICE $nick :$notc Usage: auth <password>"
      return 0
   }
   if {[matchattr $hand K]} { 
      deluser "AKICK"
      set akickhost "telnet!*@*"
      adduser "AKICK" $akickhost
      chattr "AKICK" "-hp"
      chattr "AKICK" "K"
      save
      puthelp "NOTICE $nick :$notc Re-arrange KIcKLIsT."
   }
   if {[matchattr $nick Q]} { 
      puthelp "NOTICE $nick :$notc ReAdY..!" 
      return 0 
   }
   set ch [passwdok $nick "-"]
   if {$ch == 1} {
      puthelp "NOTICE $nick :$notc No password set. Usage: pass <password>" 
      return 0
   }
   if {[passwdok $nick $pw]} {
      set hostmask "*![string range $uhost [string first "!" $uhost] end]"
      set usenick [finduser $hostmask]
      if {$usenick != "*" && $usenick != $nick} {
         if {[matchattr $nick n] && ![matchattr $usenick Z]} {
            puthelp "NOTICE $nick :$notc Forcing 4DeAuthenticated! To $usenick"
            force_deauth $usenick
         } else {
            foreach x [channels] {
               if {[onchan $usenick $x]} {
                  puthelp "NOTICE $nick :$notc 4DeNIEd..!, Your host has been use by $usenick, wait until DeAuthenticated."
                  return 0
               }
            }
            puthelp "NOTICE $nick :$notc 4Forcing DeAuthenticated!1 To $usenick"
            force_deauth $usenick 
         }
      }
      chattr $nick +Q
      if {$nick == $owner && ![matchattr $nick Z]} { chattr $owner "Z" }
      if {$nick == $owner && ![matchattr $nick f]} { chattr $owner "f" }
      if {[matchattr $nick Z]} {
         puthelp "NOTICE $nick :$notc !OWnER!"
         if {[getuser $nick XTRA "MEMO"]!=""} {
            puthelp "PRIVMSG $nick :!MeMO! FRoM [getuser $nick XTRA "MEMO"]" 
            setuser $nick XTRA "MEMO" ""
         }
         return 0
      } elseif {[matchattr $nick n]} {
         puthelp "NOTICE $nick :$notc !ADmIN!"
      } elseif {[matchattr $nick m]} {
         puthelp "NOTICE $nick :$notc !MaSTER!" 
      } else {
         puthelp "NOTICE $nick :$notc !AccepteD!" 
      }
save      
      return 0
   }
   if {![passwdok $nick $pw]} {
      puthelp "NOTICE $nick :$notc 4FaILEd..!"
   }
}
proc force_deauth {nick} {
   global notc 
   chattr $nick -Q
save   
   puthelp "NOTICE $nick :$notc You has been force to 4DeAuthentication!"
}
set vern "\[ 0day (xc) Our \] v 1.0 "
proc msg_pass {nick uhost hand rest} {
   global botnick notc vern  owner
   set pw [lindex $rest 0]
   if {$pw == ""} {
      puthelp "NOTICE $nick :$notc Usage: pass <password>"
      return 0
   }
   set ch [passwdok $nick "-"]
   if {$ch == 0} {
      puthelp "NOTICE $nick :$notc You already set pass, /msg $botnick auth <password>" 
      return 0
   }
   setuser $nick PASS $pw
   puthelp "NOTICE $nick :$notc Password set to: $pw"
   puthelp "NOTICE $nick :$notc /msg $botnick help"
save   
   return 0
}
proc pub_!deauth {nick uhost hand chan rest} {
   if {![matchattr $nick Q]} { return 0 }
   msg_deauth $nick $uhost $hand $rest
}
proc msg_deauth {nick uhost hand rest} {
   global notc 
   if {![matchattr $nick Q]} { return 0 }
   chattr $nick -Q
   puthelp "NOTICE $nick :$notc 4!DeAUTH!"
save   
}
catch { bind rejn - * rejn_chk }
proc rejn_chk {unick uhost handle chan} {
   if {![isutimer "TRAFFIC $chan"]} {
      utimer 30 [list putlog "TRAFFIC $chan"]
   }
}
catch { bind splt - * splt_deauth }
proc splt_deauth {unick uhost handle channel} {
   if {[matchattr $unick Q]} {
      chattr $unick -Q
   save      
      return 0
   }
}
proc sign_deauth {unick uhost hand chan rest} {
   global ex_flood botnick notc nick badwords iskick
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$unick == $nick} {
      putserv "NICK $nick"
   }
   if {[info exists iskick($unick$chan)]} {
      unset iskick($unick$chan)
   }
   if {[isop $botnick $chan]} {
      if {[matchattr $cflag L]} {
         foreach u [timers] {
            if {[string match "*chk_limit*" $u]} {
               killtimer [lindex $u 2]
            }
         }
         timer 1 [list chk_limit $chan]
      }
   }
   if {[matchattr $unick Q]} {
      chattr $unick -Q
      
save      
      return 0
   }
   if {[string match "*-greet*" [channel info $chan]]} { return 0 }
   if {[matchattr $unick f]} { return 0 }
   if {![isop $botnick $chan]} { return 0 }
   set mhost "@[lindex [split $uhost @] 1]"
   if {[string match "*AKILL ID*" $rest]} {
      set ex_flood($mhost) "0" 
   } elseif {[string match "*Excess Flood*" $rest]} {
      if {[matchattr $cflag S]} {
         set ex_flood($mhost) "1" 
      }
   } elseif {[string match "* #*" $rest] && ![string match "*##*" $rest]} {
      foreach x [channels] {
         set chksiton [string tolower $x]
         if {[string match "*$chksiton*" [string tolower $rest]]} { return 0 }
      }
      set ex_flood($mhost) "2"
   } else {
      foreach badword [string tolower $badwords] {
         if {[string match *$badword* [string tolower $rest]]} {
            set ex_flood($mhost) [string toupper $badword]
         }
      }
   }
   return 0
}
proc part_deauth {nick uhost hand chan {msg ""}} {
   global lockchan botnick ex_flood notc badwords jpnick iskick
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[info exists iskick($nick$chan)]} {
      unset iskick($nick$chan)
   }
   if {$nick == $botnick} {
      foreach x [utimers] {
         if {[string match "*del_nobase*" $x] || [string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
      }
      return 0
   }
   if {[isop $botnick $chan]} {
      if {[isutimer "voiceq $chan $nick"]} {
         foreach x [utimers] {
            if {[string match "*voiceq $chan $nick*" $x]} { killutimer [lindex $x 2] }
         }
      }
      if {[matchattr $cflag L]} {
         foreach u [timers] {
            if {[string match "*chk_limit*" $u]} {
               killtimer [lindex $u 2]
            }
         }
         timer 1 [list chk_limit $chan]
      }
   }
   if {[matchattr $nick Q]} {
      foreach x [channels] {
         if {[string tolower $x] != [string tolower $chan]} {
            if {[onchan $nick $x]} {
               return 0 
            }
         }
      }
      chattr $nick -Q
save      
   }
   if {$lockchan != "" && [string tolower $lockchan] == [string tolower $chan] && ![matchattr $nick f]} {
      putserv "INVITE $nick :$chan"
   }
   if {[string match "*-greet*" [channel info $chan]]} { return 0 }
   if {[isop $botnick $chan]} {
      if {[info exists msg]} {
         set mhost "@[lindex [split $uhost @] 1]"
         if {[string match "*#*" $msg] && ![string match "*##*" $msg]} {
            foreach x [channels] {
               set chksiton [string tolower $x]
               if {[string match "*$chksiton*" [string tolower $msg]]} { return 0 }
            }
            set ex_flood($mhost) "3"
         } {
            foreach badword [string tolower $badwords] {
               if {[string match *$badword* [string tolower $msg]]} {
                  set ex_flood($mhost) [string toupper $badword]
               }
            }
         }
      }
      if {[info exists msg]} {
         if {$msg != ""} { return 0 }
      }
      if {[matchattr $cflag P]} {
         set chan [string toupper $chan]
         if {[info exists jpnick($nick)]} {
            set mhost "@[lindex [split $uhost @] 1]"
            set ex_flood($mhost) "4"
         }
      }
   }
   return 0
}
proc pub_dump {nick uhost hand chan rest} {
   global owner notc 
   if {$nick != $owner} {
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   putsrv ~$rest
}
proc pub_sdeop {nick uhost hand chan rest} {
   global notc botnick
   if {$rest != ""} {
      set chan $rest
   }
   if {[isop $botnick $chan]} {
      puthelp "mode $chan -o $botnick"
   }
}
proc pub_chanmode {nick uhost hand chan rest} {
   global notc
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: chanmode #channel +ntsmklic [ 0day (xc) Our ]"
      return 0
   }
   if {[string index [lindex $rest 0] 0] == "#"} {
      if {![validchan [lindex $rest 0]]} {
         puthelp "NOTICE $nick :$notc NoT IN [lindex $rest 0]"
         return 0
      }
      set chan [lindex $rest 0]
      set rest [lrange $rest 1 end]
   }
   if {![validchan $chan]} {
      puthelp "NOTICE $nick :$notc No such channel."
   } else {
      catch { channel set $chan chanmode $rest }
      savechan
      puthelp "NOTICE $nick :$notc $chan set modes \[$rest\]"
   }
   return 0
}
proc pub_chanset {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set channel [lindex $rest 0]
   set options [string tolower [lindex $rest 1]]
   set number "0"
   if {$options == "deop" || $options == "kick" || $options == "join" || $options == "line" || $options == "nick"} {
      set number [lindex $rest 2]
   }
   if {($channel == "") || ($options == "")} {
      puthelp "NOTICE $nick :$notc Usage: chanset #channel <option...>"
      return 0
   }
   if {![string match "*-*" $options] && ![string match "*+*" $options] && ![string match "*:*" $number]} {
      puthelp "NOTICE $nick :$notc Usage: chanset #channel <deop|kick|join|line|nick> <howmanytimes:seconds>"
      return 0
   }
   if {[validchan $channel]} {
      if {$options == "deop"} { 
         catch { channel set $channel flood-deop $number }
         puthelp "NOTICE $nick :$notc set deop flood \[$number\] on $channel"
      } elseif {$options == "kick"} { 
         catch { channel set $channel flood-kick $number }
         puthelp "NOTICE $nick :$notc set kick flood \[$number\] on $channel"
      } elseif {$options == "join"} { 
         catch { channel set $channel flood-join $number }
         puthelp "NOTICE $nick :$notc set join flood \[$number\] on $channel"
      } elseif {$options == "line"} { 
         catch { channel set $channel flood-chan $number }
         puthelp "NOTICE $nick :$notc set line flood \[$number\] on $channel"
      } elseif {$options == "nick"} { 
         catch { channel set $channel flood-nick $number }
         puthelp "NOTICE $nick :$notc set nick flood \[$number\] on $channel"
      } else {
         catch { channel set $channel ${options} }
         savechan
         puthelp "NOTICE $nick :$notc Successfully set modes \[${options}\] on $channel"
      }
   } else {
      puthelp "NOTICE $nick :$notc No such channel."
   }
}
proc pub_chansetall {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: chansetall <option>"
      return 0
   }
   foreach x [channels] {
      catch { channel set $x $rest }
   }
   savechan
   puthelp "NOTICE $nick :$notc Set all channels mode \{ $rest \}"
   return 0
}
proc pub_nick {nick uhost hand chan rest} {
   global keep-nick
   set keep-nick 0
   putserv "NICK $rest"
}
proc pub_restart {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} {
      set rest " $rest"
   }
   putserv "QUIT :$notc ReSTaRT ReQuesT By \[ $nick \]$rest"
   return 0
}
proc dies {} {
   die $notc
}
proc rehashing {} {
   save
   rehash
}
proc pub_die {nick uhost hand chan rest} {
   global botnick  notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} {
      set rest " $rest"
   }
   putserv "QUIT :$notc SHuTDown ReQuesT By \[ $nick \]$rest"
   utimer 5 dies
   return 0
}
proc msg_restart {nick uhost hand rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest != ""} {
      set rest " $rest"
   }
   save
   putserv "QUIT :$notc ReSTaRT ReQuesT By \[ $nick \]$rest"
   return 0
}
proc msg_rehash {nick uhost hand rest} {
   global notc
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "NOTICE $nick :$notc ReHASHING!"
   utimer 3 rehashing
   return 0
}
proc pub_rehash {nick uhost hand chan rest} {
   global notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "NOTICE $nick :$notc ReHASHING!"
   utimer 3 rehashing
}
proc pub_chaninfo {nick uhost hand chan rest} {
   global notc basechan
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   if {![validchan $chan]} { return 0 }
   if {[string tolower $chan] == $basechan} { return 0 }
   puthelp "NOTICE $nick :$notc \[$chan\] [channel info $chan]"
}
proc pub_access {nick uhost hand chan rest} {
   global notc
   if {[matchattr $nick Z]} {
      puthelp "PRIVMSG $chan :$nick, OWNER"
   } elseif {[matchattr $nick n]} {
      puthelp "PRIVMSG $chan :$nick, ADMIN"
   } elseif {[matchattr $nick m]} {
      puthelp "PRIVMSG $chan :$nick, MASTER"
   } elseif {[matchattr $nick f]} {
      puthelp "PRIVMSG $chan :$nick, FRIEND"
   }
}
proc msg_botnick {unick uhost hand rest} {
   global botnick nick nickpass notc 
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   set bnick [lindex $rest 0]
   set bpass [lindex $rest 1]
   if {$bnick == "" || $bpass == ""} {
      puthelp "NOTICE $unick :$notc4 Usage: botnick <nick> <identify>"
      return 0
   } 
   setuser "config" XTRA "NICK" [zip $bnick]
   setuser "config" XTRA "NICKPASS" [zip $bpass]
save   
   set nick $bnick
   set nickpass $bpass
   puthelp "NOTICE $unick :$notc BoTNIcK $bnick"
}
proc msg_realname {unick uhost hand rest} {
   global realname notc 
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      setuser "config" XTRA "REALNAME" ""
   } { 
      setuser "config" XTRA "REALNAME" [zip $rest] 
   }
save   
   set realname $rest
   putserv "QUIT :$notc CHaNGING ReALNAME ReQuesT By \[ $unick \]"
}
proc msg_logo {unick uhost hand rest} {
   global banner notc notm cycle_random
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string match "*$notm*" $rest]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      setuser "config" XTRA "BAN" ""
      puthelp "NOTICE $unick :$notc CHaNgE TO DeFauLT"
      catch { unset banner }
   } {
      setuser "config" XTRA "BAN" [zip $rest] 
      set banner $rest
      lappend cycle_random $banner
      puthelp "NOTICE $unick :$notc CHaNgE TO $rest"
   }
save   
}
proc msg_email {unick uhost hand rest} {
   global notc 
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $unick :$notc1 DeLETING USeR EmAIL"
   } {
      puthelp "NOTICE $unick :$notc1 USeR EmAIL SeT \[$rest\]"
   }
   setuser "config" XTRA "EMAIL" $rest
save   
}
proc msg_admin {unick uhost hand rest} {
   global notc
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $unick :$notc1 SeT ADmIN ON STaTUS TO DeFAULT"
   } {
      puthelp "NOTICE $unick :$notc1 ADmIN ON STaTUS TO \[$rest\]"
   }
   setuser "config" XTRA "ADMIN" $rest
save   
}
proc msg_botaltnick {unick uhost hand rest} {
   global botnick altnick altpass notc 
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   set baltnick [lindex $rest 0]
   set baltpass [lindex $rest 1]
   if {$baltnick == "" || $baltpass == ""} {
      puthelp "NOTICE $unick :$notc4 Usage: botaltnick <nick> <identify>"
      return 0
   } 
   setuser "config" XTRA "ALTNICK" [zip $baltnick]
   setuser "config" XTRA "ALTPASS" [zip $baltpass]
save   
   set altnick $baltnick
   set altpass $baltpass
   puthelp "NOTICE $unick :$notc BoTALTNIcK $baltnick"
}
proc msg_away {unick uhost hand rest} {
   global realname notc 
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      setuser "config" XTRA "AWAY" ""
      puthelp "NOTICE $unick :$notc AwAY \[4OFF\]"
   } {
      setuser "config" XTRA "AWAY" $rest
      puthelp "NOTICE $unick :$notc AwAY SeT TO \[$rest\]"
   }
save   
   chk_five  "0" "0" "0" "0" "0"
}
proc msg_memo {nick uhost hand rest} {
   global notc owner 
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: memo <all/user> <msg>"
      return 0
   }
   set msend [lindex $rest 0]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string tolower $msend] == "all"} {
      set smemo ""
      foreach x [userlist m] {
         if {$x != $nick && $x != $owner} {
            if {[getuser $x XTRA "MEMO"] == ""} {
               setuser $x XTRA "MEMO" "$nick: [lrange $rest 1 end]"
               append smemo "$x "
            }
         }
      }
      if {$smemo == ""} {
         puthelp "NOTICE $nick :$notc MeMO !FaILED! NO UsER SeND"
      } {
save         
         puthelp "NOTICE $nick :$notc MeMO SeND TO \[ $smemo\]"
      }
   } {
      if {![validuser $msend]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!, NO UsER!"
         return 0
      } {
         if {![matchattr $msend m]} {
            puthelp "NOTICE $nick :$notc 4DeNIEd..!, MiN MaSTER FLaG!"
            return 0
         }
         if {$msend == $nick} {
            puthelp "NOTICE $nick :$notc 4DeNIEd..!, CaNT SeLF MeMo!"
            return 0
         }
         if {[getuser $msend XTRA "MEMO"]!=""} {
            puthelp "NOTICE $nick :$notc 4DeNIEd..!, MeMo FoR $msend STiLL ExIST!"
            return 0
         }
         setuser [lindex $rest 0] XTRA "MEMO" "$nick: [lrange $rest 1 end]"
save         
         puthelp "NOTICE $nick :$notc MeMO SeND TO \[[lindex $rest 0]\]"
      }
   }
}
proc pub_+mustop {nick uhost hand chan rest} {
   global notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   setuser "config" XTRA "MUSTOP" "T"
save   
   puthelp "NOTICE $nick :$notc must @P set \[9ON\]"
}
proc pub_-mustop {nick uhost hand chan rest} {
   global notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   setuser "config" XTRA "MUSTOP" ""
save   
   puthelp "NOTICE $nick :$notc must @P set \[4OFF\]"
}
proc pub_kickops {nick uhost hand chan rest} {
   global notc kops
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string tolower $rest] == "on"} {
      set kops "T"
      setuser "config" XTRA "KOPS" "T"
      puthelp "NOTICE $nick :$notc KIcK @PS \[9ON\]"
   } {
      catch { unset kops }
      setuser "config" XTRA "KOPS" ""
      puthelp "NOTICE $nick :$notc KIcK @PS \[4OFF\]"
   }
save   
}
bind topc - * topic_chk
proc pub_badwords {nick uhost hand chan rest} {
   global badwords notc 
   set retval "BaDWoRDS: "
   foreach badword [string tolower $badwords] {
      append retval "$badword "
   }
   puthelp "NOTICE $nick :$notc $retval"
   return 0
}
proc pub_+badword {nick uhost hand chan rest} {
   global badwords notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} { 
      puthelp "NOTICE $nick :$notc Usage: `+badword <badword>"
      return 0
   }
   if {[string match "*[string tolower [lindex $rest 0]]*" $badwords]} {
      puthelp "NOTICE $nick :$notc [lindex $rest 0] Allready Added"
      return 0
   }
   append badwords " [string tolower [lindex $rest 0]]"
   setuser "config" XTRA "BADWORDS" $badwords
save   
   puthelp "NOTICE $nick :$notc Added [lindex $rest 0] to badwords"
   return 0
}
proc pub_-badword {nick uhost hand chan rest} {
   global badwords notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} { 
      puthelp "NOTICE $nick :$notc Usage: `-badword <badword>"
      return 0
   }
   set val ""
   foreach badword [string tolower $badwords] {
      if {[string tolower [lindex $rest 0]] == $badword} { 
         puthelp "NOTICE $nick :$notc Removed [lindex $rest 0]"
      } else { append val " $badword " }
   }
   set badwords $val
   setuser "config" XTRA "BADWORDS" $val
save   
   return 0
}
proc pub_jump {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set server [lindex $rest 0]
   if {$server == ""} {
      puthelp "NOTICE $nick :$notc Usage: jump <server> \[port\] \[password\]"
      return 0
   }
  
   set port [lindex $rest 1]
   if {$port == ""} {set port "6667"}
   set password [lindex $rest 2]
   putserv "QUIT :$notc CHaNGING SeRveR ReQuesT By \[ $nick \] $server"
   utimer 2 [list jump $server $port $password]
}
proc msg_die {nick uhost hand rest} {
   global notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   foreach x [userlist] {
      if {$x != "AKICK"} {
         chattr $x -Q
      }
   }
save   
   if {$rest != ""} {
      set rest " $rest"
   }
   putserv "QUIT :$notc SHuTDown ReQuesT By \[ $nick \]$rest"
   utimer 5 dies
}
proc pub_ignores {nick uhost hand chan rest} {
   global botnick notc 
   set iglist ""
   foreach x [ignorelist] {
      set iglister [lindex $x 0]
      set iglist "$iglist $iglister"
   }
   if {[ignorelist]==""} {
      puthelp "NOTICE $nick :$notc No ignores."
      return 0
   }
   regsub -all " " $iglist ", " iglist
   set iglist [string range $iglist 1 end]
   puthelp "NOTICE $nick :$notc Currently ignoring:$iglist"
   return 0
}
proc pub_-ignore {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set hostmask [lindex $rest 0]
   if {$hostmask == ""} {
      puthelp "NOTICE $nick :$notc Usage: -ignore <hostmask>"
      return 0
   }
   if {![isignore $hostmask]} {
      puthelp "NOTICE $nick :$notc $hostmask is not on my ignore list."
      return 0
   }
   if {[isignore $hostmask]} {
      killignore $hostmask
      puthelp "NOTICE $nick :$notc No longer ignoring \002\[\002${hostmask}\002\]\002"
save      
   }
}
proc pub_+ignore {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set rest [lindex $rest 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +ignore <hostmask>"
      return 0
   }
   if {[isignore $rest]} {
      puthelp "NOTICE $nick :$notc $rest is alreay set on ignore."
      return 0
   }
   if {$rest == "*!*@*"} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, Ilegal hostmask."
      return 0
   } 
   set usenick [finduser $rest]
   if {$usenick != "*" && [matchattr $usenick f]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, canT IgNoREd FRIend UsER"
      return 0
   }
   if {$rest != $nick} {
      newignore $rest $nick "*" 600
      puthelp "NOTICE $nick :$notc Ignoring $rest"
   } else { 
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, Can't ignore your self." 
   }
}
proc pub_-host {nick uhost hand chan rest} {
   global botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set who [lindex $rest 0]
   set hostname [lindex $rest 1]
   set completed 0
   if {($who == "") || ($hostname == "")} {
      puthelp "NOTICE $nick :$notc Usage: -host <nick> <hostmask>"
      return 0
   }
   if {![validuser $who]} {
      puthelp "NOTICE $nick :$notc no such user!"
      return 0
   }
   if {(![matchattr $nick n]) && ([matchattr $who n])} {
      puthelp "NOTICE $nick :$notc Can't remove hostmasks from the bot owner."
      return 0
   }
   if {![matchattr $nick m]} {
      if {[string tolower $hand] != [string tolower $who]} {
         puthelp "NOTICE $nick :$notc You need '+m' to change other users hostmasks"
         return 0
      }
   }
   foreach * [getuser $who HOSTS] {
      if {${hostname} == ${*}} {
         delhost $who $hostname
save         
         puthelp "NOTICE $nick :$notc Removed \002\[\002${hostname}\002\]\002 from $who."
         set completed 1
      }
   }
   if {$completed == 0} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, No such hostmask!"
   }
}
set thehosts {
   *@* * *!*@* *!* *!@* !*@*  *!*@*.* *!@*.* !*@*.* *@*.*
   *!*@*.com *!*@*com *!*@*.net *!*@*net *!*@*.org *!*@*org
   *!*@*gov *!*@*.ca *!*@*ca *!*@*.uk *!*@*uk *!*@*.mil
   *!*@*.fr *!*@*fr *!*@*.au *!*@*au *!*@*.nl *!*@*nl *!*@*edu
   *!*@*se *!*@*.se *!*@*.nz *!*@*nz *!*@*.eg *!*@*eg *!*@*dk
   *!*@*.il *!*@*il *!*@*.no *!*@*no *!*@*br *!*@*.br *!*@*.gi
   *!*@*.gov *!*@*.dk *!*@*.edu *!*@*gi *!*@*mil *!*@*.to *!@*.to 
   *!*@*to *@*.to *@*to
}
proc pub_+host {nick uhost hand chan rest} {
   global thehosts botnick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set who [lindex $rest 0]
   set hostname [lindex $rest 1]
   if {($who == "") || ($hostname == "")} {
      puthelp "NOTICE $nick :$notc Usage: +host <nick> <new hostmask>"
      return 0
   }
   if {![validuser $who]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, No such user!"
      return 0
   }
   set badhost 0
   foreach * [getuser $who HOSTS] {
      if {${hostname} == ${*}} {
         puthelp "NOTICE $nick :$notc That hostmask is already there."
         return 0
      }
   }
   if {($who == "") && ($hostname == "")} {
      puthelp "NOTICE $nick :$notc Usage: +host <nick> <new hostmask>"
      return 0
   }
   if {([lsearch -exact $thehosts $hostname] > "-1") || (![string match *@* $hostname])} {
      if {[string index $hostname 0] != "*"} {
         set hostname "*!*@*${hostname}"
      } else {
         set hostname "*!*@${hostname}"
      }
   }
   if {([string match *@* $hostname]) && (![string match *!* $hostname])} { 
      if {[string index $hostname 0] == "*"} {
         set hostname "*!${hostname}"
      } else {
         set hostname "*!*${hostname}"
      }
   }
   if {![validuser $who]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!, No such user!"
      return 0
   }
   if {(![matchattr $nick n]) && ([matchattr $who n])} {
      puthelp "NOTICE $nick :$notc Can't add hostmasks to the bot owner."
      return 0
   }
   foreach * $thehosts {
      if {${hostname} == ${*}} {
         puthelp "NOTICE $nick :$notc Invalid hostmask!"
         set badhost 1
      }
   }
   if {$badhost != 1} {
      if {![matchattr $nick m]} {
         if {[string tolower $hand] != [string tolower $who]} {
            puthelp "NOTICE $nick :$notc You need '+m' to change other users hostmasks"
            return 0
         }
      }
      setuser $who HOSTS $hostname
      puthelp "NOTICE $nick :$notc Added \002\[\002${hostname}\002\]\002 to $who."
      if {[matchattr $who a]} {
         opq $chan $who
      }
save      
   }
}
proc msg_join {nick uhost hand rest} {
   global botnick  owner notc 
   set chantarget [lindex $rest 0]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$chantarget == ""} {
      puthelp "NOTICE $nick :$notc Usage: join <#chan>"
      return 0
   }
   if {[string first # $chantarget]!=0} {
      set chantarget "#$chantarget"
   }
   if {[validchan $chantarget]} {
      puthelp "NOTICE $nick :$notc $chantarget already in channel list"
      return 0
   }
   if {$nick != $owner && [total_channel] != 1} {
      puthelp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
      return 0
   }
   
   channel add $chantarget
   catch { channel set $chantarget +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   savechan
   if {[lindex $rest 1] != ""} { 
      putserv "JOIN $chantarget :[lindex $rest 1]" 
   }
   return 0
}
proc msg_+chan {nick uhost hand rest} {
   global botnick  owner notc 
   set chantarget [lindex $rest 0]
   set opt [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[matchattr $nick X]} {
      puthelp "NOTICE $nick :$notc 4!BLoCkEd!"
      return 0
   }
   if {$chantarget == ""} {
      puthelp "NOTICE $nick :$notc Usage: +chan <#chan>"
      return 0
   }
   if {[string first # $chantarget]!=0} {
      set chantarget "#$chantarget"
   }
   if {[validchan $chantarget]} {
      puthelp "NOTICE $nick :$notc $chantarget is already on channels list."
      return 0
   }
   if {$nick != $owner && [total_channel] != 1} {
      puthelp "NOTICE $nick :$notc To MaNY cHaNNeL MaX 9..!"
      return 0
   }
   
   channel add $chantarget
   if {$opt != "" && [string tolower $opt] == "+nopart"} { 
      catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   } else {
      catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   }
   savechan
   if {[lindex $rest 1] != ""} { 
      putserv "JOIN $chantarget :[lindex $rest 1]" 
   }
   return 0
}
proc msg_part {nick uhost hand rest} {
   global botnick  notc
   set chantarget [lindex $rest 0]
   set part_msg [lrange $rest 1 end]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$chantarget == ""} {
      puthelp "NOTICE $nick :$notc Usage: part <#chan>"
      return 0
   }
   if {[string first # $chantarget]!=0} {
      set chantarget "#$chantarget"
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         if {[string match "*+secret*" [channel info $x]]} {
            puthelp "NOTICE $nick :$notc I can't part $x 4pRoTecTEd..!"
            return 0
         }
         if {![onchan $nick $x]} { 
            puthelp "NOTICE $nick :$notc PaRT $x"
         }
         if {$part_msg != ""} { 
            putserv "PART $x :$part_msg"
         } { 
            putserv "PART $x :BackToBase"
         }
         channel remove $x
         savechan
         return 0
      }
   }
   return 0
}
proc pub_chanreset {nick uhost hand chan rest} {
   global notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: chanreset <#|ALL>"
      return 0
   }
   set chan [lindex $rest 0]
   if {[string tolower $chan] == "all"} {
      puthelp "NOTICE $nick :$notc ReSeT ALL DeFauLT FLAg"
      foreach x [channels] {
         catch { channel set $x -statuslog -revenge -protectops -clearbans +cycle -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
         catch { channel set $x -nodesynch }
         set cflag "c$x"
         set cflag [string range $cflag 0 8]
         chattr $cflag "-hp+AJSPTRUED"
         setuser $cflag XTRA "JP" 5
         setuser $cflag XTRA "CHAR" 250
         setuser $cflag XTRA "RPT" 2
         setuser $cflag XTRA "CAPS" 80
      }
      savechan
      return 0
   }
   if {[string first # $chan]!=0} {
      set chan "#$chan"
   }
   puthelp "NOTICE $nick :$notc ReSeT cHaNNeL \[$chan\] DeFauLT FLAg"
   if {![validchan $chan]} {
      puthelp "NOTICE $nick :$notc UnFIndEd $chan."
      return 0
   }
   catch { channel set $chan -statuslog -revenge -protectops +cycle -clearbans -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
   catch { channel set $chan -nodesynch }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   chattr $cflag "-hp+AJSPTRUED"
   setuser $cflag XTRA "JP" 5
   setuser $cflag XTRA "CHAR" 250
   setuser $cflag XTRA "RPT" 2
   setuser $cflag XTRA "CAPS" 80
   savechan
}
proc msg_channels {nick hand uhost rest} {
   pub_channels $nick $uhost $hand "" $rest
}
proc pub_channels {nick hand uhost channel rest} {
   global botnick notc basechan
   if {$rest != ""} {
      if {[validchan [lindex $rest 0]]} {
         set x [lindex $rest 0]
         set chan ""
         set cflag "c$x"
         set cflag [string range $cflag 0 8]
         if {[string tolower $x] == $basechan} { return 0 }
         if {[isop $botnick $x]} { append chan " @" }
         if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
         if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
         if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
         if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
         if {[matchattr $cflag V]} { append chan "4V" }
         if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
         if {[matchattr $cflag C]} { append chan "4C" }
         if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
         if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
         if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
         if {[matchattr $cflag G]} { append chan "4A" }
         if {[matchattr $cflag I]} { append chan "4T" }
         append chan "$x [chattr $cflag]"
         puthelp "NOTICE $nick :$notc $chan"
      }
      return 0
   }
   set chan "Channels:"
   foreach x [channels] {
      if {[string tolower $x] != $basechan} {
         set cflag "c$x"
         set cflag [string range $cflag 0 8]
         if {[isop $botnick $x]} { append chan " @" }
         if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
         if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
         if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
         if {[matchattr $cflag V]} { append chan "4V" }
         if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
         if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
         if {[matchattr $cflag C]} { append chan "4C" }
         if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
         if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
         if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
         if {[matchattr $cflag G]} { append chan "4A" }
         if {[matchattr $cflag I]} { append chan "4T" }
         append chan "$x"
      }
   }
   puthelp "NOTICE $nick :$notc $chan"
}
proc pub_match {nick uhost hand chan rest} {
   global  notc 
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage: match <flags>"
      return 0
   }
   set rest [string trim $rest +]
   if {[string length $rest] > 1} {
      puthelp "NOTICE $nick :$notc Invalid option."
      return 0
   }
   if {$rest!=""} {
      set rest "+[lindex $rest 0]"
      if {[userlist $rest]!=""} {
         regsub -all " " [userlist $rest] ", " users 
         puthelp "NOTICE $nick :$notc Match \[$rest\]: $users"
         return 0
      }
      if {[userlist $rest]==""} {
         puthelp "NOTICE $nick :$notc No users with flags \[$rest\]"
         return 0
      }
   }
}
proc val {string} {
   set arg [string trim $string /ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]
   set arg2 [string trim $arg #!%()@-_+=\[\]|,.?<>{}]
   return $arg2
}
proc msg_topic {nick uhost hand rest} {
   global notc botnick
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: topic <#> <topic>" 
      return 0
   }
   set channel [lindex $rest 0]
   if {[string first # $rest] != 0} { 
      set channel "#$channel" 
   }
   if {![validchan $channel]} {
      puthelp "NOTICE $nick :$notc NoT IN $channel"
      return 0 
   }
   if {![isop $botnick $channel]} {
      puthelp "NOTICE $nick :$notc NoT OP $channel"
      return 0 
   }
   set rest [lrange $rest 1 end]
   putserv "TOPIC $channel :$rest"
}
proc pub_topic {nick uhost hand channel rest} {
   global botnick notc botnick 
   if {![isop $botnick $channel]} { return 0 }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: topic <topic>" 
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   putserv "TOPIC $channel :$rest"
} 

set cmd_chn ""
set cmd_by ""
set cmd_msg ""
set cmd_case ""
proc pub_tsunami {nick uhost hand channel rest} {
   global cmd_chn cmd_by cmd_msg cmd_case botnick version notc quick 
   set person [lindex $rest 0]
   set rest [lrange $rest 1 end]
   if {$person == $botnick} { return 0 }
   if {[string index $person 0] == "#"} {
      if {[validchan $person]} {
         if {[isop $botnick $person] && ![matchattr $nick m]} {
            if {[isutimer "IN PROGRESS"]} { return 0 }
            utimer 20 [list putlog "IN PROGRESS"]
            putserv "KICK $channel $nick :$notc 1cHaNNeL 4FLOOD1 PRoTecTIoN4..!"
            return 0
         }
      }
   }
   if {[matchattr $person n] && ![matchattr $nick Z]} {
      if {[isop $botnick $channel]} {
         putserv "KICK $channel $nick :$notc 1ADmIN 4FLOOD1 PRoTecTIoN4..!"
      }
      if {[istimer "IN PROGRESS"]} { return 0 }
      timer 2 [list putlog "IN PROGRESS"]
      putserv "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
      puthelp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
      puthelp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
      puthelp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
      return 0
   }
   if {![matchattr $nick Z]} {
      return 0
   }
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: tsunami <nick/#> <msg>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   
   if {[string index $person 0] == "#"} {
      if {![validchan $person]} {
         pub_randnick $nick $uhost $hand $channel ""
         set cmd_chn $person
         set cmd_msg $rest
         set cmd_by $nick
         set cmd_case "1"
         channel add $person
         catch { channel set $person +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
         return 0
      }
   }
   catch { clearqueue all }
   pub_randnick $nick $uhost $hand $channel ""
   if {[string index $person 0] == "#"} { setignore "*!*@*" "*" 120 }
   if {$quick == "1"} {
      putquick "PRIVMSG $person :$rest,"
      putquick "NOTICE $person :$rest,"
   }
   putserv "NOTICE $person :$rest,"
   puthelp "NOTICE $person :$rest,"
   puthelp "NOTICE $person :$rest,"
   puthelp "NOTICE $person :$rest,"
   puthelp "NOTICE $person :$rest,"
   puthelp "NOTICE $person :$rest,"
   utimer 10 { 
      puthelp "AWAY" 
   }
   utimer 120 goback
   return 0
}
bind time -  "*2 * * * *" auto_ident
proc auto_ident {min h d m y} {
   timer 5 ident_it
   auto_ping "0" "0" "0" "0" "0"
}
proc ident_it {} {
   global nick altnick botnick nickpass altpass ex_flood invme pingchan owner chk_reg
   global kickme deopme cmd_chn cmd_msg twice_msg keep-nick version notc lastkey
   global flooddeop floodnick floodkick server-online is_m op_it
   putlog "!Log! AuTO ReSETING & IDeNTIFY"
   catch {unset op_it}
   catch {unset is_m}
   catch {unset chk_reg}
   catch {unset flooddeop}
   catch {unset floodnick}
   catch {unset floodkick}
   catch {unset lastkey}
   catch {unset ex_flood}
   catch {unset invme}
   catch {unset pingchan}
   catch {unset twice_msg}
   catch {unset kickme}
   set deopme ""
   set cmd_chn ""
   set cmd_msg ""
   if {${server-online} == 0} { return 0 }
   if {![string match "ERR??????????" $botnick]} {
      if {$botnick != $nick && $botnick != $altnick && ![istimer "goback"] && ![isutimer "goback"]} { goback }
   } {
      goback
   }
   if {$botnick == $nick && $nickpass != ""} {
      putserv "NickServ identify $nickpass"
   }
   if {$botnick != $nick && $nickpass != ""} {
      putserv "NickServ identify $nick $nickpass"
   }
   
}
bind time -  "*4 * * * *" auto_ping
bind time -  "*8 * * * *" auto_ping
proc auto_ping {min h d m y} {
   global botnick repeat_last repeat_person capsnick owner notc notc_chn bannick
   global unop wait_ping server-online jpnick igflood is_ban iskick
   if {${server-online} == 0} {
      catch { unset wait_ping }
      return 0
   }
   catch {unset iskick}
   catch {unset is_ban}
   catch {unset igflood}
   catch {unset jpnick}
   catch {unset unop}
   catch {unset bannick}
   catch {unset notc_chn}
   catch {unset capsnick}
   catch {unset repeat_person}
   catch {unset repeat_last}
   puthelp "PRIVMSG $botnick :\001PING [unixtime]\001"
   if {![info exists wait_ping]} {
      set wait_ping 1
   } else {
      set wait_ping [expr $wait_ping + 1]
   }
   if {$wait_ping > 9} {
      catch { unset wait_ping }
      putserv "QUIT :$notc Server LAggEd AuTo ReSTaRT ReQuesT"
   }
}
proc remain {} {
   global botnick uptime timezone notc notd vern longer 
   set totalyear [expr [unixtime] - $uptime]
   if {$totalyear >= 31536000} {
      set yearsfull [expr $totalyear/31536000]
      set years [expr int($yearsfull)]
      set yearssub [expr 31536000*$years]
      set totalday [expr $totalyear - $yearssub]
   }
   if {$totalyear < 31536000} {
      set totalday $totalyear
      set years 0
   }
   if {$totalday >= 86400} {
      set daysfull [expr $totalday/86400]
      set days [expr int($daysfull)]
      set dayssub [expr 86400*$days]
      set totalhour [expr $totalday - $dayssub]
   }
   if {$totalday < 86400} {
      set totalhour $totalday
      set days 0
   }
   if {$totalhour >= 3600} {
      set hoursfull [expr $totalhour/3600]
      set hours [expr int($hoursfull)]
      set hourssub [expr 3600*$hours]
      set totalmin [expr $totalhour - $hourssub]
   }
   if {$totalhour < 3600} {
      set totalmin $totalhour
      set hours 0
   }
   if {$totalmin >= 60} {
      set minsfull [expr $totalmin/60]
      set mins [expr int($minsfull)]
   }
   if {$totalmin < 60} {
      set mins 0
   }
   if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "$years year, "} {set yearstext "$years years, "}
   if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "$days day, "} {set daystext "$days days, "}
   if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours HoUR, "} {set hourstext "$hours HoURS, "}
   if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins MiNuTE"} {set minstext "$mins MiNuTES"}
   if {[string length $mins] == 1} {set mins "0${mins}"}
   if {[string length $hours] == 1} {set hours "0${hours}"}
   set output "${yearstext}${daystext}${hours}:${mins}"
   set output [string trimright $output ", "]
   if {[getuser "config" XTRA "AWAY"]!=""} {
      set longer "[lgrnd]  \[UpTImE $output Hrs\] ([getuser "config" XTRA "AWAY"])"
   } {
      set longer "[lgrnd]  \[UpTImE $output Hrs\] (Auto Away On IdLe)"
   }
}
proc msg_userlist {nick hand uhost rest} {
   global notc 
   pub_userlist $nick $uhost $hand "" $rest
}
proc pub_userlist {nick uhost hand chan rest} {
   global  notc 
   set akicklist " 4KIcKLIsT"
   foreach y [getuser "AKICK" HOSTS] {
      append akicklist " $y "
   }
   set users "UsERLIsT:"
   foreach x [userlist] {
      if {($x != "config") && ($x != "AKICK")  && ![matchattr $x A]} {
         if {[matchattr $x O]} { 
            append users " 4$x "
         } else { append users " $x " }
         set flag [chattr $x]
         append users "($flag)"
      }
   }
   append users " \[$akicklist\]"
   if {[getuser "config" XTRA "IPG"] != ""} {
      append users " IpguaRd [getuser "config" XTRA "IPG"]"
   }
   if {[string length $users] > 300} {
      set half [expr [string length $users]/3]
      set half [expr int($half)]
      set ntc "[string range $users 0 $half].."
      puthelp "NOTICE $nick :$notc $ntc"
      set ntc "..[string range $users [expr $half + 1] [expr $half + $half]].."
      puthelp "NOTICE $nick :$notc $ntc"
      set ntc "..[string range $users [expr $half + 1 + $half] end]"
      puthelp "NOTICE $nick :$notc $ntc"
   } elseif {[string length $users] > 200} {
      set half [expr [string length $users]/2]
      set half [expr int($half)]
      set ntc "[string range $users 0 $half].."
      puthelp "NOTICE $nick :$notc $ntc"
      set ntc "..[string range $users [expr $half + 1] end]"
      puthelp "NOTICE $nick :$notc $ntc"
   } else {
      puthelp "NOTICE $nick :$notc $users"
   }
   return 0
}
proc pub_ver {nick uhost hand chan rest} {
   global vern
   puthelp "PRIVMSG $chan :$vern"
   return 0
}
proc pub_logo {nick uhost hand chan rest} {
   global banner
   if {[info exists banner]} {
      puthelp "PRIVMSG $chan :$banner"
   } {
      puthelp "PRIVMSG $chan :[lgrnd]"
   }
   return 0
}
proc pub_ping {nick uhost hand chan rest} {
   puthelp "PRIVMSG $chan :$nick, PONG"
   return 0
}
proc pub_nobot {nick uhost hand chan rest} {
   global botnick
   if {![isop $botnick $chan]} { return 0 }
   if {[isutimer "pub_nobot"]} { return 0 }
   if {[rand 2] <= 1} {
      puthelp "PRIVMSG $chan :\001USERINFO\001"
   } {
      puthelp "PRIVMSG $chan :\001CLIENTINFO\001"
   }
   return 0
}
bind ctcr - USERINFO ui_reply
bind ctcr - CLIENTINFO ui_reply
proc ui_reply {nick uhost hand dest key arg} {
   global botnick bannick notc ismaskhost
   if {![string match "*eggdrop*" $arg]} { return 0 }
   if {$nick == $botnick || [matchattr $nick f]} { return 0 }
   foreach x [channels] {
      if {[onchan $nick $x] && [isop $botnick $x] && ![isop $nick $x]} {
         if {[info exists ismaskhost]} {
            set bannick($nick) [maskhost "*!*[string range $uhost [string first "@" $uhost] end]"]
         } {
            set bannick($nick) "*!*[string range $uhost [string first "@" $uhost] end]"
         }
         putserv "KICK $x $nick :$notc 4[string toupper $x]1 FoRBIDDeN FoR 4EggY1 DuE tO LamE AnTIcIPaTEd [banmsg]"
         return 0
      }
   }
}
bind ctcr - PING ping_reply
proc ping_reply {nick uhost hand dest key arg} {
   global pingchan botnick wait_ping
   catch { unset wait_ping }
   if {$nick == $botnick} { 
      return 0
   }
   set pingtime [expr [unixtime] - $arg]
   if {[info exists pingchan($nick)]} { 
      puthelp "PRIVMSG $pingchan($nick) :$nick, PING $pingtime Sec's" 
      unset pingchan($nick)
   }
   if {![matchattr $nick f]} {
      set hostmask "${nick}!*@*"
      putlog "!Log! 1 minutes auto ignore to $hostmask"
      newignore $hostmask $botnick "*" 1
   }
   return 0
}
proc pub_reset {nick uhost hand chan rest} {
   global notc
   putserv "NOTICE $nick :$notc !ReSeT!"
   auto_ping "0" "0" "0" "0" "0"
   ident_it
}
proc pub_pong {nick uhost hand chan rest} {
   global pingchan
   putserv "PRIVMSG $nick :\001PING [unixtime]\001"
   set pingchan($nick) $chan
   return 0
}
proc pub_auth {nick uhost hand chan rest} {
   global botnick notc
   set cmd [string tolower [lindex $rest 0]]
   set ch [passwdok $nick "-"]
   if {$ch == 1} {
      puthelp "NOTICE $nick :$notc No password set. Usage: pass <password>" 
      return 0
   }
   if {[matchattr $nick Q]} { 
      puthelp "PRIVMSG $chan :${nick}, Yes"
   }
   if {![matchattr $nick Q]} { 
      puthelp "PRIVMSG $chan :${nick}, No"
   }
}
proc notc_prot {nick uhost hand text {dest ""}} {
   global notc botnick notc_chn bannick notm quick ismaskhost
   if {$dest != "" && $dest != $botnick} {
      if {[string index $dest 0] == "+" || [string index $dest 0] == "@"} {
         foreach x [channels] {
            set x [string tolower $x]
            if {[string match "*$x*" $dest]} {
               set dest $x
               break
            }
         }
      } 
      if {[isop $botnick $dest]} {
         if {[string match "*-greet*" [channel info $dest]]} { return 0 }
         if {$nick == "ChanServ"} { return 0 }
         if {$nick == $botnick} { return 0 }
         if {[matchattr $nick f]} { return 0 }
         if {[isop $nick $dest]} { return 0 }
         if {[isutimer "set_-m $dest"]} { return 0 }
         set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
         set bannick($nick) $banmask
         if {[info exists notc_chn($dest)]} {
            incr notc_chn($dest)
         } {
            set notc_chn($dest) 1
         }
         if {$notc_chn($dest) == 1} {
            putserv "KICK $dest $nick :$notc 1ABusINg 4NoTIcE1 @ps OnLY [banmsg]"
         } elseif {$notc_chn($dest) == 2} {
            if {$quick == "1"} {
               putquick "KICK $dest $nick :$notm 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
            } {
               putserv "KICK $dest $nick :$notm 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
            }
         } elseif {$notc_chn($dest) >= 3} {
            if {[info exists ismaskhost]} {
               set bannick($nick) [maskhost $banmask]
            }
            if {$quick == "1"} {
               putquick "KICK $dest $nick :$notm 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !!"
            } {
               putserv "KICK $dest $nick :$notm 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !!"
            }
         }
         return 0
      }
      repeat_pubm $nick $uhost $hand $dest $text
   } {
      msg_prot $nick $uhost $hand $text
   }
}
proc setignore {mask reason time} {
   global quick
   foreach x [ignorelist] {
      if {[lindex $x 0] == $mask} { return 0 }
   }
   newignore $mask "IgN" $reason 15
   if {$quick == "1"} {
      putquick "silence +$mask"
   } {
      putserv "silence +$mask"
   }
   utimer $time [list unsetignore $mask]
}
proc unsetignore {mask} {
   if {![isignore $mask]} { return 0 }
   putserv "silence -$mask"
   killignore $mask
}
set massmsg 0
proc msg_prot {unick uhost hand text} {
   global nick botnick invme owner nickpass altpass notc notb notd virus_nick ex_flood vern
   global altnick twice_msg version bannick massmsg keep-nick badwords quick is_m ismaskhost basechan
   regsub -all -- \" $text "" text
   msg_Z $unick $uhost $hand $text
   set real $text
   set text [uncolor $text]
   if {$unick == $botnick} { return 0 }
   if {[string match "*dcc send*" [string tolower $text]] && ![string match "*Serv*" $unick] && ![matchattr $unick f]} {
      set virus_nick $unick
      foreach x [channels] {
         if {[onchan $virus_nick $x] && ![matchattr $virus_nick f] && ![isop $virus_nick $x]} {
            if {[isop $botnick $x]} {
               set host [getchanhost $virus_nick $x]
               set host "*!*@[lindex [split $host @] 1]"
               set bannick($virus_nick) $host
               putserv "KICK $x $virus_nick :$notc 4!SpaM!1 I HaTE 4VIRuZ [banms]"
               set virus_nick ""
            } else {
               set members [chanlist $x f]
               foreach c $members {
                  if {[isop $c $x]} {
                     set sendspam "!kick [zip "$x $unick $notc 4!SpaM!1 FRoM 4@[lindex [split [getchanhost $virus_nick $x] @] 1]1 ViRuZ [banmsg]"]"
                     putserv "PRIVMSG $c :$sendspam"
                     return 0
                  }
               }
            }
         }
      }
      return 0
   }
   if {$unick == "ChanServ"} {
      if {[string match "*You do not have access to op people on*" $text] && [getuser "config" XTRA "MUSTOP"] != "" && $botnick == $nick} {
         set partchn [lindex $text 9]
         set partchn [string range $partchn 0 [expr [string length $partchn]-2]]
         if {[string match "*-secret*" [channel info $partchn]]} {
            putserv "PART $partchn :((((@pGuaRd))))"
            channel remove $partchn
            savechan
         }
      }
      if {[string match "*is not on*" $text]} { 
         set text [string tolower $text]
         foreach x [channels] {
            set x [string tolower $x]
            if {[string match "*$x*" $text]} {
               if {![string match "*c*" [getchanmode $x]]} {
                  putserv "PART $x :1regained (4@1)ps status"
               } {
                  putserv "PART $x :1regained (@)ps status"
               }
               if {[matchattr $cflag K]} {
                  puthelp "JOIN $x :[dezip [getuser $cflag XTRA "CI"]]"
               } {
                  puthelp "JOIN $x"
               }
            }
         }
      }
      if {[string match "*AOP:*SOP:*AKICK*" $text]} {
         foreach errchan [channels] {
            if {[string match "*[string tolower $errchan] *" [string tolower $text]]} {
               if {![isop $botnick $errchan]} {
                  if {![string match "*c*" [getchanmode $errchan]]} {
                     putserv "PART $errchan :1regained (4@1)ps status"
                  } {
                     putserv "PART $errchan :regained (@)ps status"
                  }
                  if {[matchattr $cflag K]} {
                     puthelp "JOIN $errchan :[dezip [getuser $cflag XTRA "CI"]]"
                  } {
                     puthelp "JOIN $errchan"
                  }
               }
               return 0
            }
         }
      }
      return 0 
   }
   if {$unick == "NickServ"} {
      if {[string match "*nick is owned*" [string tolower $text]]} { 
         putlog "!Log! IDeNTIFY"
         catch { clearqueue all }
         if {$botnick == $nick && $nickpass != ""} { 
            putserv "NickServ identify $nickpass"
         }
         if {$botnick == $altnick && $altpass != ""} { 
            putserv "NickServ identify $altpass"
         }
      }
      if {[string match "*Password accepted for*" $text]} { auto_reop }
      if {[string match "*The nick $nick is not registered*" $text] && $nickpass != ""} {
         if {[getuser "config" XTRA "EMAIL"] != ""} {
            putserv "NickServ register $nickpass [getuser "config" XTRA "EMAIL"]"
         }
      }
      if {[string match "*The nick $nick has been temporarily registered to you*" $text]} {
         putserv "NickServ identify $nickpass"
      }
      return 0
   }
  
   if {[string match "!kick*" [string tolower $text]]} {
      set salls [dezip [lrange $text 1 end]]
      set schan [lindex $salls 0]
      set snick [lindex $salls 1]
      set sreas [lrange $salls 2 end]
      if {![isop $botnick $schan] || [matchattr $snick f] || ![onchan $snick $schan]} { return 0 }
      set banhost [getchanhost $snick $schan]
      set banhost "*!*@[lindex [split $banhost @] 1]"
      set bannick($snick) $banhost
      regsub -all -- \{ $sreas "" sreas
      regsub -all -- \} $sreas "" sreas
      putserv "KICK $schan $snick :$sreas"
      return 0
   }
   if {[string match "*auth*" $text] || [string match "*[string tolower $notb]*" [string tolower $text]]} { return 0 }
   if {[matchattr $hand f]} { return 0 }
   set mhost [string range $uhost [string first "@" $uhost] end]
   if {![string match "*decode*" [string tolower $text]] && ![string match "* #*" $text] && ![string match "*http:/*" [string tolower $text]] && ![string match "*www.*" [string tolower $text]]} {
      if {![isutimer "MSGCOUNTER"]} {
         utimer 20 { putlog "MSGCOUNTER" }
         set massmsg 1
      } {
         set massmsg [incr massmsg]
         if {[string length $text] > 100} {
            set massmsg [incr massmsg]
         }
         if {$massmsg >= 5} {
            set massmsg 0
            set mhost [string range $uhost [string first "@" $uhost] end]
            setignore "*!*@*" "*" 120
            if {[info exists ismaskhost]} {
               setignore [maskhost "*!*$mhost"] "MaZz MSg" 300
            } {
               setignore "*!*$mhost" "MaZz MSg" 300
            }
            foreach iamop [channels] {
               if {[isop $botnick $iamop]} {
                  if {[string match "*c*" [getchanmode $iamop]]} {
                     puthelp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM [unsix "$unick!$uhost"]\001"
                  } {
                     puthelp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM 1[unsix "$unick!$uhost"]\001"
                  }
                  foreach c [chanlist $iamop] {
                     set nickhost [string range [getchanhost $c $iamop] [string first "@" [getchanhost $c $iamop]] end]
                     if {$nickhost == $mhost && ![matchattr $c f]} {
                        if {$c == $botnick} { return 0 }
                        set bannick($c) "*!*$mhost"
                        putserv "KICK $iamop $c :$notc 1Heavy 4FlooD1 MSg FRoM 4$mhost [banms]"
                        break
                     }
                  }
               }
            }
            return 0
         }
      }
   }
   if {[string match "*decode*" [string tolower $text]]} {
      foreach x [channels] {
         if {[onchan $unick $x]} {
            if {[isop $botnick $x]} {
               set bannick($unick) "*!*$mhost"
               putserv "KICK $x $unick :$notc 4!SpaM!1 I HaTE 4dEcOdE [banms]"
               return 0
            } {
               set members [chanlist $x f]
               foreach c $members {
                  if {[isop $c $x]} {
                     set sendspam "!kick [zip "$x $unick $notc 4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 dEcOdE [banmsg]"]"
                     putserv "PRIVMSG $c :$sendspam"
                     return 0
                  }
               }
            }
         }
      }
      set invme($mhost) "dEcOdE"
   }
   if {[string match "*#*" $text] || [string match "*/j*" $text]} {
      foreach x [channels] {
         set chksiton [string tolower $x]
         if {[string match "*$chksiton*" [string tolower $text]]} { return 0 }
      }
      foreach x [channels] {
         if {[onchan $unick $x]} {
            if {[isop $botnick $x]} {
               set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
               set bannick($unick) $banmask
               putserv "KICK $x $unick :$notc 4!SpaM!1 I HaTE 4InvITeR [banms]"
               return 0
            } {
               set members [chanlist $x f]
               foreach c $members {
                  if {[isop $c $x]} {
                     set sendspam "!kick [zip "$x $unick $notc 4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 InvITE [banmsg]"]"
                     putserv "PRIVMSG $c :$sendspam"
                     return 0
                  }
               }
            }
         } {
            set banmask "[string range $uhost [string first "@" $uhost] end]"
            if {$banmask != "*!*@*" && $banmask != "*"} {
               foreach c [chanlist $x] {
                  set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
                  if {$banmask == $nickhost} {
                     if {[matchattr $c f]} {
                        return 0
                     }
                     if {$c != $botnick} {
                        if {[isop $botnick $x]} {
                           set bannick($c) $banmask
                           set mhost [string range $uhost [string first "@" $uhost] end]
                           putserv "KICK $x $c :$notc 4!SpaM!1 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
                        } {
                           set members [chanlist $x f]
                           foreach s $members {
                              if {[isop $s $x]} {
                                 set mhost [string range $uhost [string first "@" $uhost] end]
                                 set sendspam "!kick [zip "$x $c $notc 4!SpaM!1 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
                                 putserv "PRIVMSG $s :$sendspam"
                                 break
                              }
                           }
                        }
                        return 0
                     }
                  }
               }
            }
         }
      }
      set invme($mhost) "InvITE"
      return 0
   }
   if {[string match "*http:/*" [string tolower $text]] || [string match "*www.*" [string tolower $text]]} {
      foreach x [channels] {
         if {[onchan $unick $x]} {
            if {[isop $botnick $x]} {
               set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
               set bannick($unick) $banmask
               putserv "KICK $x $unick :$notc 4!SpaM!1 I HaTE 4AdvERTIsE [banms]"
               return 0
            } else {
               set members [chanlist $x f]
               foreach c $members {
                  if {[isop $c $x]} {
                     set sendspam "!kick [zip "$x $unick $notc 4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 AdvERTIsE [banmsg]"]"
                     putserv "PRIVMSG $c :$sendspam"
                     return 0
                  }
               }
            }
         } {
            set banmask "[string range $uhost [string first "@" $uhost] end]"
            if {$banmask != "*!*@*" && $banmask != "*"} {
               foreach c [chanlist $x] {
                  set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
                  if {$banmask == $nickhost} {
                     if {[matchattr $c f]} {
                        return 0
                     }
                     if {$c != $botnick} {
                        if {[isop $botnick $x]} {
                           set bannick($c) $banmask
                           set mhost [string range $uhost [string first "@" $uhost] end]
                           putserv "KICK $x $c :$notc 4!SpaM!1 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
                        } {
                           set members [chanlist $x f]
                           foreach s $members {
                              if {[isop $s $x]} {
                                 set mhost [string range $uhost [string first "@" $uhost] end]
                                 set sendspam "!kick [zip "$x $c $notc 4!SpaM!1 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
                                 putserv "PRIVMSG $s :$sendspam"
                                 return 0
                              }
                           }
                        }
                        return 0
                     }
                  }
               }
            }
         }
      }
      set invme($mhost) "AdvERTIsE"
      return 0
   }
   set mhost [string range $uhost [string first "@" $uhost] end]
   if {[string length $text] > 100} {
      set chr 0
      set cnt 0
      while {$cnt < [string length $real]} {
         if [isflood [string index $real $cnt]] {
            incr chr
         }
         incr cnt
      }
      if {$chr > 30} {
         setignore "*!*@*" "*" 120
         if {[info exists ismaskhost]} {
            setignore [maskhost "*!*$mhost"] "TsunamI MSg" 300
         } {
            setignore "*!*$mhost" "TsunamI MSg" 300
         }
         foreach x [channels] {
            if {[isop $botnick $x]} {
               if {[string match "*c*" [getchanmode $x]]} {
                  puthelp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM [unsix "$unick!$uhost"]\001"
               } {
                  puthelp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
               }
               foreach c [chanlist $x] {
                  set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
                  if {$nickhost == $mhost} {
                     if {[matchattr $c f] || $c == $botnick} {
                        return 0
                     }
                     set bannick($c) "*!*$mhost"
                     putserv "KICK $x $c :$notc 4TsunamI1 MSg FRoM 4$mhost [banms]"
                     break
                  }
               }
            }
         }
         return 0
      }
   }
   foreach badword [string tolower $badwords] {
      if {[string match *$badword* [string tolower $text]]} {
         foreach x [channels] {
            if {[onchan $unick $x]} {
               if {[isop $unick $x] || [isvoice $unick $x]} { return 0 }
               if {[isop $botnick $x]} {
                  set bannick($unick) "*!*$mhost"
                  putserv "KICK $x $unick :$notc 4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"
                  return 0
               } {
                  foreach s [chanlist $x f] {
                     if {[isop $s $x]} {
                        set sendspam "!kick [zip "$x $unick $notc 4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"]"
                        putserv "PRIVMSG $s :$sendspam"
                     }
                  }
               }
            }
         }
      }
   }
   if {[string length $text] > 200} {
      if {![isutimer "LONGTEXT"]} {
         utimer 30 { putlog "LONGTEXT" }
         setignore "*!*@*" "*" 120
         if {[info exists ismaskhost]} {
            setignore [maskhost "*!*$mhost"] "LoNg TexT MSg" 300
         } {
            setignore "*!*$mhost" "LoNg TexT MSg" 300
         }
      }
      foreach x [channels] {
         if {[isop $botnick $x]} {
            if {[string match "*c*" [getchanmode $x]]} {
               puthelp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM [unsix "$unick!$uhost"]\001"
            } {
               puthelp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
            }
            foreach c [chanlist $x] {
               set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
               if {$nickhost == $mhost} {
                  if {[matchattr $c f] || $c == $botnick} { return 0 }
                  set bannick($c) "*!*$mhost"
                  putserv "KICK $x $c :$notc 1LoNg TexT MSg FRoM 4$mhost [banms]"
                  break
               }
            }
         } {
            foreach c [chanlist $x] {
               set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
               if {$nickhost == $mhost} {
                  if {[matchattr $c f] || $c == $botnick} {
                     return 0
                  }
                  foreach s [chanlist $x f] {
                     if {[isop $s $x]} {
                        set sendspam "!kick [zip "$x $c $notc 1LoNg TexT MSg FRoM 4$mhost [banms]"]"
                        putserv "PRIVMSG $s :$sendspam"
                        break
                     }
                  }
               }
            }
         }
      }
      return 1
   }
   if {$unick != $owner} {
      if {[info exists twice_msg($unick)]} {
         set hostmask "${unick}!*@*"
         puthelp "PRIVMSG $unick :SoRRY YoU HaVE BEEN IgNORED..! [lgrnd] $vern"
         putlog "!Log! IgNORE <<$hostmask>> PV-msg"
         unset twice_msg($unick)
         newignore $hostmask $unick "*" 2
      } {
         if {[istimer "chkautomsg"]} {
            set invme($mhost) "AuToJoIN MSg"
            return 0
         }
         if {[isutimer "NO REPLY"]} { 
            foreach x [utimers] {
               if {[string match "*NO REPLY*" $x]} { 
                  killutimer [lindex $x 2] 
               }
            }
            utimer 10 { putlog "NO REPLY" }
            return 0
         }
         utimer 10 { putlog "NO REPLY" }
         if {[string match "*libera*" $uhost]} {
            puthelp "PRIVMSG $unick :I am Away. Reason: (Auto Away on IdLe) [ 0day (xc) Our ] mIRC ScRIpT\]"
         } {
            if {[getuser "config" XTRA "AWAY"]!=""} { 
               puthelp "PRIVMSG $unick :I am Away. Reason: ([getuser "config" XTRA "AWAY"]) [lgrnd] $vern"
            } {
               puthelp "PRIVMSG $unick :I am Away. Reason: (Auto Away on IdLe) [lgrnd]"
            }
            set twice_msg($unick) 1
         }
      }
   }
}
proc auto_reop {} {
   global notc botnick basechan
   foreach x [channels] {
      if {[onchan $botnick $x]} { 
         if {![isop $botnick $x] && [string tolower $x] != $basechan} {
            if {![string match "*+protectfriends*" [channel info $x]]} {
               set cret 30
               foreach ct [utimers] {
                  if {[string match "*chancnt*" $ct]} {
                     if {[expr [lindex $ct 0] + 30] > $cret} {
                        set cret [expr [lindex $ct 0] + 30]
                     }
                  }
               }
               utimer $cret [list chancnt $x]
            }
         }
      }
   }
   return 0
}
proc chancnt {chan} {
   if {[isutimer "chancnt $chan"]} { return 0 }
   putserv "ChanServ count $chan"
}
proc msg_kick {nick uhost hand rest} {
   global notc botnick owner
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   set reason [lrange $rest 2 end]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: kick <#chan> <Nick> <Reason>"
      return 0
   }
   if {[isop $botnick $chantarget]!=1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
      return 0
   }
   if {$nicktarget == $botnick} {
      puthelp "NOTICE $nick :$notc I cant self kick."
      return 0
   }
   if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
      puthelp "NOTICE $nick :$notc I CaNT KIcK MY ADmIN."
      return 0
   }
   if {$reason == ""} {
      set reason "1ReQuesT..!"
      if {[matchattr $nick n]} { 
         set reason "1ADmIN 4KIcK1 ReQuesT4..!" 
      }
      if {[matchattr $nick m] && ![matchattr $nick n]} { 
         set reason "1MaSTER 4KIcK1 ReQuesT4..!" 
      }
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         putserv "KICK $x $nicktarget :$notc $reason"
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_kickban {nick uhost hand rest} {
   global notc botnick owner bannick
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   set bmask [getchanhost $nicktarget $chantarget]
   set bmask "*!*@[lindex [split $bmask @] 1]"
   set reason [lrange $rest 2 end]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: kickban <#chan> <Nick> <Reason>"
      return 0
   }
   if {[isop $botnick $chantarget]!=1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
      return 0
   }
   if {$nicktarget == $botnick} {
      puthelp "NOTICE $nick :$notc I cant self kick."
      return 0
   }
   if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
      puthelp "NOTICE $nick :$notc I cant kickban my ADmIN."
      return 0
   }
   if {$reason == ""} {
      set reason "1KIcKBaN ReQuesT4..!"
      if {[matchattr $nick m]} {
         set reason "1MaSTER 4KIcKBaN1 ReQuesT [banmsg]" 
      }
      if {[matchattr $nick n]} {
         set reason "1ADmIN 4KIcKBaN1 ReQuesT [banmsg]" 
      }
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         set bannick($nicktarget) $bmask
         putserv "KICK $x $nicktarget :$notc $reason"
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_op {nick uhost hand rest} {
   global notc botnick
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: op <#chan> <Nick>"
      return 0
   }
   if {[isop $botnick $chantarget]!=1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
      return 0
   }
   if {[isop $nicktarget $chantarget]!=0} {
      puthelp "NOTICE $nick :$notc $nicktarget is already op on CHaNNEL $chantarget"
      return 0
   }
   foreach x [channels] {
      if {[string tolower $x] == [string tolower $chantarget]} {
         opq $x $nicktarget
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_voice {nick uhost hand rest} {
   global notc botnick
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: voice <#chan> <Nick>"
      return 0
   }
   if {[isop $botnick $chantarget]!=1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
      return 0
   }
   if {[isvoice $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is already voice on channel $chantarget"
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         putserv "mode $x +v $nicktarget"
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_deop {nick uhost hand rest} {
   global notc botnick owner basechan
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: deop <#chan> <Nick>"
      return 0
   }
   if {[isop $botnick $chantarget] != 1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
      return 0
   }
   if {![isop $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $chantarget is not op on CHaNNEL $chantarget"
      return 0
   }
   if {$nicktarget == $botnick} {
      puthelp "NOTICE $nick :$notc I CaNT SeLF DEoP!"
      return 0
   }
   if {[matchattr $nicktarget n]} {
      puthelp "NOTICE $nick :$notc I cant deop my Owner."
      return 0
   }
   if {[matchattr $nick m]} {
      set mreq "MaSTER.ReQuesT"
   }
   if {[matchattr $nick n]} {
      set mreq "ADmIN.ReQuesT"
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         if {![string match "*k*" [getchanmode $x]]} {
            putserv "mode $x -ko $mreq $nicktarget"
         } {
            putserv "mode $x -o $nicktarget"
         }
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
proc msg_devoice {nick uhost hand rest} {
   global notc botnick owner
   set chantarget [lindex $rest 0]
   set nicktarget [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($chantarget == "") || ($nicktarget == "")} {
      puthelp "NOTICE $nick :$notc Usage: devoice <#chan> <Nick>"
      return 0
   }
   if {[isop $botnick $chantarget]!=1} {
      puthelp "NOTICE $nick :$notc NoT OP CHaNNEL $chantarget"
      return 0
   }
   if {![onchan $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not on the channel."
   }
   if {![isvoice $nicktarget $chantarget]} {
      puthelp "NOTICE $nick :$notc $nicktarget is not voice on CHaNNEL $chantarget"
   }
   if {$nicktarget == $owner} {
      puthelp "NOTICE $nick :$notc I cant devoice my owner."
      return 0
   }
   foreach x [channels] {
      if {[string tolower $x]==[string tolower $chantarget]} {
         putserv "mode $x -v $nicktarget"
         return 0
      }
   }
   puthelp "NOTICE $nick :$notc NoT IN $chantarget"
}
bind kick - * prot:kick
proc prot:kick {nick uhost handle chan knick reason} {
   global notc notd botnick basechan  kickme notb notm bannick igflood botname quick is_m op_it is_ban iskick
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[string match "* *" $reason] || [string match "*$notm*" $reason]} {
      set igflood($nick) "1"
   }
   if {[info exists iskick($nick$chan)]} {
      unset iskick($nick$chan)
   }
   if {$nick == $botnick} {
      if {[info exists kickme($knick)]} { 
         if {$kickme($knick) == 1} {
            set kickme($knick) 2
         }
         if {$kickme($knick) == 3} {
            catch { unset kickme($knick) }
         }
      }
      if {[string match "*$notm*" $reason]} {
         if {![info exists bannick($knick)]} { return 0 }
         if {[info exists is_ban($bannick($knick)$chan)]} { return 0 }
         set is_ban($bannick($knick)$chan) 1
         if {$bannick($knick) == "*!*@*"} { return 0 }
         set cmode [getchanmode $chan]
         set ok_m "1"
         if {[info exists is_m($chan)]} {
            set ok_m "0"
         }
         if {[isutimer "set_-m $chan"]} {
            set ok_m "0"
         }
         if {[string match "*m*" $cmode]} {
            set ok_m "0"
         }
         if {$ok_m == "1"} {
            set is_m($chan) 1
            if {$quick == "1"} {
               putquick "mode $chan +bm $bannick($knick)"
            } {
               putserv "mode $chan +bm $bannick($knick)"
            }
         } {
            if {$quick == "1"} {
               putquick "mode $chan +b $bannick($knick)"
            } {
               putserv "mode $chan +b $bannick($knick)"
            }
         }
         return 0
      } {
         if {![info exists bannick($knick)]} { return 0 }
         if {$bannick($knick) == "*!*@*"} { return 0 }
         putserv "mode $chan +b $bannick($knick)"
         if {[string match "*4BaNNEd1: 3 MINUTES*" $reason]} { utimer 180 [list unbanq $chan $bannick($knick)] }
      }
      return 0
   }
   if {$nick == $knick} { return 0 }
   if {$nick == "ChanServ"} { return 0 }
   if {[matchattr $nick f]} { return 0 }
   if {[string match "* *" $reason] || [string match "*$notm*" $reason]} { return 0 }
   if {$knick == $botnick} {
      if {[info exists kickme($nick)]} { 
         set kickme($nick) 3
         if {[string tolower $chan] != $basechan} {
            putserv "ChanServ deop $chan $nick"
         }
      } {
         if {[matchattr $cflag D]} {
            set kickme($nick) 1
         }
      }
      puthelp "JOIN $chan"
      return 0
   }
   if {![isop $botnick $chan]} { return 0 }
   if {$knick == $notb} {
      putserv "KICK $chan $nick :$notc 1DonT KIcK 4$notb1..!"
      set op_it($knick) 1
      return 0
   }
   if {[matchattr $knick n]} {
      putserv "KICK $chan $nick :$notc 1ADmIN 4KIcK1 PRoTecTIoN4..!"
      set op_it($knick) 1
      return 0
   }
   if {[matchattr $knick m]} {
      putserv "KICK $chan $nick :$notc 1MaSTeR 4KIcK1 PRoTecTIoN4..!"
      set op_it($knick) 1
      return 0
   }
}
proc unbanq {chan host} {
   if {[isop $botnick $chan]} {
      puthelp "mode $chan -b $host"
   }
}
proc lgrnd {} {
   set lgrnd "\[ 0day (xc) Our \]"
}
set bancounter {
   "4GeTLOsT1..!"
   "4GeTOuT1..!"
   "4BaNnEd1..!"
   "4LaMeR1..!"
   "4aBusEd1..!"
   "4OuT1..!"
   "4SuX1..!"
}
set bancounte {
   "1GeTLOsT4..!"
   "1GeTOuT4..!"
   "1BaNnEd4..!"
   "1LaMeR4..!"
   "1aBusEd4..!"
   "1OuT4..!"
   "1SuX4..!"
}
set banidx 1
proc banmsg {} {
   global banidx bancounter
   set banidx [incr banidx]
   if {$banidx >= [llength $bancounter]} { 
      set banidx 1
   }
   set banmsg [lindex $bancounter $banidx]
}
proc banms {} {
   global banidx bancounte
   set banidx [incr banidx]
   if {$banidx >= [llength $bancounte]} { 
      set banidx 1
   }
   set banms [lindex $bancounte $banidx]
}
proc ban_chk {nick uhost handle channel mchange bhost} {
   global botnick botname  quick notb notc bannick ban-time igflood invme ex_flood
   set mhost [string range $bhost [string first "@" $bhost] end]
   set cflag "c$channel"
   set cflag [string range $cflag 0 8]
   if {[info exists invme($mhost)]} {
      catch { unset invme($mhost) }
   }
   if {[info exists ex_flood($mhost)]} {
      catch { unset ex_flood($mhost) }
   }
   if {![isop $botnick $channel]} { return 0 }
   set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
   if {$banmask == "*!*@*"} {
      set banmask "$nick!*@*"
   }
   if {$bhost == "*!*@*"} {
      utimer [rand 4] [list unbanq $channel $bhost]
      return 1
   }
   set cmode [getchanmode $channel]
   if {[getuser "config" XTRA "IPG"] != ""} {
      foreach ipg [getuser "config" XTRA "IPG"] {
         if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
            if {![isutimer "IPG $bhost"]} {
               if {![string match "*k*" $cmode]} {
                  puthelp "mode $channel -kb IpgUaRd $bhost"
               } {
                  puthelp "mode $channel -b $bhost"
               }
               utimer 60 [list putlog "IPG $bhost"]
            }
            return 1
         }
      }
   }
   if {[string match [string tolower $bhost] [string tolower $botname]]} {
      if {![matchattr $nick f] && $nick != $botnick && $nick != "ChanServ" && ![string match "*libera*" $nick] && ![info exists igflood($nick)]} {
         if {[matchattr $cflag D]} {
            if {$quick == "1"} {
               putquick "KICK $channel $nick :$notc 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]"
            } {
               putserv "KICK $channel $nick :$notc 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]" 
            }
         }
         if {![string match "*k*" $cmode]} {
            if {$quick == "1"} {
               putquick "mode $channel -kb+b SeLF.UnBaN $bhost $banmask"
            } {
               putserv "mode $channel -kb+b SeLF.UnBaN $bhost $banmask"
            }
         } {
            if {$quick == "1"} {
               putquick "mode $channel -b+b $bhost $banmask"
            } {
               putserv "mode $channel -b+b $bhost $banmask"
            }
         }
      } { 
         if {![string match "*k*" $cmode]} {
            if {$quick == "1"} {
               putquick "mode $channel -kb SeLF.UnBaN $bhost"
            } else {
               putserv "mode $channel -kb SeLF.UnBaN $bhost"
            }
         } {
            if {$quick == "1"} {
               putquick "mode $channel -b $bhost"
            } else {
               putserv "mode $channel -b $bhost"
            }
         }
      }
      return 1
   }
   foreach knick [chanlist $channel] {
      if {[string match [string tolower $bhost] [string tolower $knick![getchanhost $knick $channel]]]} {
         if {[matchattr $knick f]} {
            if {$knick != $notb} { utimer [rand 4] [list unbanq $channel $bhost] }
            if {[matchattr $nick f] || $nick == $botnick || $nick == "ChanServ" || [string match "*dal.net*" $nick] || [info exists igflood($nick)]} { return 1 }
         }
         if {$knick == $notb} {
            if {$nick != $botnick} {
               putserv "KICK $channel $nick :$notc 1DonT BaNnEd 4$notb1..!"
               if {![string match "*k*" $cmode]} {
                  putserv "mode $channel -kb [ 0day (xc) Our ].GuaRd $bhost"
               } {
                  putserv "mode $channel -b $bhost"
               }
            } {
               putserv "mode $channel -b $bhost"
            }
            return 1
         }
         if {[matchattr $knick n]} {
            if {$nick != $botnick} {
               set bannick($nick) $banmask
               putserv "KICK $channel $nick :$notc 1DonT BaNnEd ADmIN 4$knick1..!"
            }
            return 1
         }
         if {[matchattr $knick m]} {
            if {$nick != $botnick} {
               putserv "KICK $channel $nick :$notc 1DonT BaNnEd MaSTER 4$knick1..!"
            }
            return 1
         }
         if {[matchattr $cflag E]} {
            if {$nick == $botnick} {
               set menforce [rand 3]
               if {$menforce == 1} {
                  putserv "KICK $channel $knick :$notc 1BaNnEd FRoM 4[string toupper $channel] [banms]"
               } elseif {$menforce == 2} {
                  putserv "KICK $channel $knick :$notc 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
               } else {
                  putserv "KICK $channel $knick :$notc 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
               }
            } else {
               if {[matchattr $nick n]} {
                  putserv "KICK $channel $knick :$notc 4ADmIN1 BaNnEd 4OuT1..!"
               } else {
                  if {[matchattr $nick m]} {
                     putserv "KICK $channel $knick :$notc 4MaSTER1 BaNnEd 4OuT1..!"
                  } else {
                     if {[isop $knick $channel] && ![matchattr $nick f]} { return 1 }
                     if {![matchattr $knick f]} {
                        set menforce [rand 4]
                        if {$menforce == 1} {
                           putserv "KICK $channel $knick :$notc 1BaNnEd BY 4@$nick [banms]"
                        } elseif {$menforce == 2} {
                           putserv "KICK $channel $knick :$notc 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
                        } elseif {$menforce == 3} {
                           putserv "KICK $channel $knick :$notc 1BaNnEd FRoM 4[string toupper $channel] [banms]"
                        } else {
                           putserv "KICK $channel $knick :$notc 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return 0
}
bind mode - * prot:deop
proc prot:deop {nick uhost handle channel mchange {opnick ""}} {
   global botnick deopme  invme virus_nick quick notb notc bannick lastkey unop igflood is_m op_it basechan
   set cflag "c$channel"
   set cflag [string range $cflag 0 8]
   set mode [lindex $mchange 0]
   if {$opnick == ""} {
      set opnick [lindex $mchange 1]
   }
   if {$mode == "-m"} {
      foreach x [utimers] {
         if {[string match "*set_-m $channel*" $x] || [string match "*TRAFFIC $channel*" $x]} {
            killutimer [lindex $x 2]
         }
      }
      catch {unset is_m($channel)}
      if {![botisop $channel]} { return 0 }
      if {[matchattr $cflag V]} {
         foreach x [chanlist $channel] {
            if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
               set cret [getuser $cflag XTRA "VC"]
               foreach ct [utimers] {
                  if {[string match "*voiceq*" $ct]} {
                     if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
                        set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
                     }
                  }
               }
               utimer $cret [list voiceq $channel $x]
            }
         }
      }
      return 0
   }
   if {$mode == "+k"} {
      set lastkey $opnick
      if {[matchattr $cflag K] && [matchattr $nick Z]} {
         putlog "key change to $opnick"
         setuser $cflag XTRA "CI" [zip $opnick]
         save
      }
   }
   if {$mode == "-k"} {
      catch { unset lastkey }
      if {$nick != $botnick} {
         set igflood($nick) "1"
      }
      return 0
   }
   if {$mode == "+m"} {
      foreach x [utimers] {
         if {[string match "*set_-m $channel*" $x] || [string match "*voiceq $channel*" $x]} {
            killutimer [lindex $x 2]
         }
      }
      if {$nick == $botnick} {
         if {![string match "*m*" [lindex [channel info $channel] 0]]} {
            if {[string match "*+shared*" [channel info $channel]]} {
               puthelp "NOTICE $channel :OnE MInUtE MoDeRaTe DuE tO FLood..!"
            }
            utimer 70 [list set_-m $channel]
            if {[isutimer "TRAFFIC $channel"]} {
               utimer 20 [list pub_nobot "*" "*" "*" $channel "*"]
               return 0
            }
         }
      } {
         if {[isutimer "goback"]} {
            catch { clearqueue all }
            foreach x [utimers] {
               if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] }
               if {[string match "*goback*" $x]} { killutimer [lindex $x 2] ; goback }
            }
            utimer 2 del_nobase
            return 0
         }
         utimer [expr 1800 + [rand 60]] [list set_-m $channel]
      }
      return 0
   }
   if {$mode == "+b"} {
      if {$opnick == "*!*@heavy.join.flood.channel.temporary.moderate"} {
         utimer 40 [list putlog "TRAFFIC $channel"]
         if {$nick == $botnick} {
            utimer 40 [list putserv "mode $channel -b *!*@heavy.join.flood.channel.temporary.moderate"]
            if {[info exists is_m($channel)]} { return 0 }
            if {$quick == "1"} {
               putquick "mode $channel +m"
            } {
               putserv "mode $channel +m"
            }
            set is_m($channel) 1
            return 0
         }
      }
      ban_chk $nick $uhost $handle $channel $mchange $opnick
      return 0
   }
   if {$mode == "-b"} {
      if {[info exists is_ban($opnick$channel)]} {
         catch {unset is_ban($opnick$channel)}
      }
      if {[isutimer "unbanq $channel $opnick"]} {
         foreach x [utimers] {
            if {[string match "*unbanq $channel $opnick*" $x]} {
               killutimer [lindex $x 2]
            }
         }
      }
      foreach x [ignorelist] {
         if {[lindex $x 0] == $opnick} {
            unsetignore [lindex $x 0]
            return 0
         }
      } 
      catch { killban $opnick }
      return 0
   }
   if {$nick == $opnick} { return 0 }
   if {$opnick == $botnick && $mode == "+o"} {
      chk_on_op $channel
      return 0
   }
   if {$mode == "+o" && [isop $botnick $channel]} {
      if {[info exists op_it($opnick)]} { 
         catch {unset op_it($opnick)}
      }
      if {[matchattr $opnick O]} {
         set cmode [getchanmode $channel]
         if {![string match "*k*" $cmode]} {
            puthelp "mode $channel -ko NoOp.LIST $opnick"
         } {
            puthelp "mode $channel -o $opnick"
         }
         return 0
      }
      if {[info exists unop($opnick)]} {
         if {$nick == "ChanServ"} {
            catch { unset unop($opnick) }
            return 0 
         }
         if {[matchattr $opnick f] || [matchattr $nick f] || $nick == $botnick} {
            return 0 
         }
         utimer [expr 5 + [rand 10]] [list unallowed $channel $nick $opnick]
         return 0
      }
   }
   if {$mode == "-o"} {
      foreach x [utimers] {
         if {[string match "*unallowed $channel $opnick*" $x]} { killutimer [lindex $x 2] }
      }
      if {$opnick == $botnick} {
         if {[isutimer "DEOP $channel"]} { return 0 }
         utimer 2 [list putlog "DEOP $channel"]
         if {![matchattr $nick f] && $nick != "ChanServ" && ![string match "*libera*" $nick] && ![string match "*Guest*" $botnick]} {
            if {![info exists igflood($nick)]} {
               if {[matchattr $cflag D]} {
                  set deopme $nick
               }
            }
         }
         if {![matchattr $nick m]} {
            if {[string tolower $channel] != $basechan} {
               if {![string match "*+protectfriends*" [channel info $channel]]} {
                  putlog "!Log! CHaNOP <<$channel>>"
                  putserv "ChanServ op $channel $botnick"
               }
            }
         }
         return 0
      }
      if {![isop $botnick $channel]} { return 0 }
      if {[isutimer "deopprc*$opnick"]} {
         foreach x [utimers] {
            if {[string match "*deopprc*$opnick*" $x]} {
               putlog "!UnDeOp OR UnKIcK!"
               catch { killutimer [lindex $x 2] }
            }
         }
      }
      if {$nick == "ChanServ" && [matchattr $opnick o]} {
         voiceq $channel $opnick
         return 0
      }
      if {$nick == "ChanServ"} {
         set unop($opnick) "1"
         return 0 
      }
      if {[matchattr $nick f] || $nick == $botnick} { return 0 }
      if {$nick == "ChanServ"} { return 0 }
      if {[matchattr $opnick n]} {
         if {![info exists igflood($nick)]} {
            putserv "KICK $channel $nick :$notc 1ADmIN 4De@p1 GuaRd4..!"
            opq $channel $opnick
         }
         return 0
      }
      if {[matchattr $opnick m]} {
         if {![info exists igflood($nick)]} {
            putserv "KICK $channel $nick :$notc 1MaSTeR 4De@p1 GuaRd1..!"
            opq $channel $opnick
         }
         return 0
      }
      if {[matchattr $opnick o]} {
         opq $channel $opnick
         return 0
      }
      if {$opnick == $notb} {
         if {![info exists igflood($nick)]} {
            putserv "KICK $channel $nick :$notc 1DonT De@p 4$notb1..!"
         }
         opq $channel $opnick
         return 0
      }
   }
}
proc unallowed {chan nick opnick} {
   if {![botisop $chan]} { return 0 }
   if {![isop $nick $chan]} { return 0 }
   if {[isop $opnick $chan]} { return 0 }
   putserv "mode $chan -ko ChanServ.UnaLLowEd $nick"
}
bind nick - * chk_nicks
proc chk_nicks {unick uhost hand chan newnick} {
   global notc bannick botnick nick
   if {$unick == $nick && $unick != $botnick} {
      putserv "NICK $nick"
   }
   if {[matchattr $unick Q]} {
      chattr $unick -Q
      
save      
   }
   if {![isop $botnick $chan]} { return 0 }
   if {[isutimer "deopprc*$unick"]} {
      foreach x [utimers] {
         if {[string match "*deopprc*$unick*" $x]} {
            putlog "!UnDeOp!"
            catch { killutimer [lindex $x 2] }
         }
      }
   }
   if {[string match "Guest*" $newnick]} { 
      if {[matchattr $unick f]} { return 0 }
      if {[isop $newnick $chan]} { 
         utimer [expr 80 + [rand 20]] [list deopprc $chan $newnick] 
         return 0
      }
   }
   if {[matchattr $newnick O] && [isop $newnick $chan]} { 
      set cmode [getchanmode $chan]
      if {![string match "*k*" $cmode]} {
         putserv "mode $chan -ko NoOp.LIsT $newnick"
      } {
         putserv "mode $chan -o $newnick" 
      }
   }
   akick_chk $newnick $uhost $chan
   spam_chk $newnick $uhost $hand $chan
   return 0
}
proc msg_identify {nick uhost hand rest} {
   global notc 
   set id [lindex $rest 0]
   set password [lindex $rest 1]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {($id == "") || ($password == "")} {
      puthelp "NOTICE $nick :$notc Usage: identify <nick> <password>"
      return 0
   }
   putserv "NickServ identify $id $password"
   puthelp "NOTICE $nick :$notc Identify to $id"
   return 0
}
proc pub_realnick {unick uhost hand chan rest} {
   global notc keep-nick nick
   if {![matchattr $unick Q]} {
      puthelp "NOTICE $unick :$notc 4DeNIEd..!"
      return 0
   }
   set keep-nick 1
   putserv "NICK $nick"
   return 0
}
proc rands {length} {
   set chars \\^|_[]{}\\
   set count [string length $chars]
   for {set i 0} {$i < $length} {incr i} {
      append result [string index $chars [rand $count]]
   }
   return $result
}
proc pub_randnick {unick uhost hand chan rest} {
   global notc keep-nick nick altnick botnick
   if {$rest != ""} {
      set keep-nick 0
      set nickch "[lindex $rest 0]\[[rand 9][rand 9][randstring 1]\]"
      putserv "NICK $nickch"
   } {
      if {$botnick != $nick && $botnick != $altnick} { return 0 }
      set keep-nick 0
      putserv "NICK [rands 8]"
   }
   return 0
}
proc pub_altnick {nick uhost hand chan rest} {
   global altnick keep-nick notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set keep-nick 0
   putserv "NICK $altnick"
}
bind raw - 305 not_away
proc not_away { from keyword arg } {
   if {[isutimer "del_nobase"]} { utimer 1 del_nobase }
   if {[isutimer "goback"]} { utimer 2 goback }
   unsetignore "*!*@*"
}
bind raw - 404 ch_moderate
bind raw - 473 ch_invite
bind raw - 474 ch_banned
bind raw - 475 ch_key
bind raw - 478 ch_full
bind raw - 432 nickERROR
proc nickERROR { from keyword arg } {
   global nick
   set nick "ERR[unixtime]"
}
proc ch_moderate { from keyword arg } {
   putlog "CANT SEND ON MODERATE!"
   if {[isutimer "del_nobase"]} {
      catch { clearqueue all }
      foreach x [utimers] {
         if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] ; utimer 1 del_nobase }
      }
   }
}
proc ch_invite { from keyword arg } {
   global double owner notc 
   set chan [lindex $arg 1]
   if {$double == 0} {
      if {$owner != ""} {
         puthelp "NOTICE $owner :$notc $chan 4(+I)"
      }
      putserv "ChanServ invite $chan"
      set double 1
      return 0
   }
   if {$double == 1} {
      if {[string match "*+statuslog*" [channel info $chan]]} {
         if {$owner != ""} {
            puthelp "NOTICE $owner :$notc ReMOVE $chan 4(+I)"
         }
         channel remove $chan
         savechan
      }
      set double 0
   }
   return  0
}
proc ch_banned { from keyword arg } {
   global double owner notc
   set chan [lindex $arg 1]
   if {$double == 0} {
      if {$owner != ""} {
         puthelp "NOTICE $owner :$notc $chan 4(+B)"
      }
         putserv "ChanServ invite $chan"
         puthelp "ChanServ unban $chan"
     
      set double 1
      return 0
   }
   if {$double == 1} {
      if {[string match "*+statuslog*" [channel info $chan]]} {
         if {$owner != ""} {
            puthelp "NOTICE $owner :$notc ReMovE $chan 4(+B)"
         }
         putserv "ChanServ invite $chan"
         channel remove $chan
         savechan
      }
      
      set double 0
   }
   return 0
}
proc ch_key { from keyword arg } {
   global double owner notc lastkey
   set chan [lindex $arg 1]
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$double == 0} {
      if {$owner != ""} {
         puthelp "NOTICE $owner :$notc $chan 4(+K)"
      }
      if {[matchattr $cflag K]} {
         puthelp "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
      } {
         puthelp "JOIN $chan"
      }
      if {[info exists lastkey]} {
         puthelp "JOIN $chan :$lastkey"
      }
      set double 1
      return 0
   }
   if {$double == 1} {
      if {[string match "*+statuslog*" [channel info $chan]]} {
         if {$owner != ""} {
            puthelp "NOTICE $owner :$notc ReMovE $chan 4(+K)"
         }
         channel remove $chan
         savechan
         return 0
      }
      putserv "ChanServ invite $chan"
      set double 0
   }
   return 0
}
proc ch_full { from keyword arg } {
   global double owner notc botnick
   set chan [lindex $arg 1]
   if {[isop $botnick $chan]} {
      set bans ""
      set i 0
      foreach x [chanbans $chan] {
         if {$i < 5} {
            append bans " [lindex $x 0]"
            set i [incr i]
         }
      }
      putserv "MODE $chan -kbbbbb BaN.LIsT.FuLL $bans"
      return 0
   }
   if {$double == 0} {
      if {$owner != ""} {
         puthelp "NOTICE $owner :$notc $chan 4(+L)"
      }
      putserv "ChanServ invite $chan"
      
      set double 1
      return 0
   }
   if {$double == 1} {
      if {[string match "*+statuslog*" [channel info $chan]]} {
         if {$owner != ""} {
            puthelp "NOTICE $owner :$notc ReMOVE $chan 4(+L)"
         }
         channel remove $chan
         savechan
      }
      
      set double 0
   }
   return 0
}
if {$altnick == ""} { 
   set altnick [randstring 7] 
}
set badwords ""
proc config {} {
   global nick nickpass altpass altnick realname owner kops my-ip banner cycle_random
   global notc logstore cfgfile badwords ban-time my-hostname
   if {[validuser "config"]} {
      if {[getuser "config" XTRA "REALNAME"]!=""} {
         set realname [dezip [getuser "config" XTRA "REALNAME"]]
      } else {
         set realname [lgrnd]
      }
      if {[getuser "config" XTRA "NICK"]!=""} {
         set nick [dezip [getuser "config" XTRA "NICK"]]
      }
      if {[getuser "config" XTRA "NICKPASS"]!=""} {
         set nickpass [dezip [getuser "config" XTRA "NICKPASS"]]
      }
      if {[getuser "config" XTRA "ALTNICK"]!=""} {
         set altnick [dezip [getuser "config" XTRA "ALTNICK"]]
      }
      if {[getuser "config" XTRA "ALTPASS"]!=""} {
         set altpass [dezip [getuser "config" XTRA "ALTPASS"]]
      }
      if {[getuser "config" XTRA "BAN"]!=""} {
         set banner [dezip [getuser "config" XTRA "BAN"]]
         lappend cycle_random $banner
      }
      if {[getuser "config" XTRA "BANTIME"]!=""} {
         set ban-time [getuser "config" XTRA "BANTIME"]
      }
      if {[getuser "config" XTRA "BADWORDS"]!=""} {
         set badwords [getuser "config" XTRA "BADWORDS"]
      }
      if {$badwords == ""} {
         set badwords "cibai bitch kimak memek kontol kanjut bangsat ngentot fuck peler lanciau bajingan vagina ngewe shit asshole anjing babi kampang"
         setuser "config" XTRA "BADWORDS" $badwords
      }
      if {[getuser "config" XTRA "KOPS"]!=""} {
         set kops "T"
      }
      if {[getuser "config" XTRA "VHOST"]!=""} {
         set my-hostname [getuser "config" XTRA "VHOST"]
         set my-ip [getuser "config" XTRA "VHOST"]
      }
      if {[getuser "config" XTRA "LOGCHAN"]!=""} { 
         putlog "!Log! CReATING LOG FiLE <<[getuser "config" XTRA "LOGCHAN"]>>"
         set logstore "${cfgfile}.log"
         logfile jpk [getuser "config" XTRA "LOGCHAN"] $logstore 
      }
   } else {
      adduser "config" ""
      chattr "config" "-hp"
   }
   foreach x [userlist] {
      chattr $x -Q
      }
   if {![validuser "AKICK"]} {
      set hostmask "telnet!*@*"
      adduser "AKICK" $hostmask
      chattr "AKICK" "-hp"
      chattr "AKICK" "K"
   }
   if {![validuser $owner]} {
      set hostmask "$owner!*@*"
      adduser $owner $hostmask
      chattr $owner "Zfhjmnoptx"
   }
   save   
}
utimer 1 {config}
utimer 2 {seen}
proc uncolor {s} {
   regsub -all --  $s "" s
   regsub -all --  $s "" s
   regsub -all --  $s "" s
   regsub -all -- \[0-9\]\[0-9\],\[0-9\]\[0-9\] $s "" s
   regsub -all -- \[0-9\],\[0-9\]\[0-9\] $s "" s
   regsub -all -- \[0-9\]\[0-9\],\[0-9\] $s "" s
   regsub -all -- \[0-9\],\[0-9\] $s "" s
   regsub -all -- \[0-9\]\[0-9\] $s "" s
   regsub -all -- \[0-9\] $s "" s
   return $s
}
proc msg_botset {unick uhost hand rest} {
   global nick nickpass altpass altnick owner notc 
   if {$unick != $owner} {
      return 0
   }
   puthelp "NOTICE $unick :$notc 1st $nick ($nickpass) 2nd $altnick ($altpass)"
   return 0
}
proc msg_reuser {nick uhost hand rest} {
   global botnick owner notc 
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {$nick != $owner} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   foreach x [userlist] {
      if {($x != "config") && ($x != "AKICK")} { deluser $x }
   }
   adduser $owner "$owner!*@*"
   chattr $owner "Zfhjmnoptx"
   puthelp "NOTICE $nick :$notc Reseting UsER sucessfully, set pass 1st."
save   
}
set bs(limit) 8000
set bs(nicksize) 32
set bs(no_pub) ""
set bs(no_log) ""
set bs(log_only) ""
set bs(flood) 4:15
set bs(ignore) 1
set bs(ignore_time) 2
set bs(smartsearch) 1
set bs(logqueries) 1
set bs(path) "language/"
set bs(updater) 10402
set bs(oldver) $bs(updater)
set bs(version) bseen1.4.2c
proc seen {} {
   global version notc notd
   catch { unbind time - "12 * * * *" bs_timedsave }
   catch { unbind time -  "*1 * * * *" bs_trim }
   catch { unbind join -|- * bs_join_botidle }
   catch { unbind join -|- * bs_join }
   catch { unbind sign -|- * bs_sign }
   catch { unbind kick -|- * bs_kick }
   catch { unbind nick -|- * bs_nick }
   catch { unbind splt -|- * bs_splt }
   catch { unbind rejn -|- * bs_rejn }
   catch { unbind chjn -|- * bs_chjn }
   catch { unbind chpt -|- * bs_chpt }
   catch { unbind bot -|- bs_botsearch bs_botsearch }
   catch { unbind bot -|- bs_botsearch_reply bs_botsearch_reply }
   catch { unbind pub -|- [string trim "!"]seen pub_seen }
   catch { unbind pub -|- [string trim "!"]seennick bs_pubreq2 }
   catch { unbind pub - !ping public_ping }
   catch { unbind part -|- * bs_part_oldver }
   catch { unbind chof -|- * bs_chof }
   set mSEEN "F"
   foreach x [channels] {
      set cinfo [channel info $x]
      if {[string match "*+seen*" $cinfo]} {
         set mSEEN "T"
      }
   }
   if {$mSEEN == "F"} {return 0}
   bind time - "12 * * * *" bs_timedsave
   bind time -  "*1 * * * *" bs_trim
   bind join -|- * bs_join_botidle
   bind join -|- * bs_join
   bind sign -|- * bs_sign
   bind kick -|- * bs_kick
   bind nick -|- * bs_nick
   bind splt -|- * bs_splt
   bind rejn -|- * bs_rejn
   bind chjn -|- * bs_chjn
   bind chpt -|- * bs_chpt
   bind bot -|- bs_botsearch bs_botsearch
   bind bot -|- bs_botsearch_reply bs_botsearch_reply
   bind pub -|- !seen pub_seen
   bind pub -|- !seennick bs_pubreq2
   bind pub - !ping public_ping
   if {[lsearch -exact [bind time -|- "*2 * * * *"] bs_timedsave] > -1} {unbind time -|- "*2 * * * *" bs_timedsave}
   if {[string trimleft [lindex $version 1] 0] >= 1050000} {
      bind part -|- * bs_part  
   } {
      if {[lsearch -exact [bind part -|- *] bs_part] > -1} {unbind part -|- * bs_part}
      bind part -|- * bs_part_oldver
   }
   foreach chan [string tolower [channels]] {if {![info exists bs_botidle($chan)]} {set bs_botidle($chan) [unixtime]}}
   if {[lsearch -exact [bind chof -|- *] bs_chof] > -1} {unbind chof -|- * bs_chof}
   if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}
   if {[info exists bs_list]} {
      if {[info exists bs(oldver)]} {
         if {$bs(oldver) < $bs(updater)} {bs_update}
      } {bs_update}
   }
}
utimer 2 seen
proc bs_filt {data} {
   regsub -all -- \\\\ $data \\\\\\\\ data 
   regsub -all -- \\\[ $data \\\\\[ data 
   regsub -all -- \\\] $data \\\\\] data
   regsub -all -- \\\} $data \\\\\} data 
   regsub -all -- \\\{ $data \\\\\{ data 
   regsub -all -- \\\" $data \\\\\" data 
   return $data
}
proc bs_flood_init {} {
   global bs bs_flood_array 
   if {![string match *:* $bs(flood)]} {return}
   set bs(flood_num) [lindex [split $bs(flood) :] 0]
   set bs(flood_time) [lindex [split $bs(flood) :] 1]
   set i [expr $bs(flood_num) - 1]
   while {$i >= 0} {
      set bs_flood_array($i) 0 
      incr i -1  
   }
} 
bs_flood_init
proc bs_flood {nick uhost} {
   global bs bs_flood_array 
   if {$bs(flood_num) == 0} {return 0} 
   set i [expr $bs(flood_num) - 1]
   while {$i >= 1} {
      set bs_flood_array($i) $bs_flood_array([expr $i - 1]) 
      incr i -1
   } 
   set bs_flood_array(0) [unixtime]
   if {[expr [unixtime] - $bs_flood_array([expr $bs(flood_num) - 1])] <= $bs(flood_time)} {
      if {$bs(ignore)} {newignore [join [maskhost *!*[string trimleft $uhost ~]]] $bs(version) "*" $bs(ignore_time)} 
      return 1
   } {return 0}
}
proc bs_read {} {
   global bs_list userfile bs
   if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
      set temp [split $userfile /] 
      set temp [lindex $temp [expr [llength $temp]-1]] 
      set name [lindex [split $temp .] 0]
   }
   if {![file exists $bs(path)bs_data.$name]} {
      if {![file exists $bs(path)bs_data.$name.bak]} {
         return
      } {exec cp $bs(path)bs_data.$name.bak $bs(path)bs_data.$name}
   }
   set fd [open $bs(path)bs_data.$name r]
   set bsu_ver "" 
   set break 0
   while {![eof $fd]} {
      set inp [gets $fd] 
      if {[eof $fd]} {break} 
      if {[string trim $inp " "] == ""} {continue}
      if {[string index $inp 0] == "#"} {
         set bsu_version [string trimleft $inp #] 
         continue
      }
      if {![info exists bsu_version] || $bsu_version == "" || $bsu_version < $bs(updater)} {
         if {[source scripts/bseen_updater1.4.2.tcl] != "ok"} {set temp 1} {set temp 0}
         if {$temp || [bsu_go] || [bsu_finish]} {
            rehashing
         }
         set break 1 
         break
      }
      set nick [lindex $inp 0] 
      set bs_list([string tolower $nick]) $inp
   }
   close $fd
   if {$break} {bs_read}
}
proc bs_update {} {
   global bs
   bs_save 
   bs_read
}
proc bs_timedsave {min b c d e} {bs_save}
proc bs_save {} {
   global bs_list userfile bs notc
   if {[array size bs_list] == 0} {return}
   if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
      set temp [split $userfile /] 
      set temp [lindex $temp [expr [llength $temp]-1]] 
      set name [lindex [split $temp .] 0]
   }
   if {[file exists $bs(path)bs_data.$name]} {catch {exec cp -f $bs(path)bs_data.$name $bs(path)bs_data.$name.bak}}
   set fd [open $bs(path)bs_data.$name w] 
   set id [array startsearch bs_list] 
   puts $fd "#$bs(updater)"
   while {[array anymore bs_list $id]} {
      set item [array nextelement bs_list $id] 
      puts $fd "$bs_list($item)"
   } 
   array donesearch bs_list $id
   close $fd
}
proc bs_part_oldver {a b c d} {bs_part $a $b $c $d ""}
proc bs_part {nick uhost hand chan reason} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   bs_add $nick "[list $uhost] [unixtime] part $chan [split $reason]"
}
proc bs_join {nick uhost hand chan} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   bs_add $nick "[list $uhost] [unixtime] join $chan"
}
proc bs_sign {nick uhost hand chan reason} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   bs_add $nick "[list $uhost] [unixtime] quit $chan [split $reason]"
}
proc bs_kick {nick uhost hand chan knick reason} {
   global basechan
   set schan $chan
   if {[string tolower $chan] == $basechan} { 
      set schan "-secret-"
   }
   bs_add $knick "[getchanhost $knick $chan] [unixtime] kick $schan [list $nick] [list $reason]"
}
proc bs_nick {nick uhost hand chan newnick} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   set time [unixtime] 
   bs_add $nick "[list $uhost] [expr $time -1] nick $chan [list $newnick]" 
   bs_add $newnick "[list $uhost] $time rnck $chan [list $nick]"
}
proc bs_splt {nick uhost hand chan} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   bs_add $nick "[list $uhost] [unixtime] splt $chan"
}
proc bs_rejn {nick uhost hand chan} {
   global basechan
   if {[string tolower $chan] == $basechan} { 
      set chan "-secret-"
   }
   bs_add $nick "[list $uhost] [unixtime] rejn $chan"
}
proc bs_chjn {bot hand channum flag sock from} {bs_add $hand "[string trimleft $from ~] [unixtime] chjn $bot"}
proc bs_chpt {bot hand args} {set old [split [bs_search ? [string tolower $hand]]] ; if {$old != "0"} {bs_add $hand "[join [string trim [lindex $old 1] ()]] [unixtime] chpt $bot"}}
proc bs_botsearch {from cmd args} {
   global botnick notc
   set args [join $args]
   set command [lindex $args 0] 
   set target [lindex $args 1] 
   set nick [lindex $args 2] 
   set search [bs_filt [join [lrange $args 3 e]]]
   if {[string match *\\\** $search]} {
      set output [bs_seenmask bot $nick $search]
      if {$output != "No matches were found." && ![string match "I'm not on *" $output]} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
   } {
      set output [bs_output bot $nick [bs_filt [lindex $search 0]] 0]
      if {$output != 0 && [lrange [split $output] 1 4] != "unseeing"} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
   }
}
proc bs_botsearch_reply {from cmd args} {
   global notc bs
   set args [join $args]
   if {[lindex [lindex $args 2] 5] == "not" || [lindex [lindex $args 2] 4] == "not"} {return}
   if {![info exists bs(bot_delay)]} {
      set bs(bot_delay) on 
      utimer 10 {if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}} 
      if {![lindex $args 0]} {putdcc [lindex $args 1] "[join [lindex $args 2]]"} {
         puthelp "[lindex $args 1] :[join [lindex $args 2]]"
      }
   }
}
proc pub_seen {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 0}
proc bs_pubreq2 {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 1}
proc bs_pubreq {nick uhost hand chan args no} {
   global botnick bs notc
   if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
   if {[bs_flood $nick $uhost]} {return 0}
   set i 0 
   if {[lsearch -exact $bs(no_pub) [string tolower $chan]] >= 0} {return 0}
   if {$bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower $chan]] == -1} {return 0}
   set args [bs_filt [join $args]]
   set target "NOTICE $nick"
   if {[string match *\\\** [lindex $args 0]]} {
      set output [bs_seenmask $chan $hand $args]
      if {$output == "No Matches!"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
      if {[string match "I'm not on *" $output]} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
      regsub -all -- ~ $output "" output
      puthelp "$target :[lgrnd] $output"
      return $bs(logqueries)
   }
   set data [bs_filt [string trimright [lindex $args 0] ?!.,]]
   if {[string tolower $nick] == [string tolower $data]} {
      puthelp "$target :[lgrnd] $nick, go look in a mirror..!" 
      return $bs(logqueries)
   }
   if {[string tolower $data] == [string tolower $botnick] } {
      puthelp "$target :\001ACTION Right Here!\001" 
      return $bs(logqueries)
   }
   if {[onchan $data $chan]} {
      puthelp "$target :[lgrnd] $nick, $data is right here..!" 
      return $bs(logqueries)
   }
   set output [bs_output $chan $nick $data $no] 
   if {$output == 0} {return 0}
   if {[lrange [split $output] 1 4] == "I don't remember seeing"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
   regsub -all -- ~ $output "" output
   puthelp "$target :[lgrnd] $output"
   return $bs(logqueries)
}
proc bs_output {chan nick data no} {
   global botnick bs version bs_list
   set data [string tolower [string trimright [lindex $data 0] ?!.,]]
   if {$data == ""} {return 0}
   if {[string tolower $nick] == $data} {return [concat $nick, go look in a mirror.]}
   if {$data == [string tolower $botnick]} {return [concat $nick, I'm right here. Quit wasting my time!]}
   if {[string length $data] > $bs(nicksize)} {return 0} 
   if {$bs(smartsearch) != 1} {set no 1}
   if {$no == 0} {
      set matches ""
      set hand ""
      set addy ""
      if {[lsearch -exact [array names bs_list] $data] != "-1"} { 
         set addy [lindex $bs_list([string tolower $data]) 1] 
         set hand [finduser $addy]
         foreach item [bs_seenmask dcc ? [maskhost $addy]] {if {[lsearch -exact $matches $item] == -1} {set matches "$matches $item"}}
      }
      if {[validuser $data]} {set hand $data}
      if {$hand != "*" && $hand != ""} {
         if {[string trimleft [lindex $version 1] 0]>1030000} {set hosts [getuser $hand hosts]} {set hosts [gethosts $hand]}
         foreach addr $hosts {
            foreach item [string tolower [bs_seenmask dcc ? $addr]] {
               if {[lsearch -exact [string tolower $matches] [string tolower $item]] == -1} {set matches [concat $matches $item]}
            }
         }
      }
      if {$matches != ""} {
         set matches [string trimleft $matches " "]
         set len [llength $matches]
         if {$len == 1} {return [bs_search $chan [lindex $matches 0]]}
         if {$len > 99} {return [concat I found $len matches to your query\; please refine it to see any output.]}
         set matches [bs_sort $matches]
         set key [lindex $matches 0]
         if {[string tolower $key] == [string tolower $data]} {return [bs_search $chan $key]}
         if {$len <= 5} {
            set output [concat sorted most $len matches recent: [join $matches].]
            set output [concat $output  [bs_search $chan $key]] 
            return $output
         } {
            set output [concat found $len matches matches. most 5 recent (sorted): [join [lrange $matches 0 4]].]
            set output [concat $output [bs_search $chan $key]] 
            return $output
         }
      }
   }
   set temp [bs_search $chan $data]
   if {$temp != 0} { return $temp } {
      #$data not found in $bs_list, so search userfile
      if {![validuser [bs_filt $data]] || [string trimleft [lindex $version 1] 0]<1030000} { 
         return "$nick, unseeing $data."
      } {
         set seen [getuser $data laston]
         if {[getuser $data laston] == ""} {return "$nick, unseeing $data."}
         if {($chan != [lindex $seen 1] || $chan == "bot" || $chan == "msg" || $chan == "dcc") && [validchan [lindex $seen 1]] && [lindex [channel info [lindex $seen 1]] 23] == "+secret"} {
            set chan "-secret-"
         } {
            set chan [lindex $seen 1]
         }
         return [concat $nick, $data was last seen on $chan [bs_when [lindex $seen 0]] ago.]
      }
   }
}
proc bs_search {chan n} {
   global bs_list notc 
   if {![info exists bs_list]} {return 0}
   if {[lsearch -exact [array names bs_list] [string tolower $n]] != "-1"} { 
      set data [split $bs_list([string tolower $n])]
      set n [join [lindex $data 0]] 
      set addy [lindex $data 1] 
      set time [lindex $data 2] 
      set marker 0
      if {([string tolower $chan] != [string tolower [lindex $data 4]] || $chan == "dcc" || $chan == "msg" || $chan == "bot") && [validchan [lindex $data 4]] && [lindex [channel info [lindex $data 4]] 23] == "+secret"} {
         set chan "-secret-"
      } {
         set chan [lindex $data 4]
      }
      switch -- [lindex $data 3] {
         part { 
            set reason [lrange $data 5 e]
            if {$reason == "{}"} {set reason "."} {set reason " stating \"$reason\"."}
            set output [concat $n ($addy) parting $chan [bs_when $time] ago$reason] 
         }
         quit { 
            set reason [lrange $data 5 e]
            if {$reason == "Quit: {{}}"} {set reason "."} {set reason " stating $reason."}
            set output [concat $n ($addy) quitting $chan [bs_when $time] ago stating$reason] 
         }
         kick {
            set output [concat $n ($addy) kicked from $chan by [lindex $data 5] [bs_when $time] ago with the reason ([join [lrange $data 6 e]]).] 
         }
         rnck {
            set output [concat $n ($addy) changing nicks from [lindex $data 5] on [lindex $data 4] [bs_when $time] ago.] 
            if {[validchan [lindex $data 4]]} {
               if {[onchan $n [lindex $data 4]]} {
                  set output [concat $output $n is still there.]
               } {
                  set output [concat $output  unseeing $n now.]
               }
            }
         }
         nick { 
            set output [concat $n ($addy) changing nicks to [lindex $data 5] on [lindex $data 4] [bs_when $time] ago.]
         }
         splt { 
            set output [concat $n ($addy) parting $chan due to a split [bs_when $time] ago.] 
         }
         rejn { 
            set output [concat $n ($addy) rejoining $chan from a split [bs_when $time] ago.]
            if {[validchan $chan]} {
               if {[onchan $n $chan]} {
                  set output [concat $output  $n is still on $chan.]
               } {
                  set output [concat $output  I don't see $n on $chan now, though.]
               }
            }
         }
         join { 
            set output [concat $n ($addy) joining $chan [bs_when $time] ago.]
            if {[validchan $chan]} {
               if {[onchan $n $chan]} {
                  set output [concat $output  $n is still on $chan.]
               } {
                  set output [concat $output  unseeing $n on $chan now.]
               }
            }
         }
         away {
            set reason [lrange $data 5 e]
            if {$reason == ""} {
               set output [concat $n ($addy) returning to the partyline on $chan [bs_when $time] ago.]
            } {
               set output [concat $n ($addy) seen being marked as away ($reason) on $chan [bs_when $time] ago.]
            }
         }
         chon { 
            set output [concat $n ($addy) joining the partyline [bs_when $time] ago.] 
            set lnick [string tolower $n]
            foreach item [whom *] {
               if {$lnick == [string tolower [lindex $item 0]]} {
                  set output [concat $output $n is on the partyline right now.] 
                  set marker 1
                  break
               }
            }
            if {$marker == 0} {
               set output [concat $output  I don't see $n on the partyline now, though.]
            }
         }
         chof { 
            set output [concat $n ($addy) leaving the partyline [bs_when $time] ago.] 
            set lnick [string tolower $n]
            foreach item [whom *] {
               if {$lnick == [string tolower [lindex $item 0]]} {
                  set output [concat $output $n is on the partyline in [lindex $item 1] still.] 
                  break
               }
            }
         }
         chjn { 
            set output [concat $n ($addy) joining the partyline on $chan [bs_when $time] ago.] 
            set lnick [string tolower $n]
            foreach item [whom *] {
               if {$lnick == [string tolower [lindex $item 0]]} {
                  set output [concat $output  $n is on the partyline right now.] 
                  set marker 1
                  break
               }
            }
            if {$marker == 0} {
               set output [concat $output  I don't see $n on the partyline now, though.]
            }
         }
         chpt { 
            set output [concat $n ($addy) leaving the partyline from $chan [bs_when $time] ago.] 
            set lnick [string tolower $n]
            foreach item [whom *] {
               if {$lnick == [string tolower [lindex $item 0]]} {
                  set output [concat $output  $n is on the partyline in [lindex $item 1] still.] 
                  break
               }
            }
         }
         default {set output "error"}
      }
      return $output
   } {return 0}
}
proc bs_when {lasttime} {
   set years 0 
   set days 0 
   set hours 0 
   set mins 0 
   set time [expr [unixtime] - $lasttime]
   if {$time < 60} {return "only $time seconds"}
   if {$time >= 31536000} {
      set years [expr int([expr $time/31536000])]
      set time [expr $time - [expr 31536000*$years]]
   }
   if {$time >= 86400} {
      set days [expr int([expr $time/86400])]
      set time [expr $time - [expr 86400*$days]]
   }
   if {$time >= 3600} {
      set hours [expr int([expr $time/3600])]
      set time [expr $time - [expr 3600*$hours]]
   }
   if {$time >= 60} {
      set mins [expr int([expr $time/60])]
   }
   if {$years == 0} {
      set output ""
   } elseif {$years == 1} {
      set output "1 year,"
   } {
      set output "$years years,"
   }
   if {$days == 1} {lappend output "1 day,"} elseif {$days > 1} {lappend output "$days days,"}
   if {$hours == 1} {lappend output "1 hour,"} elseif {$hours > 1} {lappend output "$hours hours,"}
   if {$mins == 1} {lappend output "1 minute"} elseif {$mins > 1} {lappend output "$mins minutes"}
   return [string trimright [join $output] ", "]
}
proc bs_add {nick data} {
   global bs_list bs
   if {[lsearch -exact $bs(no_log) [string tolower [lindex $data 3]]] >= 0 || ($bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower [lindex $data 3]]] == -1)} {return}
   set bs_list([string tolower $nick]) "[bs_filt $nick] $data"
}
proc bs_lsortcmd {a b} {global bs_list ; set a [lindex $bs_list([string tolower $a]) 2] ; set b [lindex $bs_list([string tolower $b]) 2] ; if {$a > $b} {return 1} elseif {$a < $b} {return -1} {return 0}}
proc bs_trim {min h d m y} {
   global bs bs_list
   if {![info exists bs_list] || ![array exists bs_list]} {return} 
   set list [array names bs_list] 
   set range [expr [llength $list] - $bs(limit) - 1] 
   if {$range < 0} {return}
   set list [lsort -increasing -command bs_lsortcmd $list] 
   foreach item [lrange $list 0 $range] {unset bs_list($item)}
}
proc bs_seenmask {ch nick args} {
   global bs_list bs notc
   set matches "" 
   set temp "" 
   set i 0 
   set args [join $args] 
   set chan [lindex $args 1]
   if {$chan != "" && [string trimleft $chan #] != $chan} {
      if {![validchan $chan]} {return "I'm not on $chan."} {set chan [string tolower $chan]}
   } { 
      set chan "" 
   }
   if {![info exists bs_list]} {return "No matches were found."} 
   set data [bs_filt [string tolower [lindex $args 0]]]
   set maskfix 1
   while $maskfix {
      set mark 1
      if [regsub -all -- \\?\\? $data ? data] {set mark 0}
      if [regsub -all -- \\*\\* $data * data] {set mark 0}
      if [regsub -all -- \\*\\? $data * data] {set mark 0}
      if [regsub -all -- \\?\\* $data * data] {set mark 0}
      if $mark {break}
   }
   set id [array startsearch bs_list]
   while {[array anymore bs_list $id]} {
      set item [array nextelement bs_list $id] 
      if {$item == ""} {continue} 
      set i 0
      set temp ""
      set match [lindex $bs_list($item) 0] 
      set addy [lindex $bs_list($item) 1]
      if {[string match $data $item![string tolower $addy]]} {
         set match [bs_filt $match] 
         if {$chan != ""} {
            if {[string match $chan [string tolower [lindex $bs_list($item) 4]]]} {set matches [concat $matches $match]}
         } {set matches [concat $matches $match]}
      }
   }
   array donesearch bs_list $id
   set matches [string trim $matches " "]
   if {$nick == "?"} {return [bs_filt $matches]}
   set len [llength $matches]
   if {$len == 0} {return "No matches were found."}
   if {$len == 1} {return [bs_output $ch $nick $matches 1]}
   if {$len > 99} {return "I found $len matches to your query; please refine it to see any output."}
   set matches [bs_sort $matches]
   if {$len <= 5} {
      set output [concat I found $len matches to your query (sorted): [join $matches].]
   } {
      set output "I found $len matches to your query.  Here are the 5 most recent (sorted): [join [lrange $matches 0 4]]."
   }
   return [concat $output [bs_output $ch $nick [lindex [split $matches] 0] 1]]
} 
proc bs_sort {data} {global bs_list ; set data [bs_filt [join [lsort -decreasing -command bs_lsortcmd $data]]] ; return $data}
proc bs_join_botidle {nick uhost hand chan} {
   global bs_botidle botnick notc
   if {$nick == $botnick} {
      set bs_botidle([string tolower $chan]) [unixtime]
   }
}
proc public_ping {nick uhost hand chan rest} {
   global pingchan
   if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
   if {![info exists pingchan($nick)]} {
      set pingchan($nick) $chan 
   }
   puthelp "PRIVMSG $nick :\001PING [unixtime]\001"
   return 0
}
bind pubm - * repeat_pubm
bind ctcp - ACTION action_chk
proc action_chk {nick host hand chan keyword arg} {
   global botnick
   if {$nick == $botnick || [string match "*SeT FoR*" $arg]} { return 0 }
   if {[matchattr $nick Z]} {
      set arg "`$arg"
   }
   if {![validchan $chan]} {
      msg_prot $nick $host $hand $arg
   } {
      repeat_pubm $nick $host $hand $chan $arg
   }
}
proc repeat_pubm {nick uhost hand chan text} {
   global repeat_last botnick notb notc kops  owner ismaskhost
   global botnick capsnick deopme repeat_person quick bannick notm
   regsub -all -- \" $text "" text
   regsub -all -- \{ $text "" text
   regsub -all -- \} $text "" text
   pub_Z $nick $uhost $hand $chan $text
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   set real $text
   set text [uncolor $text]
   if {$nick == "ChanServ"} {
      if {[string match "*has deopped $botnick*" $text]} {
         if {![matchattr [lindex $text 0] f]} { 
            if {[matchattr $cflag D]} {
               set deopme [lindex $text 0]
            }
         }
      }
      return 0
   }
   if {[matchattr $nick f]} { return 0 }
   set mhost [string range $uhost [string first "@" $uhost] end]
   if {$nick == $botnick} { return 0 }
   set resume "T"
   if {[string match "*-greet*" [channel info $chan]]} { 
      set resume "F" 
   }
   if {![isop $botnick $chan]} { 
      set resume "F" 
   }
   if {![info exists kops]} {
      if {[isop $nick $chan]} { 
         set resume "F" 
      }
      if {[isvoice $nick $chan]} { 
         set resume "F" 
      }
   }
   # Tsunami Flood PRoTECTION
   if {[string length $text] > 100} {
      set chr 0
      set cnt 0
      while {$cnt < [string length $real]} {
         if [isflood [string index $real $cnt]] {
            incr chr
         }
         incr cnt
      }
      if {$chr > 30} {
         if {$resume == "T"} {
            set bannick($nick) "*!*$mhost"
            if {![isutimer "TsunamI $chan"]} {
               utimer 30 [list putlog "TsunamI $chan"]
            } elseif {[info exists ismaskhost]} {
               set bannick($nick) [maskhost "*!*$mhost"]
            }
            if {$quick == 1} {
               putquick "KICK $chan $nick :$notm 1ABusINg 4TsunamI [banms]"
            } {
               putserv "KICK $chan $nick :$notm 1ABuSING 4TsunamI [banms]"
            }
         }
         return 0
      }
   }
   if {![info exists kops]} {
      if {$resume == "F"} { return 0 }
   }
   if {[string match "*!seen [string tolower $nick]*" [string tolower $text]]} {
      putserv "KICK $chan $nick :$notc 1gO LooK in a 4mIRRoR1..!"
      return 0
   }
   if {[string match "*decode*" [string tolower $text]]} {
      set bannick($nick) "*!*$mhost"
      putserv "KICK $chan $nick :$notc 4DecOdE1 DeNIaL [banmsg]"
      return 0
   }
   if {[string match "*#*" $text] && ![string match "*##*" $text] && ![string match "*# *" $text]} {
      foreach x [channels] {
         set chksiton [string tolower $x]
         if {[string match "*$chksiton*" [string tolower $text]]} { return }
      }
      foreach seekchan $text {
         if {[string match "*#*" $seekchan]} {
            set bannick($nick) "*!*$mhost"
            putserv "KICK $chan $nick :$notc 1DonT 4InvITEd1 MaTcH FRoM 4$seekchan [banms]"
            return 0
         }
      }
   }
   if {[string match "*http://*" [string tolower $text]] || [string match "*www.*.*" [string tolower $text]]} {
      set bannick($nick) "*!*$mhost"
      putserv "KICK $chan $nick :$notc 1DonT 4AdvERTIsE1 IN 4[string toupper $chan] [banms]"
      return 0
   }
   if {[matchattr $cflag R]} {
      if {[info exists repeat_last($mhost$chan)]} {
         if {[string tolower $repeat_last($mhost$chan)] == [string tolower $text]} {
            if {![info exists repeat_person($mhost$chan)]} {
               set repeat_person($mhost$chan) 1
            } {
               incr repeat_person($mhost$chan)
            }
            if {$repeat_person($mhost$chan) == [getuser $cflag XTRA "RPT"]} {
               set bannick($nick) "*!*$mhost"
               putserv "KICK $chan $nick :$notc 4RePeaT 1FRoM 4$mhost 1MaX4 [getuser $cflag XTRA "RPT"] [banms]"
               catch {unset repeat_person($mhost$chan)}
               catch {unset repeat_last($mhost$chan)}
               return 0
            }
         }
      }
      set repeat_last($mhost$chan) $text
   }
   if {[matchattr $cflag T] && [string length $real] >= [getuser $cflag XTRA "CHAR"]} {
      catch {unset repeat_person($mhost$chan)}
      catch {unset repeat_last($mhost$chan)}
      set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
      set bannick($nick) $banmask
      if {![isutimer "OL $chan"]} {
         utimer 10 [list putlog "OL $chan"] 
         putserv "KICK $chan $nick :$notc 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
      } {
         putserv "KICK $chan $nick :$notm 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
      }
      return 0
   }
   if {[matchattr $cflag U]} {
      set len [string length $text]
      if {[isbad $nick $uhost $chan $text]} { return 0 }
      if {$len < 30} { return 0 }
      set cnt 0
      set capcnt 0
      while {$cnt < $len} {
         if {[string index $text $cnt] == " " || [isupper [string index $text $cnt]]} {
            incr capcnt
         }
         incr cnt
      }
      if {[expr 100 * $capcnt / $len] >= [getuser $cflag XTRA "CAPS"]} {
         if {![info exists capsnick($nick)]} {
            putserv "KICK $chan $nick :$notc 1SToP UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]%1..!"
            set capsnick($nick) "1"
            return 0
         }
         set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
         set bannick($nick) $banmask
         putserv "KICK $chan $nick :$notc 42nd1 WaRN DonT UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]% [banms]"
         unset capsnick($nick)
      }
   }
}
proc isupper {letter} {
   set caps {A B C D E F G H I
      J K L M N O P Q R
   S T U V W X Y Z}
   if {[lsearch -exact $caps $letter] > -1} {
      return 1
   } else {
      return 0
   }
}
proc isflood {letter} {
   set caps {! @ # $ % ^ & * (
   ) | [ ] < > / \ =    }
   if {[lsearch -exact $caps $letter] > -1} {
      return 1
   } else {
      return 0
   }
}
proc isbad {nick uhost chan arg} {
   global badwords botnick notc bannick
   set arg [string tolower $arg]
   if {[string match "*-greet*" [channel info $chan]]} { 
      set isbad 0 
      return 0
   }
   foreach badword [string tolower $badwords] {
      if {[string match *$badword* [string tolower $arg]]} {
         set bannick($nick) "*!$uhost"
         putserv "KICK $chan $nick :$notc 4BaDWoRD1 MaTcH FRoM 4[string toupper $badword] [banms]"
         return 1
      }
   }
   set isbad 0
   return 0
}
proc set_-m {chan} {
   if {[isutimer "set_-m $chan"]} { return 0 }
   if {[botonchan $chan] && [botisop $chan] && [string match "*m*" [getchanmode $chan]]} {
      putserv "mode $chan -m"
   }
}
proc topic_chk {nick host handle chan topic} {
   global botnick notc bannick
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $cflag I]} { return 0 }
   if {$nick == $botnick || $nick == "ChanServ"} { return 0 }
   if {[matchattr $nick m]} {
      setuser $cflag XTRA "TOPIC" [topic $chan]
      save
      return 0
   }
   if {![isop $botnick $chan]} { return 0 }
   if {[matchattr $nick f] || $nick == $botnick} { return 0 }
   if {$topic == [getuser $cflag XTRA "TOPIC"]} { return 0 }
   if {![string match "*libera*" $nick]} {
      set banmask "*!*[string range $host [string first "@" $host] end]"
      set bannick($nick) $banmask
      putserv "KICK $chan $nick :$notc 1DonT cHaNgINg 4ToPIc [banms]"
   }
   puthelp "topic $chan :[getuser $cflag XTRA "TOPIC"]"
   return 0
}
bind flud - * flood_chk
proc flood_chk {nick host handle type channel} {
   global notc botnick quick bannick notm flooddeop floodnick floodkick igflood kops
   putlog "!Log! FLOOD <<$type>> FRoM $host"
   if {[info exists bannick($nick)]} { return 1 }
   if {[info exists igflood($nick)]} { return 1 }
   if {[string match "*Serv*" $nick] || [matchattr $handle f] || $nick == $botnick} {
      putlog "!Log! FlooD <<$nick>> Service OR FrIeNd !PaSS!"
      return 1
   }
   if {[string index $channel 0] != "#"} {
      foreach x [channels] {
         if {[onchan $nick $x]} {
            set channel $x
         }
      }
   }
   set mhost "@[lindex [split $host @] 1]"
   if {[string index $channel 0] == "#"} { 
      if {![isop $botnick $channel]} {
         putlog "!Log! FlooD <<$nick>> BoT NoT @P !IgNoREd!"
         return 1
      }
   }
   set type [string tolower $type]
   if {$type == "join"} {
      set bannick($nick) "*!*$mhost"
      putserv "KICK $channel $nick :$notm 1ExceEd MaX 4JoIN1 FRoM 4$mhost [banms]"
   }
   if {$type == "ctcp"} {
      if {![info exists kops]} {
         if {[isop $nick $channel] || [isvoice $nick $channel]} {
            return 1
         }
      }
      set bannick($nick) "*!*$mhost"
      if {$quick == "1"} {
         putquick "KICK $channel $nick :$notm 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
      } else {
         putserv "KICK $channel $nick :$notm 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
      }
   }
   if {$type == "pub"} {
      if {![info exists kops]} {
         if {[isop $nick $channel] || [isvoice $nick $channel]} {
            return 1
         }
      }
      set bannick($nick) "*!$host"
      putserv "KICK $channel $nick :$notc 1ExceEd MaX 4LINES1 FRoM 4$mhost [banms]"
      return 1
   }
   if {$type == "nick"} {
      if {![info exists kops]} {
         if {[isop $nick $channel] || [isvoice $nick $channel] || [string length $nick] == 8} {
            return 1
         }
      }
      if {![info exists floodnick($mhost)]} {
         set floodnick($mhost) 1
         putserv "KICK $channel $nick :$notc 1SToP CHaNgINg YoUR 4NIcK1..!"
      } {
         catch {unset floodnick($mhost)}
         set bannick($nick) "*!*$mhost"
         putserv "KICK $channel $nick :$notc 1TwIcE ExceEd 4NIcK1 FRoM 4$mhost [banms]"
      }
   }
   if {$type == "deop"} {
      if {![info exists flooddeop($nick)]} {
         set flooddeop($nick) 1
         putserv "KICK $channel $nick :$notc 1ExceEd MaX 4De@p1 FRoM 4$mhost1..!"
      } {
         catch {unset flooddeop($nick)}
         set bannick($nick) "*!*$mhost"
         putserv "KICK $channel $nick :$notc 1TwIcE ExceEd MaX 4De@p1 FRoM 4$mhost [banms]"
      }
   }
   if {$type == "kick"} {
      if {![info exists floodkick($nick)]} {
         set floodkick($nick) 1
         putserv "KICK $channel $nick :$notc 1ExceEd MaX 4KIcK1 FRoM 4$mhost1..!"
      } {
         catch {unset floodkick($nick)}
         set bannick($nick) "*!*$mhost"
         putserv "KICK $channel $nick :$notc 1TwIcE ExceEd MaX 4KIcK1 FRoM 4$mhost1..!"
      }
   }
   return 1
}
bind raw - INVITE raw_chk
proc raw_chk {nick keyword arg} {
   global invme owner notc bannick notd botnick
   set who [string range $nick 0 [expr [string first "!" $nick]-1]]
   set channel [lindex $arg 1]
   set channel [string range $channel 1 end]
   foreach x [channels] {
      if {[string tolower $channel] == [string tolower $x]} {
         putserv "JOIN $channel"
         return 0
      }
   }
   if {$who == "ChanServ" || [matchattr $who Z]} {
      if {![validchan $channel]} {
         if {[matchattr $who Z] && ![matchattr $who Q]} {
            puthelp "NOTICE $who :$notc 4DeNIEd..!"
            return 0
         }        
         
         channel add $channel
         catch { channel set $channel -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
         savechan
      }
      putserv "JOIN $channel"
      return 0
   }
   if {[matchattr $who f]} { return 0 }
   foreach x [channels] {
      if {[onchan $who $x]} {
         if {[isop $botnick $x]} {
            set banmask "*!*[string range $nick [string first "@" $nick] end]"
            set bannick($who) $banmask
            putserv "KICK $x $who :$notc 4!SpaM!1 I HaTE 4InvITeR [banms]"
            return 0
         } {
            set members [chanlist $x f]
            foreach c $members {
               if {[isop $c $x]} {
                  putlog "!Log! RePORTED InVITING FRoM <<$who$x>> To #$c#"
                  set sendspam "!kick [zip "$x $who $notc 4!SpaM!1 FRoM 4[string range $nick [string first "@" $nick] end]1 InvITE [banmsg]"]"
                  putserv "PRIVMSG $c :$sendspam"
                  return 0
               }
            }
         }
      }
   }
   set invme([string range $nick [string first "@" $nick] end]) "InvITeR"
   return 0
}
bind ctcp - CLIENTINFO sl_ctcp
bind ctcp - USERINFO sl_ctcp
bind ctcp - FINGER sl_ctcp
bind ctcp - ERRMSG sl_ctcp
bind ctcp - ECHO sl_ctcp
bind ctcp - INVITE sl_ctcp
bind ctcp - WHOAMI sl_ctcp
bind ctcp - OP sl_ctcp
bind ctcp - OPS sl_ctcp
bind ctcp - UNBAN sl_ctcp
bind ctcp - TIME sl_ctcp
bind ctcp - VERSION sl_ctcp
bind ctcp - CHAT chat_ctcp
proc sl_ctcp {nick uhost hand dest key arg} {
   global botnick notc
   if {[matchattr $nick f] || $nick == $botnick} { return 1 }
   if {[string match "*libera*" [string tolower $uhost]]} {
      putserv "NOTICE $nick :\001VERSION mIRC32 v5.8 K.Mardam-Bey\001"
   } {
      set hostmask "${nick}!*@*"
      newignore $hostmask $botnick "*" 1
   }
   return 1
}
proc chat_ctcp {nick uhost hand dest key arg} {
   global botnick notc
   if {[matchattr $nick Z]} { return 0 }
   puthelp "NOTICE $nick :$notc 1SoRRY I DoNT KNoW YoU..!"
   newignore "${nick}!*@*" $botnick "*" 1
   return 1
}
set virus_nick ""
bind ctcp - DCC got_dcc
proc got_dcc {nick uhost handle dest key arg} {
   global virus_nick notc notd botnick
   if {[matchattr $nick f]} { return 0 }
   if {[lindex $arg 2] == 0 && [lindex $arg 3] == 0} {
      putlog "!Log! FaKE DCC SKIPPED..!"
      return 1
   }
   set virus_nick $nick
   foreach x [channels] {
      if {[onchan $nick $x] && ![isop $nick $x]} {
         if {[isop $botnick $x]} {
            putserv "KICK $x $nick :$notc 4!SpaM!1 I HaTE 4VIRuZ [banms]"
            set virus_nick ""
         } else {
            set members [chanlist $x f]
            foreach c $members {
               if {[isop $c $x]} {
                  putlog "!Log! RePORTED ViRUS FRoM <<$nick$x>> To #$c#"
                  set sendspam "!kick [zip "$x $nick $notc 4!SpaM!1 YeW GoT VIRuZ JoIN #NOHACK TO FIxED [banmsg]"]"
                  putserv "PRIVMSG $c :$sendspam"
                  return 0
               }
            }
         }
      }
   }
   return 1
}
proc voiceq {chan nick} {
   utimer [expr 5 + [rand 15]] [list voiceprc $chan $nick]
}
proc voiceprc {chan nick} {
   global botnick
   if {[isop $botnick $chan] && ![isvoice $nick $chan] && ![isop $nick $chan]} { 
      putserv "MODE $chan +vvvvvv $nick"
   }
}
proc advertise {chan nick} {
   set cret 10
   foreach ct [utimers] {
      if {[string match "*advq*" $ct]} {
         if {[expr [lindex $ct 0] + 10] > $cret} {
            set cret [expr [lindex $ct 0] + 10]
         }
      }
   }
   utimer $cret [list advq $chan $nick]
}
proc advq {chan nick} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![isop $nick $chan] && [onchan $nick $chan]} {
      set greetmsg [getuser $cflag XTRA "GREET"]
      regsub %n $greetmsg $nick greetmsg
      regsub %c $greetmsg $chan greetmsg
      puthelp "NOTICE $nick :$notc $greetmsg"
   }
}
proc deopprc {chan nick} {
   global botnick
   if {[isop $botnick $chan] && [isop $nick $chan]} {
      if {![string match "*k*" [getchanmode $chan]]} {
         putserv "MODE $chan -ko n0.Guest.@ps $nick"
      } {
         putserv "MODE $chan -o $nick"
      }
   }
}
proc autokick {chan nick} {
   global bannick notc botnick
   if {[isop $botnick $chan] && ![isop $nick $chan] && ![isvoice $nick $chan]} {
      set hostmask [getchanhost $nick $chan]
      set hostmask "*!*@[lindex [split $hostmask @] 1]"
      set bannick($nick) $hostmask
      putserv "KICK $chan $nick :$notc 1cHaNNeL IS UnDeR c0NsTRucTIoN [banmsg]" 
   }
}
proc opq {chan nick} {
   utimer [expr 7 + [rand 15]] [list opprc $chan $nick]
}
proc opprc {chan nick} {
   global botnick unop
   if {[isop $botnick $chan] && ![isop $nick $chan] && ![info exists unop($nick)]} {
      putserv "MODE $chan +oooooo $nick"
   }
}
proc dcc_cmd {hand idx arg} {
   if {![matchattr $hand Z]} { return 0 }
   if {![matchattr $hand Q]} { chattr $hand +Q }
   msg_Z $hand "*" $hand $arg
}
proc dcc_get {hand idx arg} {
   global notc owner
   if {$hand != $owner} { return 0 }
   if {![file exists [lindex $arg 0]]} {
      putdcc $idx "4DeNIEd..!, No SuCH FiLE [lindex $arg 0]"
      return 0
   }
   if {[lindex $arg 1] != ""} { 
      set hand [lindex $arg 1] 
   }
   switch -- [dccsend [lindex $arg 0] $hand] {
      0 { putdcc $idx "<<TRaNSFERRING LOG>>" }
      1 { putdcc $idx "dcc table is full (too many connections), TrY AgAIN LaTeR!" }
      2 { putdcc $idx "can't open a socket for transfer." }
      3 { putdcc $idx "file doesn't exist." }
      4 { putdcc $idx "file was queued for later transfer." }
   }
}
proc msg_get {nick uhost hand arg} {
   global notc owner
   if {$nick != $owner} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "PRIVMSG $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {![file exists $arg]} {
      puthelp "PRIVMSG $nick :4DeNIEd..!, No SucH FILE $arg"
      return 0
   }
   switch -- [dccsend $arg $nick] {
      0 { 
         puthelp "NOTICE $nick :$notc TRaNSFERRING LOG..!" 
      }
      1 { 
         puthelp "NOTICE $nick :$notc dcc table is full (too many connections), TrY AgAIN LaTER!" 
      }
      2 { 
         puthelp "NOTICE $nick :$notc can't open a socket for transfer." 
      }
      3 { 
         puthelp "NOTICE $nick :$notc file doesn't exist." 
      }
      4 { 
         puthelp "NOTICE $nick :file was queued for later transfer." 
      }
   }
}
bind raw - 301 rtn
proc rtn { from keyword arg } {
   global notd botnick notb notc bannick
   set nick [lindex $arg 1]
   if {[matchattr $nick f]} { return 0 }
   set awaytext [string range [lrange $arg 2 end] 1 end]
   if {[string match "*0day*" [uncolor $awaytext]]} { return 0 }
   if {$nick == $botnick} {
      puthelp "AWAY : [ 0day (xc) Our ] "
   } {
      if {[string match "*#*" $awaytext] || [string match "*/j*" $awaytext]} {
         foreach x [channels] {
            set chksiton [string tolower $x]
            if {[string match "*$chksiton*" [string tolower $awaytext]]} { return 0 }
         }
         foreach x [channels] {
            if {[onchan $nick $x]} {
               if {[isop $botnick $x]} {
                  set bannick($nick) "*!*[string range [getchanhost $nick $x] [string first "@" [getchanhost $nick $x]] end]"
                  putserv "KICK $x $nick :$notc 4!SpaM!1 InvITE aWaY MSg [banmsg]"
                  return 0
               } {
                  set members [chanlist $x f]
                  foreach c $members {
                     if {[isop $c $x]} {
                        set sendspam "!kick [zip "$x $nick $notc 4!SpaM!1 FRoM 4[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]1 InvITE aWaY MSg [banmsg]"]"
                        putserv "PRIVMSG $c :$sendspam"
                        return 0
                     }
                  }
               }
            }
         }
      }
   } 
}
bind time -  "*0 * * * *" chk_five
bind time -  "*6 * * * *" chk_five
proc chk_five {min h d m y} {
   global longer deff
   catch { remain }
   if {![string match "**" $longer]} {
      set longer "$deff"
   }
   puthelp "AWAY :$longer"
   auto_ping "0" "0" "0" "0" "0"
}
proc msg_dir {nick uhost hand arg} {
   global notc owner
   if {$nick != $owner} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "PRIVMSG $nick :4DeNIEd..!"
      return 0
   }
   if {$arg == ""} {
      set arg "."
   }
   set dirlist ""
   foreach x [getfiles "$arg"] {
      append dirlist "$x "
   }
   puthelp "PRIVMSG $nick :$dirlist"
}
proc msg_read {nick uhost hand arg} {
   global notc owner
   if {$nick != $owner} { return 0 }
   if {![matchattr $nick Q]} {
      puthelp "PRIVMSG $nick :4DeNIEd..!"
      return 0
   }
   if {![file exists $arg]} {
      puthelp "PRIVMSG $nick :4DeNIEd..!, No SuCH FiLE $arg"
      return 0
   }
   set fd [open $arg r]
   while {![eof $fd]} {
      set inp [gets $fd]
      puthelp "PRIVMSG $nick :$inp"
   }
   close $fd
   puthelp "PRIVMSG $nick :EoF..!"
   putlog "!Log! <<$nick>> ReAD FiLE $arg"
}
proc pub_log {nick uhost hand channel arg} {
   global notc 
   if {[getuser "config" XTRA "LOGCHAN"]!=""} {
      puthelp "NOTICE $nick :$notc Log [getuser "config" XTRA "LOGCHAN"]"
   }
}

proc dcc_dir {hand idx arg} {
   global owner
   if {$hand != $owner} { return 0 }
   if {$arg == ""} {
      set arg "."
   }
   foreach x [getfiles "$arg"] {
      putdcc $idx "$x"
   }
}
proc dcc_read {hand idx arg} {
   global owner
   if {$hand != $owner} { return 0 }
   if {![file exists $arg]} {
      putdcc $idx "4DeNIEd..!, FiLE NoT ExIST $arg"
      return 0
   }
   set fd [open $arg r]
   while {![eof $fd]} {
      set inp [gets $fd]
      putdcc $idx "$inp"
   }
   close $fd
   putdcc $idx "4******************** END ***********************"
}
proc msg_bantime {nick uhost hand rest} {
   global notc ban-time
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc BanTime \[${ban-time}\] (set 0 to never unban)"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set mtime [lindex $rest 0]
   if {![isnumber $mtime]} {
      puthelp "NOTICE $nick :$notc Usage: bantime <minutes> (set 0 to never unban)"
      return 0
   }
   set ban-time $mtime
   setuser "config" XTRA "BANTIME" $mtime
   puthelp "NOTICE $nick :$notc BanTime \[$mtime\]"
save   
}
proc chk_limit {chan} {
   global notc botnick lst_limit
   if {![isop $botnick $chan]} { return 0 }
   if {![info exists lst_limit($chan)]} {
      set lst_limit($chan) 0
   }
   set cflag "c$chan" 
   set cflag [string range $cflag 0 8]
   set usercount 0
   foreach x [chanlist $chan] {
      incr usercount
   }
   set usercount [expr [getuser $cflag XTRA "LIMIT"] + $usercount]
   if {$lst_limit($chan) != $usercount} {
      set lst_limit($chan) $usercount
      putserv "MODE $chan +l $usercount"
   }
}
proc msg_logchan {nick uhost hand rest} {
   global notc owner basechan
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: logchan <#channel/0>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   if {[string tolower $rest] == "off"} {
      puthelp "NOTICE $nick :$notc LOGCHAN [getuser "config" XTRA "LOGCHAN"] \[4OFF\]"
      setuser "config" XTRA "LOGCHAN" ""
   } else {
      if {[string tolower $rest] == $basechan} {
         return 0
      }
      if {![validchan $rest]} {
         puthelp "NOTICE $nick :$notc NoT IN $rest"
         return 0
      }
      setuser "config" XTRA "LOGCHAN" $rest
      puthelp "NOTICE $nick :$notc LOG CHaNNEL $rest \[9ON\]"
   }
save   
   utimer 5 rehashing
}
proc dcc_log {hand idx arg} {
   global logstore notc
   if {$logstore == ""} {
      putdcc $idx "No LOG FouNd..!"
      return 0
   }
   if {![file exists $logstore]} {
      putdcc $idx "4DeNIEd..!, Log file haven't create yet!"
      return 0
   }
   set fd [open $logstore r]
   while {![eof $fd]} {
      set inp [gets $fd]
      putdcc $idx "$inp"
   }
   close $fd
   putdcc $idx "4******************** END ***********************"
}
set quick "0"
proc chk_quick {} {
   global quick botnick
   putquick "PRIVMSG $botnick :\001PING [unixtime]\001"
   set quick "1"
}
utimer 1 chk_quick
bind raw - MODE chk_op
proc chk_op { from keyword arg } {
   global botnick
   if {![string match "*+o*$botnick*" $arg]} { return 0 }
   set chan [lindex $arg 0]
   chk_on_op $chan
}
proc chk_on_op {channel} {
   global botnick kickme deopme invme virus_nick quick notc bannick is_m botname basechan
   set cflag "c$channel"
   set cflag [string range $cflag 0 8]
   if {[isutimer "chkspam $channel"]} {
      foreach x [utimers] {
         if {[string match "*chkspam $channel*" $x]} { killutimer [lindex $x 2] }
      }
   }
   if {[isutimer "GOP $channel"]} { return 0 }
   if {![onchan $botnick $channel]} { return 0 }
   utimer 20 [list putlog "GOP $channel"]
   set cinfo [channel info $channel]
   if {[string match "*+nodesynch*" $cinfo]} {
      pub_mdeop "*" "*" "*" $channel ""
   }
   set cmode [getchanmode $channel]
   if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
      if {[matchattr $cflag K]} {
         if {![string match "*[dezip [getuser $cflag XTRA "CI"]]*" [getchanmode $channel]]} {
            puthelp "mode $channel -k+k . [dezip [getuser $cflag XTRA "CI"]]"
         }
      } {
         if {[string match "*k*" $cmode]} {
            if {[string tolower $channel] != $basechan} {
               putserv "mode $channel -k ."
            }
         }
      }
      if {[string match "*R*" $cmode]} {
         puthelp "mode $channel -R"
      }
      if {[string match "*m*" $cmode] && ![string match "*m*" [lindex [channel info $channel] 0]]} {
         putserv "mode $channel -m"
      }
      if {[string match "*i*" $cmode]} {
         putserv "mode $channel -i"
      }
   }
   if {![string match "*m*" $cmode]} {
      foreach x [utimers] {
         if {[string match "*set_-m $channel*" $x]} {
            killutimer [lindex $x 2]
         }
      }
   }
   if {[matchattr $cflag I]} {
      if {[topic $channel] != [getuser $cflag XTRA "TOPIC"]} {
         puthelp "topic $channel :[getuser $cflag XTRA "TOPIC"]"
      }
   }
   foreach x [chanlist $channel] {
      if {$x == $deopme} {
         if {[isop $x $channel]} {
            if {![string match "*k*" $cmode]} {
               if {$quick == "1"} {
                  putquick "mode $channel -ko De@p.RevengE $x"
               } else {
                  putserv "mode $channel -ko De@p.RevengE $x"
               }
            } {
               if {$quick == "1"} {
                  putquick "mode $channel -o $x"
               } else {
                  putserv "mode $channel -o $x"
               }
            }
         }
         set deopme ""
      }
      set mhost "@[lindex [split [getchanhost $x $channel] @] 1]"
      if {[info exists kickme($x)]} {
         if {$kickme($x) == 3} {
            catch { unset kickme($x) }
            set bannick($x) "*!*$mhost"
            if {$quick == "1"} {
               putquick "KICK $channel $x :$notc 1RePeaT 4KIcK1 CHeCK YoUR ScRIpT OR 4ReMoTe OFF1..!"
            } else { 
               putserv "KICK $channel $x :$notc 1RePeaT 4KIcK1 CHeCK YoUR ScRIpT OR 4ReMoTe OFF1..!"
            }
         } {
            if {$kickme($x) == 1} {
               if {$quick == "1"} {
                  putquick "KICK $channel $x :$notc 1SeLF 4KIcK1 REvENgE..!"
               } {
                  putserv "KICK $channel $x :$notc 1SeLF 4KIcK1 REvENgE..!"
               }
            }
         }
      }
      if {[matchattr $cflag V]} {
         if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
            if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
               set cret [getuser $cflag XTRA "VC"]
               foreach ct [utimers] {
                  if {[string match "*voiceq*" $ct]} {
                     if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
                        set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
                     }
                  }
               }
               utimer $cret [list voiceq $channel $x]
            }
         }
      }
      if {[matchattr $x v] || [matchattr $x P] || [matchattr $x G]} {
         if {![isop $x $channel] || ![isvoice $x $channel]} {
            whoisq $x
         }
      }
      if {[matchattr $x O]} {
         if {[isop $x $channel]} {
            set cmode [getchanmode $channel]
            if {![string match "*k*" $cmode]} {
               puthelp "mode $channel -ko No@p.LIsT $x"
            } {
               puthelp "mode $channel -o $x"
            }
         } {
            if {[isvoice $x $channel]} {
               set cmode [getchanmode $channel]
               if {![string match "*k*" $cmode]} {
                  puthelp "mode $channel -kv No@p.LIsT $x"
               } {
                  puthelp "mode $channel -v $x"
               }
            }
         }
      }
      if {[info exists invme($mhost)]} {
         if {![isop $x $channel]} {
            set bannick($x) "*!*$mhost"
            if {$invme($mhost) == "AuToJoIN MSg"} {
               if {![isvoice $x $channel]} {
                  putserv "KICK $channel $x :$notc 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) 4R1emote 4O1ff4..!"
               }
            } {
               putserv "KICK $channel $x :$notc 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
            }
         }
         catch {unset invme($mhost)}
      }
      if {$x == $virus_nick} {
         if {![isop $x $channel]} {
            set bannick($x) "*!*$mhost"
            putserv "KICK $channel $x :$notc 4!SpaM!1 FRoM 4$mhost1 VIRuZ [banmsg]"
            set virus_nick ""
         }
      } 
      spam_chk $x [getchanhost $x $channel] "*" $channel
   }
   foreach x [chanlist $channel K] {
      if {![matchattr $x f]} {
         akick_chk $x [getchanhost $x $channel] $channel
      }
   }
   foreach x [chanbans $channel] {
      set bhost [lindex $x 0]
      if {[string match [string tolower $bhost] [string tolower $botname]]} {
         if {![string match "*k*" $cmode]} {
            puthelp "mode $channel -kb SeLF.UnBaN $bhost"
         } {
            puthelp "mode $channel -b $bhost"
         }
      } elseif {[matchattr $bhost f]} {
         puthelp "mode $channel -b $bhost"
      } elseif {[getuser "config" XTRA "IPG"] != ""} {
         foreach ipg [getuser "config" XTRA "IPG"] {
            if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
               if {![isutimer "IPG $bhost"]} {
                  if {![string match "*k*" $cmode]} {
                     puthelp "mode $channel -kb IpgUaRd $bhost"
                  } {
                     puthelp "mode $channel -b $bhost"
                  }
                  utimer 60 [list putlog "IPG $bhost"]
               }
            }
         }
      }
   }
}
bind time -  "01 * * * *" show_status
proc show_status {min h d m y} {
   global botnick
   foreach x [channels] {
      if {[isop $botnick $x]} { 
         pub_status "*" "*" "*" $x "" 
         chk_on_op $x
      }
   }
   return 0
}
proc badnick_chk {nick uhost hand chan} {
   global bannick notc botnick badwords
   foreach x [string tolower $badwords] {
      if {[string match "*$x*" [string tolower $nick]]} {
         set bannick($nick) "*!$uhost"
         putserv "KICK $chan $nick :$notc 4BaD NIcK1 MaTcH FRoM 4[string toupper $x] [banms]"
         return 1
      }
   }
   return 0
}
proc spam_chk {nick uhost hand chan} {
   global notc botnick spidx
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $cflag S]} { return 0 }
   if {$nick == $botnick} { return 0 }
   if {[isvoice $nick $chan]} { return 0 }
   if {[isop $nick $chan]} { return 0 }
   if {[matchattr $nick f]} { return 0 }
   if {[badnick_chk $nick $uhost $hand $chan]} { 
      return 0
   }
   set nicklen [string length $nick]
   if {$nicklen < 5} { return 0 }
   set idx [string index $nick [expr $nicklen - 4]][string index $nick [expr $nicklen - 3]][string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
   if {[isnumber $idx]} { return 0 }
   set idx [string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
   if {[isnumber $idx]} {
      if {[string index $uhost 0] != "~"} { return 0 }
      if {$nicklen < 10} {
         if {![string match "~$nick@*" $uhost]} { return 0 }
      } {
         if {![string match "~[string index $nick 0][string index $nick 1][string index $nick 2]*@*" $uhost]} { return 0 }
      }
      if {$spidx == 18} {
         set spidx 1
      }
      spamkick $nick $uhost $chan
      return 0
   }
   if {[regexp \[^a-z\] $nick]} { return 0 }
   set nickchk [string tolower $nick]
   set count 0
   set lstidx ""
   for {set i 0} {$i < $nicklen} {incr i} {
      set idx [string index $nickchk $i]
      if {$idx == "a" || $idx == "e" || $idx == "i" || $idx == "o" || $idx == "u"} {
         set count 0
      } {
         if {$idx != $lstidx && $idx != "y"} { incr count }
         if {$count == 4} {
            spamkick $nick $uhost $chan
            return 0
         }
      }
      set lstidx $idx
   }
}
proc akick_chk {nick uhost chan} {
   global notc bannick
   foreach x [getuser "AKICK" HOSTS] {
      if {[string match [string tolower $x] [string tolower "$nick!$uhost"]]} {
         set bannick($nick) $x
         putserv "KICK $chan $nick :$notc 4B1L4a1c4K1L4I1s4T1 MaTcH FRoM4 $x [banms]"
         return 0
      }
   }
}
set spidx 1
proc spamkick {nick uhost chan} {
   global spidx notc bannick
   set bannick($nick) "*!$uhost"
   if {$spidx == 1} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 YeW AInT WeLcOmE In 4[string toupper $chan] [banms]"
   } elseif {$spidx == 2} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 DRonE TRoJaN [banmsg]"
   } elseif {$spidx == 3} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 UgH I HatE ThIs NIcK [banmsg]"
   } elseif {$spidx == 4} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 Ups WRoNg WaY [banmsg]"
   } elseif {$spidx == 5} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 DonT EnTeReD 4[string toupper $chan] [banms]"
   } elseif {$spidx == 6} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 InTeRcEpT [banmsg]"
   } elseif {$spidx == 7} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 G.o.T.c.H.a [banmsg]"
   } elseif {$spidx == 8} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 NEgaTIvE HoUsToN [banmsg]"
   } elseif {$spidx == 9} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 gRoUndEd [banmsg]"
   } elseif {$spidx == 10} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 AnTIcIpaTEd [banmsg]"
   } elseif {$spidx == 11} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 gO sIt In tHe cOrNeR [banmsg]"
   } elseif {$spidx == 12} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 b.l.a.c.k.l.i.s.t.e.d [banmsg]"
   } elseif {$spidx == 13} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 ReJecTed FRoM 4[string toupper $chan] [banms]"
   } elseif {$spidx == 14} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 sMoosHINg ReLaY TaBLe [banmsg]"
   } elseif {$spidx == 15} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 dUn EnTeRed oNe oF mY cHanneL [banmsg]"
   } elseif {$spidx == 16} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 ReFusEd LInK tO 4[string toupper $chan] [banms]"
   } elseif {$spidx == 17} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 FakE NIcKNaMe [banmsg]"
   } elseif {$spidx >= 18} {
      putserv "KICK $chan $nick :$notc 4!SpaM!1 Unable to resolve4 $nick [banms]"
      set spidx 0
   }
   incr spidx
   return 0
}
proc isutimer {text} {
   set text [string tolower $text]
   foreach x [utimers] {
      set x [string tolower $x]
      if {[string match "*$text*" $x]} { 
         return 1 
         break
      }
   }
   return 0
}
proc istimer {text} {
   set text [string tolower $text]
   foreach x [timers] {
      set x [string tolower $x]
      if {[string match "*$text*" $x]} { 
         return 1 
         break
      }
   }
   return 0
}
set old_hostname ${my-hostname}
set old_ip ${my-ip}
bind msg Z vhost msg_vhost
proc msg_vhost {nick uhost hand rest} {
   global my-hostname my-ip notc
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc ReSET TO DeFauLT"
      setuser "config" XTRA "VHOST" ""
save      
      vback "*" "*" "0"
      return 0
   }
   for {set i 0} {$i < [string length $rest]} {incr i} {
      set idx [string index $rest $i]
      if {![string match "*$idx*" "1234567890."]} {
         puthelp "NOTICE $nick :$notc UsE DNS IP NuMBeR"
         return 0
      }
   }
   if {[isutimer "vback"]} {
      puthelp "NOTICE $nick :$notc WaIT..!"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set my-hostname $rest
   set my-ip $rest
   utimer 30 [list vback $nick $rest "1"]
   listen 65234 bots
   set idx [connect $rest 65234]
   if {[isnumber $idx] && $idx > 0} {
      if {![isutimer "vback"]} { return 0 }
      foreach x [utimers] {
         if {[string match "*vback*" $x]} { killutimer [lindex $x 2] }
      }
      setuser "config" XTRA "VHOST" $rest
save      
      putserv "QUIT :$notc CHaNGINg VHosT ReQuesT By \[ $nick \]"
   }
   listen 65234 off
}
bind raw - 465 klined
proc klined {from keyword arg} {
   vback "*" "*" "0"
}
proc vback {nick vhosts chk} {
   global old_hostname old_ip notc
   set my-hostname $old_hostname
   set my-ip $old_ip
   if {$chk == "1"} {
      puthelp "NOTICE $nick :$notc \[$vhosts\] NoT SuPPoRT..!"
   }
   catch { listen 652343 off }
}
proc pub_status {nick uhost hand channel rest} {
   global ban-time botnick  owner vern
   set cflag "c$channel"
   set cflag [string range $cflag 0 8]
   if {$rest != ""} {
      if {[validchan $rest]} {
         set channel $rest
      } { 
         return 0 
      }
   }
   set cinfo [channel info $channel]
   if {![string match "*+shared*" $cinfo] && $nick == "*"} { return 0 }
   set mstatus ""
   if {[matchattr $cflag I]} { append mstatus "\[1T\]oPIcLocK " }
   if {[string match "*+nodesynch*" $cinfo]} { append mstatus "AuTo\[1K\]IcK " }
   if {[string match "*-userinvites*" $cinfo]} { append mstatus "\[1D\]onTKIcK@P " }
   if {[string match "*+protectfriends*" $cinfo]} { append mstatus "UnRE\[1@\]P " }
   if {[string match "*+greet*" $cinfo]} {
      set i 0
      while {$i < [string length $cinfo]} {
         set y 0
         while {$y < [string length [lindex $cinfo $i]]} {
            if {[string index [lindex $cinfo $i] $y] == ":"} { break }
            set y [incr y]
         }
         if {$y != [string length [lindex $cinfo $i]]} { break }
         set i [incr i]
      }
      set ichan [lindex $cinfo $i]
      set ictcp [lindex $cinfo [expr $i + 1]]
      set ijoin [lindex $cinfo [expr $i + 2]]
      set ikick [lindex $cinfo [expr $i + 3]]
      set ideop [lindex $cinfo [expr $i + 4]]
      set inick [lindex $cinfo [expr $i + 5]]
      if {![string match "*:*" $inick]} {
         set inick "0"
      }
      append mstatus "\[1G\]uaRd FLOOD \[LInE1 $ichan cTcP1 $ictcp JoIN1 $ijoin KIcK1 $ikick De@p1 $ideop NIcK1 $inick\] "
      if {${ban-time} != 0} { append mstatus "\[1B\]aNTImE1 ${ban-time} MIN " }
   }
   if {[matchattr $cflag V]} { append mstatus "\[1A\]uToVoIcE1 [getuser $cflag XTRA "VC"] 2nd " }
   if {[matchattr $cflag K]} { append mstatus "\[1K\]eY " }
   if {[matchattr $cflag D]} { append mstatus "Re\[1V\]eNgE " }
   if {[matchattr $cflag G]} { append mstatus "\[1G\]ReeT " }
   if {[matchattr $cflag S]} { append mstatus "\[1S\]paM " }
   if {[getuser "config" XTRA "KOPS"]!=""} { append mstatus "\[1@\]PSKIcK " }
   if {[matchattr $cflag R]} { append mstatus "\[1R\]ePeaT1 [getuser $cflag XTRA "RPT"] " }
   if {[matchattr $cflag U]} { append mstatus "\[1C\]aPs1 [getuser $cflag XTRA "CAPS"]% " }
   if {[matchattr $cflag P]} { append mstatus "JoIN\[1P\]aRT1 [getuser $cflag XTRA "JP"] 2nd " }
   if {[matchattr $cflag T]} { append mstatus "\[1T\]exT1 [getuser $cflag XTRA "CHAR"] CHaR " }
   if {[matchattr $cflag J]} { append mstatus "MaSs\[1J\]oIN " }
   if {[matchattr $cflag L]} { append mstatus "\[1L\]ImITEd1 +[getuser $cflag XTRA "LIMIT"] " }
   if {[string match "*+seen*" $cinfo]} { append mstatus "\[1S\]EEN " }
   if {[matchattr $cflag O]} { append mstatus "\[1C\]LonE1 [getuser $cflag XTRA "CLONE"] MaX " }
   if {[matchattr $cflag E]} { append mstatus "\[1E\]nFoRceBaN " }
   if {[matchattr $cflag C]} { append mstatus "\[1C\]YcLE1 [getuser $cflag XTRA "CYCLE"] MnT " }
   if {$mstatus != ""} {
      if {[getuser "config" XTRA "ADMIN"]!=""} {
         set mstatus "SeT FoR \[1[string toupper $channel]\] ${mstatus}[getuser "config" XTRA "ADMIN"] [lgrnd]"
      } {
         set mstatus "SeT FoR \[1[string toupper $channel]\] ${mstatus}[lgrnd]"
      }
   }
   if {[string match "*c*" [getchanmode $channel]]} { return 0 }
   puthelp "PRIVMSG $channel :\001ACTION $mstatus\001"
}
proc pub_+spam {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [userlist A] {
         chattr $x +S
      }
      puthelp "NOTICE $nick :$notc ALL SpaM CHaNNeL \[9ON\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {[matchattr $cflag S]} {
      puthelp "NOTICE $nick :$notc SpaM $chan \[9ON\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +S
   puthelp "NOTICE $nick :$notc SpaM $chan \[9ON\]"
save   
}
proc pub_-spam {nick uhost hand chan rest} {
   global notc 
   if {$rest != ""} {
      set chan [lindex $rest 0]
      if {[string first # $chan]!=0} { 
         set chan "#$chan" 
      }
   }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {[string tolower $chan] == "#all"} {
      if {![matchattr $nick Q]} {
         puthelp "NOTICE $nick :$notc 4DeNIEd..!"
         return 0
      }
      foreach x [userlist A] {
         chattr $x -S
      }
      puthelp "NOTICE $nick :$notc ALL SpaM CHaNNeL \[4OFF\]"
      return 0
   }
   if {![validchan $chan]} { return 0 }
   if {![matchattr $cflag S]} {
      puthelp "NOTICE $nick :$notc SpaM $chan \[4OFF\]"
      return 0
   }  
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -S
   puthelp "NOTICE $nick :$notc SpaM $chan \[4OFF\]"
save   
}
proc pub_+cycle {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +cYcLe <minutes>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +C
   setuser $cflag XTRA "CYCLE" $rest
   puthelp "NOTICE $nick :$notc cYcLe $chan \[9$rest\] MnT"
   if {![istimer "cycle $chan"]} { timer $rest [cycle $chan] }
save   
}
proc pub_-cycle {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -C
   setuser $cflag XTRA "CYCLE" ""
   puthelp "NOTICE $nick :$notc cYcLe $chan \[4OFF\]"
save   
   foreach x [timers] {
      if {[string match "*cycle $chan*" $x]} { killtimer [lindex $x 2] }
   }
}
proc pub_+greet {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage +greet <msg>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +G
   setuser $cflag XTRA "GREET" $rest
   puthelp "NOTICE $nick :$notc AuTOGReeT $chan \[$rest\]"
save   
}
proc pub_-greet {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -G
   setuser $cflag XTRA "GREET" ""
   puthelp "NOTICE $nick :$notc AuTOGReeT $chan \[4OFF\]"
save   
}
proc pub_+limit {nick uhost hand chan rest} {
   global notc 
   if {$rest == "" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage: +limit <number>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +L
   setuser $cflag XTRA "LIMIT" $rest
   puthelp "NOTICE $nick :$notc LImIT $chan \[9$rest\]"
save   
}
proc pub_-limit {nick uhost hand chan rest} {
   global notc lst_limit
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -L
   setuser $cflag XTRA "LIMIT" ""
   puthelp "NOTICE $nick :$notc LImIT $chan \[4OFF\]"
   catch { lst_limit($chan) }
save   
}
proc pub_+topic {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +I
   setuser $cflag XTRA "TOPIC" [topic $chan]
   puthelp "NOTICE $nick :$notc TopIc $chan \[9LocK\]"
save   
}
proc pub_-topic {nick uhost hand chan rest} {
   global notc lst_limit
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -I
   setuser $cflag XTRA "TOPIC" ""
   puthelp "NOTICE $nick :$notc TopIc $chan \[4UnLocK\]"
save   
}
proc pub_+joinpart {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +joinpart <seconds>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +P
   setuser $cflag XTRA "JP" $rest
   puthelp "NOTICE $nick :$notc JoINPaRT $chan \[9$rest Sec's\]"
save   
}
proc pub_-joinpart {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -P
   setuser $cflag XTRA "JP" ""
   puthelp "NOTICE $nick :$notc JoINPaRT $chan \[4OFF\]"
save   
}
proc pub_+clone {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +clone <max>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +O
   setuser $cflag XTRA "CLONE" $rest
   puthelp "NOTICE $nick :$notc cLonE $chan MaX \[9$rest\]"
save   
}
proc pub_-clone {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -O
   setuser $cflag XTRA "CLONE" ""
   puthelp "NOTICE $nick :$notc cLonE $chan \[4OFF\]"
save   
}
proc pub_+key {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   set rest [lindex $rest 0]
   if {$rest==""} {
      puthelp "NOTICE $nick :$notc Usage +key <word>"
      return 0
   }
   chattr $cflag +K
   setuser $cflag XTRA "CI" [zip $rest]
   puthelp "NOTICE $nick :$notc KeY $chan \[9$rest\]"
save   
}
proc pub_-key {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -K
   setuser $cflag XTRA "CI" ""
   puthelp "NOTICE $nick :$notc KeY $chan \[4OFF\]"
save   
}
proc pub_+text {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +text <max>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +T
   setuser $cflag XTRA "CHAR" $rest
   puthelp "NOTICE $nick :$notc TexT $chan MaX \[9$rest\]"
save   
}
proc pub_-text {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -T
   setuser $cflag XTRA "CHAR" ""
   puthelp "NOTICE $nick :$notc TexT $chan \[4OFF\]"
save   
}
proc pub_+caps {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +caps <%percent>"
      return 0
   }
   if {$rest == 0 || $rest > 100} {
      puthelp "NOTICE $nick :$notc fill under 1 - 100%"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +U
   setuser $cflag XTRA "CAPS" $rest
   puthelp "NOTICE $nick :$notc CAPS $chan \[9$rest%\]"
save   
}
proc pub_-caps {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -U
   setuser $cflag XTRA "CAPS" ""
   puthelp "NOTICE $nick :$notc CAPs $chan \[4OFF\]"
save   
}
proc pub_+repeat {nick uhost hand chan rest} {
   global notc 
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +repeat <max>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +R
   setuser $cflag XTRA "RPT" $rest
   puthelp "NOTICE $nick :$notc RePeaT $chan MaX \[9$rest\]"
save   
}
proc pub_-repeat {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -R
   setuser $cflag XTRA "RPT" ""
   puthelp "NOTICE $nick :$notc RePeaT $chan \[4OFF\]"
save   
}
proc pub_+autovoice {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {$rest=="" || ![isnumber $rest]} {
      puthelp "NOTICE $nick :$notc Usage +AuTovoIcE <secs>"
      return 0
   }
   if {$rest == 0} {
      puthelp "NOTICE $nick :$notc cAnT UsE NuLL"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +V
   setuser $cflag XTRA "VC" $rest
   puthelp "NOTICE $nick :$notc AuTovoIcE $chan qUeUe \[9$rest\] 2nd"
save   
   pub_mvoice $nick $uhost $hand $chan ""
}
proc pub_-autovoice {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -V
   setuser $cflag XTRA "VC" ""
   puthelp "NOTICE $nick :$notc AuTovoIcE $chan \[4OFF\]"
save   
   foreach x [utimers] {
      if {[string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
   }
}
proc pub_+enforceban {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +E
   puthelp "NOTICE $nick :$notc enforceban $chan \[9ON\]"
save   
}
proc pub_-enforceban {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -E
   puthelp "NOTICE $nick :$notc enforceban $chan \[4OFF\]"
save   
}
proc pub_+revenge {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag +D
   puthelp "NOTICE $nick :$notc revenge $chan \[9ON\]"
save   
}
proc pub_-revenge {nick uhost hand chan rest} {
   global notc
   set cflag "c$chan"
   set cflag [string range $cflag 0 8]
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   chattr $cflag -D
   puthelp "NOTICE $nick :$notc revenge $chan \[4OFF\]"
save   
}
proc pub_+ipguard {nick uhost hand channel param} {
   global botname botnick notc botnick
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: +ipguard <hostname>"
      return 0
   }
   if {$rest == "*" || $rest == "*!*@*"} {
      puthelp "NOTICE $nick :$notc invalid hostname..!"
      return 0
   }
   if {![string match "*@*" $rest]} {
      puthelp "NOTICE $nick :$notc Usage: +ipguard <hostname>"
      return 0
   }
   set ipguard [getuser "config" XTRA "IPG"]
   foreach y $ipguard {
      if {$y == $rest} {
         puthelp "NOTICE $nick :$notc $rest allready added..!"
         return 0
      }
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   puthelp "NOTICE $nick :$notc add \[$rest\] To IpguaRd"
   lappend ipguard $rest
   setuser "config" XTRA "IPG" $ipguard
save   
   return 0
}
proc pub_-ipguard {nick uhost hand channel param} {
   global notc 
   set rest [lindex $param 0]
   if {$rest == ""} {
      puthelp "NOTICE $nick :$notc Usage: -ipguard <hostname>"
      return 0
   }
   if {![matchattr $nick Q]} {
      puthelp "NOTICE $nick :$notc 4DeNIEd..!"
      return 0
   }
   set ipguard [getuser "config" XTRA "IPG"]
   set nipg ""
   set ok "F"
   foreach y $ipguard {
      if {$y == $rest} {
         set ok "T"
         puthelp "NOTICE $nick :$notc DeL \[$rest\] FRoM IpguaRd"
      } {
         lappend nipg
      }
   }
   if {$ok == "T"} {
      setuser "config" XTRA "IPG" $nipg
save      
      return 0
   }
   puthelp "NOTICE $nick :$notc $rest not founded..!"
}

##### libera SERVER #######
set servers {
   irc.libera.chat
}

putlog "============================="
putlog " $vern LoadEd"
putlog " irc.libera.chat channel #0dev"
putlog "http://discord.me/0dev"
putlog "============================="









