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
nick="Weekybot"


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

echo -n "Connecting to ${server}... "
while [ $(ls | wc -l) -eq 0 ]
do
	sleep 1
done
echo 'done'

cd $server
sleep 1

echo -n 'Waiting for +i... '
until ( grep -q 'End of /MOTD command' out ) # freenode specific?
do
	sleep 1
done
echo "recieved"

echo "/join #${channel}" > in
echo -n 'Waiting to confirm channel join..'
until ( ls | grep -q "$channel" )
do
	sleep 1
done

cd "#${channel}"

until ( grep -q "has joined" out )
do
	sleep 1
done

echo -e '\n Starting middleend script...'
${execdir}/middleend.py > in &
pidmiddle=$?


sleep 99999

cleanup

