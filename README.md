weekybot
========

IRC bot that periodically scrapes mediawiki atom feeds for changes.  Designed for http://unvanquished.net/wiki and use on the freenode channel #unvanquished-dev

Overview
--------
frontend.sh
 * sets up IRC connection
 * runs middleend piped to irc

middleend.py
 * harvests atom feed
 * generates text
 
backend (IRC client) is ii 
 * http://tools.suckless.org/ii/

How-to
------
Deps:
* any *nix-like platform
* Python feedparser http://pythonhosted.org/feedparser/
* ii http://tools.suckless.org/ii/


To-do
-----
* Make the front-end listen for questions & print URL + license of project
* Add colour
* Determine remaining contribution types to mediawiki
