## Authors for version 15.2
Sam Habiel (SMH) & David Wicksell (DLW)

## Summary of Changes for 15.2
- In ..E/..VRR, provide a dynamically updated [TAG+OFFSET^ROUTINE] display
- First line routine format update to comply with latest SAC
- Syntax Higlighting Caché Terminal Support and bug fixes
- XINDEX now indexes buffer copy, not saved copy, of routine
- Prompt (>>) does not get to timeout anymore
- ESC-G/VGL Fixes/Improvements
- ESC-R fixes
- UPGRADE^XV for automated upgrade of VPE between versions

## Changes for version 15.2
Changes WITHOUT * have Integration Tests. Numbers after \# indicate
that the change fixes a Github issue with that number.

- The VA SAC recently (in 2018) been updated to require that the first line
  date be in a certain format. VPE now compiles with that format (SMH) (#46).
- Error messages now say to create an issue on the Github issue tracker.
  Previously, it directed people to email David Buldoc (DLW) (#42).
- In the help text of ..E/..VRR, %INDEX should be XINDEX; now fixed (DLW).*
- In ..E/..VRR tab menu, prevent typed text from overflowing into the menu
  options (DLW).
- Dynamically resize the ..PARAM menu whenever changes are made to the Screen
  Width or Length. Previously, the ..PARAM window was resized only when
  entering ..PARAM (DLW).*
- Routine selection for GT.M/YottaDB didn't work if VistA is not present. Now
  we have default code that runs for GT.M/YottaDB (DLW).
- On Caché/Any OS, backspacing to the first column caused the syntax
  highlighting code to crash. This is now fixed (DLW) (#47).
- Caché Windows-only Caché Terminal has a buggy VT-100 emulation, and doing
  syntax highlighting when scrolling using the up/down buttons bled the colors
  up/down, rather than moving the colors with the text. On this terminal
  emulator ONLY, we compensate by redrawing the screen on up/down scrolling
  (DLW) (#48).
- In ..E/..VRR, the [Routine Name] display at the top of the routine window has
  now been replaced with [TAG(+offset)^Routine Name], which is dynamically
  updated when the cursor moves around in the routine (DLW).
- When the routine editor crashes, remove all locks (SMH).
- Integration Testing Framework Updates (all SMH):
    - Switch from Python 2 to Python 3, in anticipation of Python 2 deprecation
      in 2020.
    - Use the OSEHRA Automated Testing Framework directly from the OSEHRA repo
      rather than a copy.
    - Require M-Unit for Testing. XVEMREP now includes a TEST^XVEMREP which is
      run the integration test to test Global Parsing inside of VPE.
- Error trap unwind for the Routine Editor wasn't unwinding properly, resulting
  in user pressing enter multiple times to allow you to exit from the error
  condition. Now, only a single enter is needed (SMH).
- XINDEX now indexes the buffer copy of the routine, not the saved copy as
  historically (SMH) (#36).
- Fix namespace issues/symbol table leaks identified by XINDEX in these
  routines: XVEMKP, XVEMSRL, XVEMT{F,S,T,U}, XVEMRID, XVEMRLI, XVEMSQS (SMH)
  (#45)*.
- Prompt (>>) does not get to timeout anymore. Previously, leaving VPE
  unattended for a while caused the prompt to print repeatedly after each
  timeout, with previous output scrolling off the screen (SMH) (#49)*.
- ESC-G Fixes (all SMH):
    - In the last few versions of VPE, if a 0 was present at the end of a
      global, it was removed in the expression sent to VGL. That was because
      we typically wanted to see the other nodes besides 0. With the addition
      of the feature in 15.1 of being able to parse the global up to each
      comma of the global expression, this feature is no longer useful and
      can be confusing. It has now been removed. (#53).
    - If a global had a number in its name, ESC-G failed to parse it (SMH) (#44).
    - If a variable was found at the end of the expression, the expression was
      not terminated correctly. For example, ^TMP($J,"PSOCP",DFN) did not
      terminate parsing after DFN correctly.
    - In earlier versions of ESC-G, we parsed to the terminating parentheses
      but did not include the parentheses. With the addition of the feature in
      15.1 of being able to parse the global up to each comma of the global
      expression, we don't need to do that anymore, and now include the
      parentheses for the expression. If the user wants to see the nodes under
      where the global expression terminates, they can use the comma feature.
      The major reason for this change is to make ESC-G intuitive in its
      semantics.
    - ESC-G now comes with M-Unit Tests to test the parser. M-Unit 1.6 or later
      is required and can be downloaded from here:
      https://github.com/ChristopherEdwards/M-Unit/releases
- ..VGL fixes (all SMH):
    - In 15.1, we added the feature to display input to VGL, i.e. the global
      expression being viewed. We found out that VPE internally sometimes adds
      closing parentheses to the expression, and thus what is being displayed
      no longer reflects what the user actually typed in. This is now fixed.
      (#52).
    - With the same change in 15.1, sometimes the top line (======) wrapped.
      This is now fixed.
- ESC-R since v14.0 has had issues with lines that wrap around. This has now
  been fixed (SMH) (#41 & #43).
- UPGRADE^XV Entry Point automated the VPE upgrade process when installing a
  new version. Previously, the upgrade process involved a series of manual
  steps (SMH) (#50).
- RESET^XV Entry Point deletes all of the VPE globals and files (SMH).
- Messages displayed by XVEMBLD when installing VPE now have been updated to
  refer to UPGRADE^XV and RESET^XV for upgrade and uninstall instructions (SMH).

## Authors for version 15.1
Sam Habiel (SMH) & David Wicksell (DLW)

## Changes for version 15.1
Changes with * have Integration Tests.

- Code to save routines is now VPE's own built in code. Previously code to save
  routines was obtained from Fileman if it is installed. This was found because
  Fileman had a bug in saving % routine on GTM/YDB. Use of Fileman in preference
  to VPE is not in accordance with VPE's VistA indepdendent philosophy.* (DLW)
- Due to a bug in how a logical condition apropos De Morgan's Law, ZLINK was
  not invoked on GTM/YDB when saving a routine. This bug was introduced in
  v13.0; the code was correct in v12 (the pre-XV version).* (DLW)
- If a routine contained over 999 lines, the line counter at the top didn't
  show the number correctly. This is now fixed.* (test not active as it takes
  too long to run) (DLW)
- Syntax highlighting parameters have been improved: ESC key aborts changes;
  selected colors can be seen in real time while selecting them.* (DLW)
- Parameter selection for width and height are limited at the lower bound of
  80 x 24 as the routine editor is glitchy with a lower selection.* (DLW)
- Previously VPE had a facility for automatically stripping spaces, but only
  when the backspace key was pressed. This interfered with Syntax Highlighting;
  so this feature was removed; this aside from the fact that this behavior is
  very counterintuitive and undocumented. Future enhancements may add stripping
  of trailing spaces when saving a routine. (DLW)
- General improvements to Syntax Highlighting code introduced in 15.0. (DLW)
- New features and bug fixes of ESC-G to from 14.0: (SMH)
    - As previously ESC-G at ^ will get you the full global reference until the
      ending parentheses.*
    - ESC-G at the opening parentheses will display the global data under the
      global name only.*
    - ESC-G at any comma of the subscripts will get you the global up to the
      subscripts before the comma.*
    - Fixed help text for ..E/..VRR to describe how to use ESC-G with these
      changes.
    - (bug fix): ESC-G resolves $ expression (ISVs, intrinsic functions, or 
      extrinsic functions) inside of global references. $J is kept, anything
      else is discarded.*
    - (bug fix): Expressions with nested parentheses inside a global reference
      (e.g. `$P($G(RXFL(RX)),"^",0)`) are discarded correctly.*
    - In all the above cases, ESC-G tries to substitute any expressions or
      variables (with the exception of $J as mentioned above) with the
      continuation character (:) when sending the input into ..VGL.*
- Removed upper limit on ID. Previously, in VistA instances such as the CPRS
  Demo (aka VEHU), you couldn't log-in with users with DUZ in the billions
  because VPE did not allow that. Fixes Issue #23.* (SMH)
- Upgrade and Uninstall instructions printed to the user upon installation were
  not correct. They are now fixed. (SMH)
- Tell user about old VPE if it is installed during installation.* (SMH)
- Branched to routines didn't ZLINK when saved because they did not use the
  correct entry point for saving. This is now fixed.* (SMH)
- Prevent ESC-ESC from exiting the routine save dialog. This is contrary to
  VPE philosophy, where all dialogs are escapable using ESC-ESC. However, in
  this specific case, many new users held the ESC key for too long when trying
  to save a routine, with the result that they lost the routine when they
  escaped from the save dialog. Fixes Issue #29.* (SMH)
- Remove VGL/VEDD drill down restriction. If you invoke VGL or VEDD from the
  Menubar from ..E/..VRR after having branched down two routines, you were
  prevented. Fixes #39. (SMH)
- In VGL, display global references being shown next to the session number; and
  show the global if we are telling the user that there is no data. These
  improvements were made to address the fact that ESC-G in the routine editor
  auto-resolved what global it was by substituting variables, but it was not
  obvious to the end user what did ESC-G finally select as the global to
  search.* (SMH)

Notes from DLW regarding Syntax Highlighting and catching errors in code:

  I made a decision not to try to catch every error, but just the main, obvious
ones, and only if I could do so without significantly complicating the code.

  With this code, I have to balance how strict the parsing is, with
performance. If I add really strict parsing logic, and try to make it
into basically a reference grammar parser for MUMPS, then it probably
will not run fast enough for an editor. That's not to say that making it
much more strict, and keeping good performance is impossible, just that
it would be hard.

  For example, I chose to be pretty strict with commands, so that it is
good about flagging errors for commands that don't exist (except for
ones that start with a Z, which I basically leave alone). But, for
intrinsic functions and ISVs, I didn't do that. It only checks to make
sure they follow the rules for identifiers from the standard, but not
that they are a function or ISV that exists. I was planning a future
upgrade to improve the error highlighting of the code, but wanted to get
something out there that was useful, and performed well enough that
people would enjoy using it.

  So, to summarize, the syntax highlighter should always color all
syntax elements correctly, and it should never flag as an error, valid M
syntax (all bets are off if you use ISC extensions like COS). But it
isn't going to catch every error, though I'm hoping to improve that over
time. So if you try to abuse it, you'll be able to find
less-than-perfect results.

## Authors for version 15.0
David Wicksell

## Changes for version 15.0
Changes with * have Integration Tests.

- Syntax Higlighting in editor and viewer (not turned on by default; go to ..PARAM to turn it on).*
- Add <END> key support for YottaDB/GT.M on Linux.
- Fix rare bug with routine branching support that would cause a crash.
- Fix routine size support for YottaDB/GT.M on Linux. Previously, it was CACHE/DSM/MSM only.*
- Add new shell parameter documentation for screen sizing.*
- Add enhancements to auto margin screen handling in ..PARAM: Display current size,
  allow going back to auto-size by typing in zero, resize ..PARAM display with
  new size when entering a new size.*


## Authors for version 14.1
Sam Habiel
Kevin Toppenberg

## Changes for version 14.1
- Code implementing backspace/delete dichotomy in VPE parameters did not work
correctly. This is what Kevin found and fixed.
- Fileman files automatically installed without any questions being asked when
you run VPE via ^XV.
- Relicensing code to Apache 2.0.
- Tiny changes here and there to please XINDEX. Almost all of VPE now passes
  XINDEX.

## Authors for version 14.0
Sam Habiel

## Changes for version 14.0

### MUMPS V1 Support

This release adds a new supported M implementation to VPE, that of Mumps V1.
Mumps V1 must compiled from source with the SAMTERM define set to 1. You will
need to edit the mumps.h to do that (search for SAMTERM). This changes Read
terminator behavior in MV1 to be consistent with what VistA expects.

### Bug Fixes (and minor enhancements)

#### Editor
- Routine names > 8 chars print fully on top of buffer
- ESC-R now hows to how handle long tags and long routines names (> 8 char)
- ESC-R now can jump to labels, not just [label]^routine.
- Don't warn if a routine contains a long label (> 8 chars)
- ..VRR QWIK can now take a tag of the shell like ..E (e.g. `..VRR XUSRB CVC`).
- ESC-G now displays globals from the editor. This is not exactly new functionality, but apparently it hasn't worked for a while now.
- Routine editing lock was not removed after routines were edited for the first level of routine editing.

#### Other
- VPE error trap now tells you where the error happened using $ST(-1).
- New routine creator should not have an 8 char limit for routine name.
- ..LOCKTAB QWIK implementation for GT.M
- ..DOS QWIK (zsystem) implementation for GT.M


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

## Changes for version 13.1

 * Automargin outside of screen operations is fixed
 * Unused routines removed (old editor and timeout screensaver routine)
 * All error traps are M95 standard and use VPE code to teardown data structures
 * Routine search (RS from Editor) now works on GT.M, not just DSM variants (used to rely on ZLOAD).
 * QWIK arguments should not be uppercased (e.g. '..e test' edited the routine TEST, which is not appropriate)

## Authors for version 13.1

 * Sam Habiel

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


## Version 12.5  2009/12/09 00:57:41  vpe (FWS/DLW)

Added a new entry point to VPE, via calling a 
routine from a shell (mumps -r XV), or in GT.M
Direct Mode (D ^XV). Also sets up environment.
Sam Habiel donated the following 11 routines,
which comprise the code found in ^%XVEMS.
XV.m, XV.m, XVRCE.m, XVRSE.m, XVSA.m, XVSC.m,
XVSK.m, XVSO.m, XVSQ.m, XVSR.m, XVSS.m, XVST.m

Added a new system QWIK, called ZInsert. Called
as ..ZI from VSHELL. It simulates some of the 
functionality of ZInsert in Caché, allowing
programmers to copy a routine from their development
environment and paste it into VPE in the shared
environment elsewhere. It does not, however, allow
you to have the full functionality of a routine 
buffer, yet.

Fixed multiple bugs in VPE code...

## Version 12.4  2009/11/13 18:13:08  vpe (FWS/DLW)
changed namespace
The great namespace shuffle.

as per SAC, renamespacing VPE from VEE*, 
ZVE*, and %ZVE* to XVV*, XVE*, and %XVE*. There 
were no conflicts. They were done for routine
names, and contents of all routines, and
globals. I ran a script I wrote called
convert2XV.sh, which will be here for this 
revision only. It is a one time process.
I had to reinstall VPE, by running ^XVEMBLD
and then for Fileman, ^XVVMINIT. 

## Version 12.3  2009/08/25 22:04:31  vpe checkpoint (FWS/DLW)

NB: ven/smh - removed!! VPE shouldn't change fileman code.
fws/dlw:
added a global set for ^DD("OS",19,"ZS") and
changed ^%ZVEMS to include Rick's error code

## Version 12.2  2009/08/21 22:43:23  vpe (FWS/DLW)
fws/dlw:
remove dead lines and add save in first piece
Note: The $ZRO in the ci message was replaced
      with nothing. The first $ZRO piece is
	  used by ZSAVE^%ZVEMKY3 as the target.

## Changes for VPE from 11.0 to 12.0
Author: Dave Bolduc/Brian Lord
Initial GT.M Support.

Support for non-standard sized terminal windows.

## Changes for VPE from 10.0 to 11.0
Author: Dave Bolduc
 
### Routine Editor
#### Versioning 
The Library module has been enhanced to include versioning. When you edit a routine and save your changes, you will be prompted to create a version of the routine. You can create a new version or update an existing version. The version is stored in the VPE Version file and can be restored at anytime via the ..LBRY menu. Read the Help option in system QWIK ..LBRY for more information.
#### Saving Code To The Clipboard
The editor's Cut/Copy/Paste functions have been enhanced to allow you to copy a portion of a line of code to the clipboard and paste it back in at a different location.

Hit \<F3\> to put the editor into Block mode. Hit \<AU\> or \<AD\> to highlight lines of code, and \<AL\> or \<AR\> to highlight characters of code. When highlighting characters of code, you may only highlight characters from a single line, excluding the line tag.

\<ESC V\> will paste the code to the new location of the cursor, but it will do it differently depending on whether the clipboard has lines or characters of code. If you're pasting lines, the new lines will be inserted below the line the cursor is currently on. If you're pasting characters, the characters will be inserted into the current line at the point where the cursor is located. If you are in Block mode and have highlighted some code, \<ESC V\> will replace that code with the contents of the clipboard.

While in Block mode, hit \<HOME\> to highlight lines from the cursor to the top of the routine, and \<END\> to highlight lines from the cursor to the bottom of the routine.

Here is a summary of keys used to Cut/Copy/Paste:

| Shortcut Key  | Action                                                          |        
| ------------- | --------------------------------------------------------------- |
| \<F3\>        | Turn Block mode on & off.|
| \<AU\> \<AD\> | Highlight lines of code.|
| \<AL\> \<AR\> | Highlight characters of code.|
| \<DEL\>       | When Block mode is on, delete highlighted lines/characters.|
| \<ESC C\>     | Copy highlighted code to the clipboard.|
| \<ESC D\>     | Block mode off - Delete current line.|
|               | Block mode on - Delete highlighted lines/characters.|
| \<ESC X\>     | Cut highlighted code to the clipboard.|
| \<ESC V\>     | Paste code from the clipboard into the routine.|
|               | 0 Lines will be inserted below the current line.|
|               | 0 Characters will be inserted into the current line.|
|               | If you are in Block mode when you hit \<ESC V\>, highlighted|
|               | code will be replaced by the contents of the clipboard.|
| \<HOME\>      | Highlight from the cursor to the top of the routine.|
| \<END\>       | Highlight from the cursor to the bottom of the routine.|

#### Find Tag
The Find Tag option on the editors menu bar has been enhanced. It now lists all line tags in the routine and allows you to select a tag and move to it. While in the editor, hit <TAB> to go to the menu bar and then type F for Find Tag.

#### NoDt
 In previous versions of VPE, you could set the variable VEENODT =1 to tell the editor not to update the date on the top line of the routine when you saved your changes. This allowed you to make temporary changes to a routine for testing purposes and then remove the changes and restore the routine back to exactly the way it was before. However, you did have to remember to set VEENODT and also to KILL the variable when your editing was done. Using this variable is no longer necessary. Now, when you exit an editing session, you are prompted with:

```
   QUIT  SAVE  SAVE_AS  SAVE_NODT
```

Choose SAVE\_NODT to save your changes without updating the date on the top line.

#### Routine Search
To reach the Routine Search module, hit \<TAB\> to move to the menu bar and then type RS. This module allows you to list all routines edited on, before, or after a certain date by entering the search criteria in the following syntax:
```
                  <10/12/00        Find all routines edited before Dec 10, 2000.
                  >10/12/00        Find all routines edited after Dec 10, 2000.
                  =10/12/00        Find all routines edited on Dec 10, 2000.
```
This functionality stopped working when the year became 00. It has been fixed and now supports the year 2000.

#### Inserting a New Line of Code
To insert a new line of code in the editor, hit \<RET\> to open a blank line. It doesn't matter where your cursor is positioned when you hit \<RET\>, it will always open a blank line just below the line your cursor is on.

Once you've opened a blank line you either hit \<TAB\> and start entering your code, or type a line tag and then hit \<TAB\>. If you hit \<RET\> again before you enter any code (or \<BS\>), the blank line will close. From the time you hit \<RET\> to open a blank line, and the time you hit \<TAB\>, the editor is in a special mode where it is trying to determine whether you've entered a valid line tag. This special mode has been changed slightly.

If you entered some code and then hit \<RET\> before hitting \<TAB\>, you used to get a message saying that a line tag must be followed by a \<TAB\>, and it would keep you right there. This has been changed. If you enter some text on a blank line and then hit \<RET\>, the editor goes ahead and puts the \<TAB\> there for you and then continues on as if you had entered the \<TAB\>. Like before, it then checks the tag to make sure it is valid.

### VEDD (Electronic Data Dictionary)
#### Keys & Indexes
In VEDD's main menu, the Cross References option has been changed to Keys & Indexes. It now includes sections for Keys, New-style Indexes, and Old-style Indexes. Keys and new-style indexes were introduced in Fileman version 22.
#### Individual Field Summary
Information on Keys and New-style Indexes has been added to the Individual Field Summary display. In addition, text now displays with a more natural appearance, making fields such as the DESCRIPTION field easier to read.

### VPE (Programmer Shell)
Fixed a bug in System QWIK ..KEYS.

Added routine VEEMVPE, which allows you to edit the VPE PERSON file with a Screenman form.

## Changes for VPE from 9.0 to 10.0
Author: Dave Bolduc

 * Selector: Embellished. If you don't know what the Selector is, you can ignore this or become so curious you are forced to seek it out.
 * Editor Changes: 
     * Type \<esc\>= to add a line of '=' characters as a text separator.  The same behavior is true for \<esc\>\_ and \<esc\>-.
     * The format of the date affixed to the top line of a routine has changed.
     * Using the RS command now lets you type >6/5/99 to find all routines edited after 6/5/99 (this makes it work with the new date style).
 * Bug fixes: misc fixes.
 * Editor and Routine Reader: If you use <esc>R to jump to a routine referenced in the code, it will load the referenced routine and move to the line label in the reference.  For instance, presume D TEST^XYZRTN is contained in the routine on the screen.  Placing the cursor on the ^ and pressing <esc> then R will load up the XYZRTN and start the display at line TEST.
 * Routine Lister: Type ..RL and select some routines. It lists them in a single column list format, or a block format using 8 columns across. You can also enter a number (for example 2) and it will display in list format the number of lines you entered. If you entered 2, it would display the 1st and 2nd lines of each routine selected.
 
