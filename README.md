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

## Upgrade
There is no automated way to upgrade VPE right now. Here are the instructions
to upgrade:

 1. Merge User QWIKS from ^XVEMS("QU") to a scratch global
 2. Make sure all users have halted off VPE Shell
 3. Delete routines XVEM*, XVS*, XVVM*, and XV
 4. Kill global ^XVEMS
 5. Load VPE_XXPX.RSA routines from the disk
 6. Do ^XV to install and start VPE
 7. Merge Saved user QWIKS from scratch global to ^XVEMS("QU")
 8. Run ..PARAM to adjust your parameters if you wish

## Using VPE (Brief User Manual)
To enter VPE, type `D ^XV`.  An online manual can be found by just typing '?'
when at the '>>' VPE prompt. 

VPE has its own CHUI Windowing system. To get out of any windows, type 'ESC',
'ESC'... that is, two escapes in a row. That's the only shortcut key you really
need to remember.

v15.0 introduces syntax highlighting as a feature. It is not enabled by default.
Type `..PARAM` and choose `8. Highlight Syntax....` in order to turn syntax
highlighting on. By default, syntax colors are optimized for a black background;
if you wish to change the colors, choose `9. Configure Syntax....`. Note that
the latter only apprers only if Syntax Highlighting is toggled on from option 8.
Many thanks to David Wicksell for writing the Syntax Highlighter.

The VPE manual can be found here:
http://www.pioneerdatasys.com/hardhats/VPEUSER.pdf. Since the original VPE
manual has been written, VPE has been moved to XVEM from %ZVEM or ZVEM.
Therefore, any references to %ZVEM or ZVEM should be changed to XVEM.

## Unit Testing
VPE (as of version 14.2) comes with a Unit Testing suite that covers about 50%
of the code. The tests are somewhat brittle due to the reliance on specific 
strings which may change between Fileman versions, due to how much global data
is in a system, and due to issues with race conditions in PExpect. The authors
do guarantee that the tests would run on FOIA VistA on GT.M and Cache.

They To run the Unit Testing suite, make sure you have VPE imported into
your M-implementation (if you are running the tests, preferably the routines
in this repository rather than the release), and then navigate to the test
folder, and then run this command:

```
python VPE_test.py -c ON -cs 'XV*,-XVIR*' /tmp/
```

This is the expected output:
```
test_deleteVPE (__main__.VPEUnitTests) ... ok
test_startVPE (__main__.VPEUnitTests) ... ok
test_startVPE_with_v12_installed (__main__.VPEUnitTests) ... ok
test_tryStartAgainFromWithin (__main__.VPEUnitTests) ... ok
test_tryDUZ999999999 (__main__.VPEUnitTests) ... ok
test_qwiks (__main__.VPEUnitTests) ... ok
test_command_line_shortcuts (__main__.VPEUnitTests) ... ok
test_command_line_error_trap (__main__.VPEUnitTests) ... ok
test_command_line_global_warn (__main__.VPEUnitTests) ... ok
test_main_help (__main__.VPEUnitTests) ... ok
test_delete_routine (__main__.VPEUnitTests) ... ok
test_editor (__main__.VPEUnitTests) ... ok
test_showSymbolTable (__main__.VPEUnitTests) ... ok
test_showCalendar (__main__.VPEUnitTests) ... ok
test_showASCIITable (__main__.VPEUnitTests) ... ok
test_systemShell (__main__.VPEUnitTests) ... ok
test_VGL (__main__.VPEUnitTests) ... ok
test_VEDD (__main__.VPEUnitTests) ... ok
test_routineSearch (__main__.VPEUnitTests) ... ok
test_ZP (__main__.VPEUnitTests) ... ok
test_UserList (__main__.VPEUnitTests) ... ok
test_FilemanTemplateDisplayers (__main__.VPEUnitTests) ... ok
test_FilemanHelp (__main__.VPEUnitTests) ... ok
test_KernelHelp (__main__.VPEUnitTests) ... ok
test_notes (__main__.VPEUnitTests) ... ok
test_key (__main__.VPEUnitTests) ... ok
test_param (__main__.VPEUnitTests) ... ok
test_ZD (__main__.VPEUnitTests) ... ok
test_CLH (__main__.VPEUnitTests) ... ok
test_DIC (__main__.VPEUnitTests) ... ok
test_purge (__main__.VPEUnitTests) ... ok
test_QSAVE (__main__.VPEUnitTests) ... ok
test_syntaxHighlighting (__main__.VPEUnitTests) ... ok
test_ZSAVE_ZLINK_percent (__main__.VPEUnitTests) ... ok
test_stopVPE (__main__.VPEUnitTests) ... ok
Human readable coverage requires M-Unit 1.6

----------------------------------------------------------------------
Ran 35 tests in 53.140s
```

The VPE.cfg file contains the configuration of how to connect to the M system.
It supports various configuration scenarios. Here's how to connect to a GT.M
system on the same machine:

```
[RemoteDetails]
RemoteConnect=0
Instance=gtm
```

If you use this configuration, you MUST set $gtm_dist, $gtmroutines, and 
$gtmgbldir correctly prior to invoking the python script.

For Caché, VPE.cfg looks like this:
```
[RemoteDetails]
RemoteConnect=0
ServerLocation=127.0.0.1
Instance=cache
UseDefaultNamespace=VEHU
```

If you use this configuration, you MUST set $CACHE_INSTANCE and $CACHE_NAMESPACE
correctly prior to invoking the python script.

(In reality, it seems that the VPE.cfg is ignored when setting CACHE_INSTANCE
and CACHE_NAMESPACE. In reality, all you need is this: `CACHE_INSTANCE={INSTANCE} CACHE_NAMESPACE={NAMESPACE} python VPE_test.py -c ON -cs 'XV*,-XVIR*' /tmp/`.

If you want to connect to a remote VistA instance, or use a username/password
with Caché, then read the code in `tests/pexpect_n_vistahelpers/vista/TestHelper.py`
for a hint of how to do that.

## Changes
The entire change history from version 9 to the current version can be found
[here](Changes.md).

## License
The VPE is now licensed under Apache 2.0. See [LICNESE](LICENSE) for more details.

## XINDEX
VPE passes XINDEX, with the following exceptions, from which it is exempt:

 * Fileman INIT routines don't have a correct first line (exempt under 2.2.1.2)
 * Vendor specific routine and external package calls (exempt as a Kernel Extension under 2.2.8)

## Packaging
For the maintainers, there is a set of instructions on how to make a new
release of VPE at [PACKAGING.md](PACKAGING.md).

## Future Plans
There are a ton of feature requests and bugs in the Issue Tracker. Personally
(Sam) I would wish for an integrated debugger inside of VPE.

## Ray Newman's Mumps V1 support
There is now full support as of v14.0 for MV1. However, there is a bug in MV1
where the M95 error trap behaves like the old $ZTRAP, so Error trap unwind is
handled differently for MV1.
