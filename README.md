# Victory Programming Environment (VPE)

This is an updated version of VPE from the last version released by David
Bolduc. David Bolduc passed away in 2013.

The home page of VPE is http://hardhats.org/tools/vpe/vpe_db.html.

## Installation
Go to the releases page, and download the latest VPE.RSA file:

https://github.com/shabiel/VPE/releases.

Load this in with you M Implementations Routine Input utility, and then type
in Programmer Mode `D ^XV`

This command both starts VPE and installs it for the first time if it is not
already installed.

VPE does not rely on VISTA or RPMS being installed. You can use a lot of its
functionality without VISTA or RPMS. Anything Fileman related will not work if
Fileman isn't installed.

## Using VPE (Brief User Manual)
To enter VPE, type `D ^XV`.  An online manual can be
found by just typing '?' when at the '>>' VPE prompt. 

VPE has its own CHUI Windowing system. To get out of any windows, type 'ESC',
'ESC'... that is, two escapes in a row. That's the only shortcut key you really
need to remember.

The VPE manual can be found here:
http://www.pioneerdatasys.com/hardhats/VPEUSER.pdf. Since the original VPE
manual has been written, VPE has been moved to XVEM from %ZVEM or ZVEM.
Therefore, any references to %ZVEM or ZVEM should be changed to XVEM.

## Changes
The entire change history from version 9 to the current version can be found
[here](Changes.md).

## License
The VPE is now licensed under Apache 2.0. See [LICNESE](LICENSE) for more details.

## MV1 support
This section is for Sam, the maintainer. You can ignore it:

What's left for supporting MV1 is the following:
- Error trap unwind doesn't work b/c of a bug in MV1 --> PUT A BANDAID!
