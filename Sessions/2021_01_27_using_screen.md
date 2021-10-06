### What is screen?

Screen allows a user to access multiple separate login sessions inside a single terminal window & detatch and reattach to sessions from a terminal. I like it because if I'm working in an interactive login session on Eddie and the VPN cuts out, if I'm using screen I can log back into Eddie and reattach to the screen session and find things still running.

It takes a bit of playing round to get used to which keys do what in screen, see [this guide](https://linuxize.com/post/how-to-use-linux-screen/) for starters.

Also see the [Eddie wiki](https://www.wiki.ed.ac.uk/display/ResearchServices/Interactive+Sessions), scroll down to "Reconnecting to your interactive session". 

____________________________________________________________________
### Example of using screen on Eddie:

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

I reccomend looking at the [link](https://linuxize.com/post/how-to-use-linux-screen/) above and playing about with all the keys until you get confident with using them. Please add any other useful resources you find to this doc.

___________________________

### Why use screen? 
If the VPN cuts out or you detatch from your session you can reconnect to the VPN and reattach to your session. If you've been on an interactive login node using R you'll find that your script has kept running. So without screen you would have to open R and run your script from the top, with screen you'll find it has kept running in the background.

______________________________
### Make note of your Eddie login node 
**IMPORTANT** You need to note what login node you are on when you use screen. It will say either `login01` or `login02` at the command prompt (the bit before your UUN and $ sign). When you log back into Eddie and want to reattach to your screen session you need to log back into whichever login node your screen session was on. 
eg. if I opened a screen session on `login01` then I would use the following to log back onto Eddie:

```
ssh s1211670@login01-ext.ecdf.ed.ac.uk
```

________________________________
### Link to screen cheat sheet with keyboard short cuts
https://gist.github.com/jctosta/af918e1618682638aa82



