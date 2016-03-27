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

NB: If you are using VPE on a system that doesn't contain Kernel and Fileman,
you will need the routine ZU for your platform. This is a temporary need only;
it will be fixed in a future version.

## Using VPE
To enter VPE, type `D ^XV`. The VPE manuals can be found here: http://hardhats.org/tools/vpe/vpe_db.html.

## Changes for VPE from 12.0 to 13.0
NB: Authors are noted as Sam Habiel (SMH), David Wicksell (DLW) and Rick Marshall (FDSM).

 * VPE has been renamedspaced from VEE, ZVE, and %ZVE to XVV and ZVE (Most done
   by DLW; SMH did the % Routines renamespacing; SMH refactored all of the code
   embedded in the %ZVEMS Globals into routines starting with XVS. All 
   renamespacing done via rename, mv, and sed Unix Commands.)
 * New system QWIK: ZINSERT called via ..ZI. Allows you to paste an entire
   routine in. (Author: DLW for GT.M; Cache Support and bug fixes: SMH).
 * Error traps refactored to use ZU temporarily in order to avoid setting $ZTRAP
   which causes system crashes when mixed with $ETRAP. (FDSM). This change
   will be eventually rolled back to use the VPE native error traps with $ETRAP.
 * Remove install question about Manager UCI. This is installed in a user namespace now. (SMH).
 * Remove warnings about Global Protection. This is installed in a user namespace now. (SMH).
 * Cache is listed as a supported system when installing (SMH).
 * Automatic installation of VPE if it is not already installed (SMH).
 * Main Error Trap for VPE is now fixed permanently to prevent crashes (SMH).
 * Like MSC Fileman, ask for DUZ or User Name rather than Access Code on first
   start if VISTA is installed (SMH).
 * Automargin code for Cache and GT.M. Any full screen editor or viewer will
   automatically take up your whole terminal screen. You are no longer limited
   to 80 x 24. Previously, you could change that using your parameters. Now,
   it is automatically resized for you (SMH). Automargin code was redone by SMH 
   from work by George Timson in a %ZIS3 posted on the Hardhats Google Group.
 * GT.M Save Routines is very robust now and should never fail; however, it
   will always save to the first directory in $ZROUTINES even if the routine was
   loaded from another directory; unlike the native "ZED" editor behavior. This
   still needs to be fixed. Code taken from Kernel-GTM project. (SMH).
 * Routine name size is unlimited (SMH; with help from Lloyd Milligan from his
   website); previously, it was limited to 8 characters.
 * XINDEX invocation from Routine editor is now fixed (SMH).
 * VGL was blocked from Routine editor if user doesn't have DUZ(0)="@", even
   though VGL can be invoked independently by the same user. This block was
   removed (SMH).

## Authors for version 13.0:

 * David Wicksell
 * Sam Habiel

## License
Original VPE license still applies. See LICENSE file.
