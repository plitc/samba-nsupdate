#!/bin/sh
#
### ### ### PLITC ### ### ###
#
### Copyright (c) 2014, Daniel Plominski (Plominski IT Consulting)
### All rights reserved.
###
### Redistribution and use in source and binary forms, with or without modification,
### are permitted provided that the following conditions are met:
###
### * Redistributions of source code must retain the above copyright notice, this
###   list of conditions and the following disclaimer.
###
### * Redistributions in binary form must reproduce the above copyright notice, this
###   list of conditions and the following disclaimer in the documentation and/or
###   other materials provided with the distribution.
###
### THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
### ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
### WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
### DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
### ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
### (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
### LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
### ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
### (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
### SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### ### ### PLITC ### ### ###


### <--- CONFIGURE ---

KERBEROSADMINUSER="dnsadmins-user@DC.DOMAIN.TLD"

ADMACHINENAME="maschine.dc.domain.tld"
ADSERVERNAME="dc.domain.tld"
ADSERVERZONE="dc.domain.tld"
ADMACHINETTL="3600"

INTERFACE="wlan0"

### --- CONFIGURE --->


###
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
###

### ADMACHINENAME=$(hostname -f)
IPV4=$(ifconfig $INTERFACE | grep "broadcast" | /usr/bin/awk '{print $2}' | head -n1)
IPV6=$(ifconfig $INTERFACE | grep "autoconf" | /usr/bin/awk '{print $2}' | head -n1)

FILE="adds-nsupdate.txt"

KERBEROSINIT=$(which kinit)

###

case $(uname) in
Linux)
    # echo "Linux"
    ;;
Darwin)
    # echo "Mac"
    ;;
FreeBSD)
    # echo "FreeBSD"
    ;;
*)
    # error 1
    echo "ERROR: Plattform=unknown"
    exit 0
    ;;
esac

###

if [ -f /usr/sbin/samba_dnsupdate ]; then
   # Debian derived
   #
elif [ -f /usr/bin/nsupdate ]; then
   # Mac
   #
elif [ -f /usr/local/bin/samba-nsupdate ]; then
   # FreeBSD
   #
else
   echo "Samba / DNSUpdate Package not found..."
   echo "Do you want install it? n/j:"
   {
   read answer
   # echo "allright: $answer"
   # if [ "$answer" = "j" ]
   if [ "$answer" != "n" ]
      then
      {
      case $(uname) in
      Linux)
         # echo "Linux"
         sudo apt-get install samba dnsutils
      ;;
      Darwin)
         # echo "Mac"
      ;;
      FreeBSD)
         # echo "FreeBSD"
         sudo pkg_add -r samba4 samba-nsupdate
      ;;
      esac
      }
   else
      echo ""
      echo "Have a nice day"
      exit 0
   fi
   }
fi

###

if [ $KERBEROSINIT = /usr/bin/kinit ]; then
   # Kerberos installed
else
   echo "Kerberos Client Package not found..."
   echo "Do you want install it? n/j:"
   {
   read answer
   # echo "allright: $answer"
   # if [ "$answer" = "j" ]
   if [ "$answer" != "n" ]
      then
      {
      case $(uname) in
      Linux)
         # echo "Linux"
         sudo apt-get install krb5-user krb5-clients
      ;;
      Darwin)
         # echo "Mac"
      ;;
      FreeBSD)
         # echo "FreeBSD"
      ;;
      esac
      }
   else
      echo ""
      echo "Have a nice day"
      exit 0
   fi
   }
fi

### <--- --- ---> ###

/usr/bin/kinit $KERBEROSADMINUSER

> ./adds-nsupdate.txt
/bin/echo "server $ADSERVERNAME" >> ./adds-nsupdate.txt
/bin/echo "zone $ADSERVERZONE" >> ./adds-nsupdate.txt

/bin/echo "update delete $ADMACHINENAME. A" >> ./adds-nsupdate.txt
/bin/echo "update add $ADMACHINENAME. $ADMACHINETTL A $IPV4" >> ./adds-nsupdate.txt

/bin/echo "update delete $ADMACHINENAME. AAAA" >> ./adds-nsupdate.txt
/bin/echo "update add $ADMACHINENAME. $ADMACHINETTL AAAA $IPV6" >> ./adds-nsupdate.txt

/bin/echo "show" >> ./adds-nsupdate.txt
/bin/echo "send" >> ./adds-nsupdate.txt

### <--- --- ---> ###

echo ""

case $(uname) in
Linux)
    # echo "Linux"
    /usr/bin/nsupdate -g -v $FILE
    ;;
Darwin)
    # echo "Mac"
    /usr/bin/nsupdate -g -v $FILE
    ;;
FreeBSD)
    # echo "FreeBSD"
    /usr/local/bin/samba-nsupdate -g -v $FILE
    ;;
esac

exit 0

### ### ### PLITC ### ### ###
# EOF
