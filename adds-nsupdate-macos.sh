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
### list of conditions and the following disclaimer.
###
### * Redistributions in binary form must reproduce the above copyright notice, this
### list of conditions and the following disclaimer in the documentation and/or
### other materials provided with the distribution.
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

KERBEROSADMINUSER="administrator"
### KERBEROSADMINPW=""

ADSERVERNAME="dc.domain.tld"
ADSERVERZONE="dc.domain.tld"
ADMACHINETTL="3600"

ADMACHINENAME=$(hostname -f)
IPV4=$(ifconfig | grep "broadcast" | /usr/bin/awk '{print $2}' | head -n1)
IPV6=$(ifconfig | grep "autoconf" | /usr/bin/awk '{print $2}' | head -n1)

FILE="adds-nsupdate.txt"

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

/usr/bin/nsupdate -g -v $FILE

### ### ### PLITC ### ### ###
# EOF
