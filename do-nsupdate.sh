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

case $(uname) in
FreeBSD)
    ### FreeBSD ###
### ### ### ### ### ### ### ### ###
cat << 'FREEBSDEOF' > /tmp/do-nsupdate-freebsd.sh
#!/bin/sh
{
FILE="$HOME/do-nsupdate.txt"
CONFIG="$HOME/do-nsupdate.conf"

SKERBEROSADMINUSER=$(grep "KERBEROSADMINUSER" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINENAME=$(grep "ADMACHINENAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERNAME=$(grep "ADSERVERNAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERZONE=$(grep "ADSERVERZONE" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINETTL=$(grep "ADMACHINETTL" $CONFIG | /usr/bin/awk '{print $3}')
SINTERFACE=$(grep "INTERFACE" $CONFIG | /usr/bin/awk '{print $3}')

IPV4=$(ifconfig $SINTERFACE | grep "broadcast" | /usr/bin/awk '{print $2}' | head -n1)
IPV6=$(ifconfig $SINTERFACE | grep "autoconf" | /usr/bin/awk '{print $2}' | head -n1)

SKERBEROSINIT=$(which kinit)
### SADMACHINENAME=$(hostname -f)

case $(uname) in
FreeBSD)
    ### FreeBSD ###
    ;;
*)
    # error 1
    echo "ERROR: Plattform=unknown"
    exit 0
    ;;
esac

if [ -f /usr/local/bin/samba-nsupdate ]; then
   ### FreeBSD ###
   echo ""
else
   echo ""
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
      FreeBSD)
         ### FreeBSD ###
         if [ -x /usr/sbin/pkg ]
            then
            {
            sudo pkg add -r samba4 samba-nsupdate
            }
         else
            sudo pkg_add -r samba4 samba-nsupdate
         fi
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
 
if [ $SKERBEROSINIT = /usr/bin/kinit ]; then
   # Kerberos installed
   echo ""
else
   echo ""
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
      FreeBSD)
         ### FreeBSD ###
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

/usr/bin/kinit $SKERBEROSADMINUSER

> $FILE
/bin/echo "server $SADSERVERNAME" >> $FILE
/bin/echo "zone $SADSERVERZONE" >> $FILE

/bin/echo "update delete $SADMACHINENAME. A" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL A $IPV4" >> $FILE

/bin/echo "update delete $SADMACHINENAME. AAAA" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL AAAA $IPV6" >> $FILE

/bin/echo "show" >> $FILE
/bin/echo "send" >> $FILE

### <--- --- ---> ###

echo ""

case $(uname) in
FreeBSD)
    ### FreeBSD ###
    /usr/local/bin/samba-nsupdate -g -v $FILE
    ;;
esac

exit 0
}
FREEBSDEOF
### ### ### ### ### ### ### ### ###

chmod 775 /tmp/do-nsupdate-freebsd.sh
exec /tmp/do-nsupdate-freebsd.sh
### --- --- --- --- --- --- --- ###
    ;;
Darwin)
    ### Mac ###
### ### ### ### ### ### ### ### ###
cat << 'MACEOF' > /tmp/do-nsupdate-mac.sh
#!/bin/sh
{
FILE="$HOME/do-nsupdate.txt"
CONFIG="$HOME/do-nsupdate.conf"
    
SKERBEROSADMINUSER=$(grep "KERBEROSADMINUSER" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINENAME=$(grep "ADMACHINENAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERNAME=$(grep "ADSERVERNAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERZONE=$(grep "ADSERVERZONE" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINETTL=$(grep "ADMACHINETTL" $CONFIG | /usr/bin/awk '{print $3}')
SINTERFACE=$(grep "INTERFACE" $CONFIG | /usr/bin/awk '{print $3}')

IPV4=$(ifconfig $SINTERFACE | grep "broadcast" | /usr/bin/awk '{print $2}' | head -n1)
IPV6=$(ifconfig $SINTERFACE | grep "autoconf" | /usr/bin/awk '{print $2}' | head -n1)
 
SKERBEROSINIT=$(which kinit)
### SADMACHINENAME=$(hostname -f)

case $(uname) in
Darwin)
    ### Mac ###
    ;;
*)
    # error 1
    echo "ERROR: Plattform=unknown"
    exit 0
    ;;
esac
 
### <--- --- ---> ###

/usr/bin/kinit $SKERBEROSADMINUSER

> $FILE
/bin/echo "server $SADSERVERNAME" >> $FILE
/bin/echo "zone $SADSERVERZONE" >> $FILE

/bin/echo "update delete $SADMACHINENAME. A" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL A $IPV4" >> $FILE

/bin/echo "update delete $SADMACHINENAME. AAAA" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL AAAA $IPV6" >> $FILE

/bin/echo "show" >> $FILE
/bin/echo "send" >> $FILE

### <--- --- ---> ###

echo ""

case $(uname) in
Darwin)
    ### Mac ###
    /usr/bin/nsupdate -g -v $FILE
    ;;
esac

exit 0

}
MACEOF
### ### ### ### ### ### ### ### ###

