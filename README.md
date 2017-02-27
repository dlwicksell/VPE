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

VPE does not rely on VISTA or RPMS being installed. You can use a lot of its functionality without VISTA or RPMS. Anything Fileman related will not work if Fileman isn't installed.

## Using VPE
To enter VPE, type `D ^XV`. The VPE manual can be found here: http://www.pioneerdatasys.com/hardhats/VPEUSER.pdf.

## Changes
The entire change history from version 9 to the current version can be found [here](Changes.md).

## License
Original VPE license still applies. See LICENSE file.

## MV1 support
This section is for Sam, the maintainer. You can ignore it:

What's left for supporting MV1 is the following:
- ESC ESC doesn't work --> FIXED.
- Error trap unwind doesn't work --> PUT A BANDAID!
- Autoresizing terminal sometimes works, but most times not --> FIXED.
- OS utilities in ^XVEMS shortcuts --> FIXED.
- Routine listing (?? on ..E) doesn't work --> FIXED.

