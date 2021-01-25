## Using screen on Eddie

Screen allows a user to access multiple separate login sessions inside a single terminal window & detatch and reattach to sessions from a terminal. I like it because if I'm working in an interactive login session on Eddie and the VPN cuts out, if I'm using screen I can log back into Eddie and reattach to the screen session and find things still running.

It takes a bit of playing round to get used to which keys do what in screen, see [this guide](https://linuxize.com/post/how-to-use-linux-screen/) for starters.

The way I like to use it on Eddie is:

1. ssh into Eddie
2. Start a screen session eg:

	```
	screen -S new-session
	```

3. Now there's the option of having a session on a staging node, an interactive login session, a normal login session all in multiple windows that you can switch between or have tiled on one screen. There's lots of options and it's up to you what suits you best for what you're trying to do.

To open a new session: `ctrl + a` & `crt + c`.

Login to an interactive session and open R:
```
qlogin -l h_vmem=4G
. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.1
R
```

Tile the terminal so the top tile is the command line in Eddie and the bottom tile is R:

* `ctrl + a` + `S`, this splits the screen.
* `ctrl + a` + `tab`, cycles between tiles, here this moves us to the bottom tile. 
* `ctrl + a` + `n`, cycles through all our screen sessions. We only have 2 screens so here it gives us the Eddie command line.


I reccomend looking at the link above and playing about with all the keys until you get confident with using them.



