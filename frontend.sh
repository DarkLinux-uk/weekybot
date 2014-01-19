#!/bin/bash
# Probably works with other shells too, not tested

#
#  Weekybot v0.1 frontend
#
#  Copyright William Hales 2014
#

#  This file is part of Weekybot
#
#  Weekybot is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Weekybot is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Weekybot.  If not, see <http://www.gnu.org/licenses/>.


# Very hacky:
#  * written by someone with little IRC protocol knowledge
#  * uses lots of sleeps
#  * probably doesn't handle IRC events/problems


port=6667
server="irc.freenode.net"
channel="unvanquished-dev"
nick="regnarg"


which ii &> /dev/null

if [ $? -ne 0 ]
then
	echo "Can't find ii.  http://tools.suckless.org/ii/"
	echo "ii is the irc backend for the python middle-end"
	exit 1
fi


execdir="$(pwd)"
if ( ls | grep -q 'middleend.py' )
then
	# All good
	:
else
	echo "Can't find middleend.py"
	echo "Please execute me from my dir"
	exit 2
fi
	


workingdir="/tmp/Weekybot${RANDOM}"
mkdir $workingdir
cd $workingdir

# IRC backend
ii -s $server -n $nick -p $port -i . &
iipid=$!

cleanup()
{
	echo
	echo "Recieved a signal.  Leaving server and cleaning up"
	
	echo '/quit' > ${workingdir}/*/in
	sleep 5
	
	rm -r "${workingdir}"
	exit 0
}
trap 'cleanup' 1 2 3 6  # TODO: refine signal list


## Main block
echo -n "Connecting to ${server}... "
while [ $(ls | wc -l) -eq 0 ]; do sleep 1; done
echo 'done'

cd $server
#sleep 1 # Neccesary?

echo -n 'Waiting for +i... '
until ( grep -q 'End of /MOTD command' out ) do sleep 1; done # freenode specific?
echo "recieved"

echo "/join #${channel}" > in
echo -n 'Waiting to confirm channel join... '
until ( ls | grep -q "$channel" ); do sleep 1; done

cd "#${channel}"

until ( grep -q "has joined" out ); do sleep 1; done
echo 'done'

echo -e '(Running the middleend script)'
${execdir}/middleend.py > in &


# Rudimentary response capability
tail -f -n1 out | while read line
do
	if ( echo $line | grep -qi "<${nick}>" )
	then
		# Don't respond to my own chat!
		# This could end in infinite loops		
		:
	elif ( echo $line | grep -qi "${nick}:")
	then
		if ( echo $line | grep -qi "force")
		then
			${execdir}/middleend.py once > in
		else
			echo "\"${nick}\" is weekybot, an IRC bot that periodically scrapes mediawiki atom feeds for changes." > in
			echo "Ask me to 'force' if you want an update right now. See https://github.com/Veyrdite/weekybot for more details" > in
		fi
	fi
done



