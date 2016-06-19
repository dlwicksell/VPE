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
To enter VPE, type `D ^XV`. The VPE manuals can be found here: http://hardhats.org/tools/vpe/vpe_db.html.

## Changes for VPE from 12.0 to 13.0
NB: Authors are noted as Sam Habiel (SMH) and David Wicksell (DLW).

 * VPE has been renamedspaced from VEE, ZVE, and %ZVE to XVV and ZVE (Most done
   by DLW; SMH did the % Routines renamespacing; SMH refactored all of the code
   embedded in the %ZVEMS Globals into routines starting with XVS. All 
   renamespacing done via rename, mv, and sed Unix Commands.)
 * New system QWIK: ZINSERT called via ..ZI. Allows you to paste an entire
   routine in. (Author: DLW for GT.M; Cache Support and bug fixes: SMH).
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

## Changes for version 13.1

 * Automargin outside of screen operations is fixed
 * Unused routines removed (old editor and timeout screensaver routine)
 * All error traps are M95 standard and use VPE code to teardown data structures
 * Routine search (RS from Editor) now works on GT.M, not just DSM variants (used to rely on ZLOAD).
 * QWIK arguments should not be uppercased (e.g. '..e test' edited the routine TEST, which is not appropriate)

## Authors for version 13.1

 * Sam Habiel

## Changes for version 13.2
 
 * Routine editor will clear $EC when it starts. Previously, having an active
   error aborted the save, potentially leading you to lose the changes you made.
 * Now can have up to 1024 routine buffers open. Previously, the limit was 4.
 * V13.0 introduced a bug where VPE does not remember your previous routine
   name. This was due to a check on a global that was removed. This check
   itself was removed and now VPE remembers the last routine you were editing.
 * At the first column, you can now insert a space in addition to a tab. A
   space in the first column will behave the same as the tab, advancing the
   cursor to the line body from the label line. Previously, only a tab was
   allowed. A pleasant side effect of this is that correctly formatted M code can
   be directly pasted into VPE.
 * ZR QWIK (ZREMOVE) now deletes routines on GT.M. Previously, it only worked
   on DSM variants.
 * Two changes for Routine Search:
 ** Routine Search was prevented from running if you were 2 levels down in the
    routine editor. This restriction has been removed.
 ** RSEARCH QWIK invokes VPE's native (and superior!) routine search rather
    than the one provided by the M implementation.
 * E QWIK or VRR QWIK (Edit/Read Routine) when invoked with invalid routine
   names (such as a routine called "&") when into an infinite loop and
   overflowed the stack. This has been fixed. This has nothing to do with 13.1's
   error code fixes; rather it's a GOTO gone wild in the original VPE code.
 * Standalone VPE now just asks for User ID only. Previously, it asked for your
   DUZ as well, which didn't make any sense in a non-VISTA context.

## Authors for version 13.1

 * Sam Habiel

## License
Original VPE license still applies. See LICENSE file.
