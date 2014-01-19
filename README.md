weekybot
========

IRC bot that periodically scrapes mediawiki atom feeds for changes.  Designed for http://unvanquished.net/wiki and used on the freenode channel #unvanquished-dev

Overview
--------
frontend.sh
 * sets up IRC connection
 * runs middleend piped to irc
 * rudimentary responses

middleend.py
 * harvests atom feed
 * generates text
 * run with the opt 'once' to avoid it looping
 
backend (IRC client) is ii 
 * http://tools.suckless.org/ii/

How-to
------
Deps:
* any *nix-like platform
* Python feedparser http://pythonhosted.org/feedparser/
* ii http://tools.suckless.org/ii/

Configurate by editing the two source files.  Useful variables are near the top.

Ensure you don't run the script without first changing the server, channel and nick details!  If you _do_ make this leviathic mistake: make sure you personally join #unvanquished-dev, apologise to Veyrdite, join in the conversation and try out the game.  Fail this at your own risk: the gods of IRC will make all your PONGS tremble with latency.

Other notes
-----------
Python seems to report pipe breakages occasionally.  I don't know what's causing this (ii recreating its fifos?) but it seems to be harmless.  The bot still keeps working as per normal.

To-do
-----
* Add regexps for remaining undiscovered mediawiki contributer actions