chmod 775 /tmp/do-nsupdate-mac.sh
exec /tmp/do-nsupdate-mac.sh
### --- --- --- --- --- --- --- ###
    ;;
Linux)
    ### Linux ###
### ### ### ### ### ### ### ### ###
cat << 'LINUXEOF' > /tmp/do-nsupdate-linux.sh
#!/bin/sh
{
FILE="$HOME/do-nsupdate.txt"
CONFIG="$HOME/do-nsupdate.conf"

SKERBEROSADMINUSER=$(grep "KERBEROSADMINUSER" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINENAME=$(grep "ADMACHINENAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERNAME=$(grep "ADSERVERNAME" $CONFIG | /usr/bin/awk '{print $3}')
SADSERVERZONE=$(grep "ADSERVERZONE" $CONFIG | /usr/bin/awk '{print $3}')
SADMACHINETTL=$(grep "ADMACHINETTL" $CONFIG | /usr/bin/awk '{print $3}')
SINTERFACE=$(grep "INTERFACE" $CONFIG | /usr/bin/awk '{print $3}')

IPV4=$(sudo ifconfig $SINTERFACE | grep "inet" | /usr/bin/awk '{print $2}' | head -n1 | cut -d ":" -f2-)
IPV6=$(sudo ifconfig $SINTERFACE | grep "inet6" | /usr/bin/awk '{print $2}' | head -n1 | cut -d "/" -f1)

SKERBEROSINIT=$(which kinit)
### SADMACHINENAME=$(hostname -f)

case $(uname) in
Linux)
    ### Linux ###
    ;;
*)
    # error 1
    echo "ERROR: Plattform=unknown"
    exit 0
    ;;
esac

if [ -f /usr/bin/sudo ]; then
   # Debian derived
   echo ""
else
   echo ""
   echo "Sudo Package not found..."
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
         ### Linux ###
         /bin/su root -c "apt-get install sudo"
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

if [ -f /sbin/ifconfig ]; then
   # Debian derived
   echo ""
else
   echo ""
   echo "ifconfig Package not found..."
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
         ### Linux ###
         sudo apt-get install ifconfig
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

if [ -f /etc/init.d/samba ]; then
   # Debian derived
   echo ""
else
   echo ""
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
         ### Linux ###
         sudo apt-get install samba dnsutils
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
 
if [ "$SKERBEROSINIT" == "/usr/bin/kinit" ]; then
   # Kerberos installed
   echo ""
else
   echo ""
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
         ### Linux ###
         sudo apt-get install krb5-user krb5-clients
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

/usr/bin/kinit $SKERBEROSADMINUSER

> $FILE
/bin/echo "server $SADSERVERNAME" >> $FILE
/bin/echo "zone $SADSERVERZONE" >> $FILE

/bin/echo "update delete $SADMACHINENAME. A" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL A $IPV4" >> $FILE

/bin/echo "update delete $SADMACHINENAME. AAAA" >> $FILE
/bin/echo "update add $SADMACHINENAME. $SADMACHINETTL AAAA $IPV6" >> $FILE

/bin/echo "show" >> $FILE
/bin/echo "send" >> $FILE

### <--- --- ---> ###

echo ""

case $(uname) in
Linux)
    ### Linux ###
    /usr/bin/nsupdate -g -v $FILE
    ;;
esac

exit 0

}
LINUXEOF
### ### ### ### ### ### ### ### ###

chmod 775 /tmp/do-nsupdate-linux.sh
exec /tmp/do-nsupdate-linux.sh
### --- --- --- --- --- --- --- ###
    ;;
*)
    # error 1
    echo "ERROR: Plattform = unknown"
    exit 0
    ;;
esac
   
exit 0

### ### ### PLITC ### ### ###
# EOF
