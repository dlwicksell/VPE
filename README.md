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

## Unit Testing
VPE (as of version 14.2) comes with a Unit Testing suite that covers about 50%
of the code. To run the Unit Testing suite, make sure you have VPE imported into
your M-implementation (if you are running the tests, preferably the routines
in this repository rather than the release), and then navigate to the test
folder, adjust VPE.cfg to connect to your M system (examples to follow), and 
then run this command:

```
python VPE_test.py -c ON -cs 'XV*,-XVIR*' /tmp/
```

This is the expected output:
```
test_deleteVPE (__main__.VPEUnitTests) ... ok
test_startVPE (__main__.VPEUnitTests) ... ok
test_tryStartAgainFromWithin (__main__.VPEUnitTests) ... ok
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
test_params (__main__.VPEUnitTests) ... ok
test_ZD (__main__.VPEUnitTests) ... ok
test_CLH (__main__.VPEUnitTests) ... ok
test_DIC (__main__.VPEUnitTests) ... ok
test_purge (__main__.VPEUnitTests) ... ok
test_QSAVE (__main__.VPEUnitTests) ... ok
test_stopVPE (__main__.VPEUnitTests) ... ok

----------------------------------------------------------------------
Ran 31 tests in 37.514s

OK
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

If you want to connect to a remote VistA instance, or use a username/password
with Caché, then read the code in `tests/pexpect_n_vistahelpers/vista/TestHelper.py`
for a hint of how to do that.

## Changes
The entire change history from version 9 to the current version can be found
[here](Changes.md).

## License
The VPE is now licensed under Apache 2.0. See [LICNESE](LICENSE) for more details.

## MV1 support
This section is for Sam, the maintainer. You can ignore it:

What's left for supporting MV1 is the following:
- Error trap unwind doesn't work b/c of a bug in MV1 --> PUT A BANDAID!
