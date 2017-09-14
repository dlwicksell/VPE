import unittest
import sys
sys.path.append('./pexpect_n_vistahelpers/vista')
import TestHelper
import cProfile, pstats, StringIO
import time

class VPEUnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.vista = test_driver.connect_VistA(test_suite_details)
        cls.vista.startCoverage(",".join(test_suite_details.coverage_subset))

    @classmethod
    def tearDownClass(cls):
        cls.vista.stopCoverage('./output/cov.cov', 'ON')
        cls.vista.write('halt')

    def test_deleteVPE(self):
        self.vista.write('K ^XVEMS')
        self.vista.write('D DT^DICRW')
        self.vista.write('S DIU="^XVV(19200.11,",DIU(0)="DSE" D EN^DIU2')
        self.vista.write('S DIU="^XVV(19200.111,",DIU(0)="DSE" D EN^DIU2')
        self.vista.write('S DIU="^XVV(19200.112,",DIU(0)="DSE" D EN^DIU2')
        self.vista.write('S DIU="^XVV(19200.113,",DIU(0)="DSE" D EN^DIU2')
        self.vista.write('S DIU="^XVV(19200.114,",DIU(0)="DSE" D EN^DIU2')
        self.vista.wait('>')

    def test_startVPE(self):
        self.vista.write('S %ut=1') # This prevents VPE from auto-resizing, which confuses pexpect
        self.vista.write('D ^XV')
        rval = self.vista.multiwait(['NAME', 'ID'])
        self.vista.write('`1')
        self.vista.wait('ID Number')
        self.vista.write('1')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('to continue')
        self.vista.write('')
        self.vista.wait('Load VPE Shell global')
        self.vista.write('Y')
        self.vista.wait('to continue..')
        self.vista.write('')
        self.assertEqual(self.vista.wait('>>'),1)

    def test_tryStartAgainFromWithin(self):
        self.vista.write('D ^XV')
        self.assertEqual(self.vista.wait('VSHELL CURRENTLY ACTIVE'),1)
        self.assertEqual(self.vista.wait('>>'),1)

    def test_list_qwiks(self):
        # Test User Qwiks
        self.vista.write('.')
        self.assertTrue(self.vista.wait('No User QWIKs on record'))
        self.vista.wait('>>')

        # Test System Qwiks
        self.vista.write('..')
        boo = self.vista.wait('ZW')
        self.assertEqual(boo,1)
        self.vista.wait('>>')

        # Test ..QL1 and then Esc,H and then enter to exit and esc esc to exit
        self.vista.write('..QL1')
        self.assertEqual(self.vista.wait('U S E R   Q W I K S'),1)
        self.vista.writectrl(chr(27)) # ESC-H
        self.vista.writectrl('H')
        self.assertEqual(self.vista.wait('V P E   S C R O L L E R'),1)
        self.vista.write('')
        self.assertEqual(self.vista.wait('U S E R   Q W I K S'),1)
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        ## Test ..QL2 and then exit
        self.vista.write('..QL2')
        self.assertEqual(self.vista.wait('U S E R   Q W I K S'),1)
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        ## Test ..QL3
        self.vista.write('..QL3')
        self.assertEqual(self.vista.wait('S Y S T E M   Q W I K S'),1)
        self.assertEqual(self.vista.wait('DOS'),1)
        self.vista.writectrl(chr(27) + '[B') # Down arrow
        self.vista.writectrl(chr(27) + '[A') # Up arrow
        self.vista.writectrl('F') # Find
        self.assertTrue(self.vista.wait('S C R O L L E R   F I N D   U T I L I T Y'))
        self.assertTrue(self.vista.wait('Enter CHARACTERS:'))
        self.vista.write('ZW')
        self.assertTrue(self.vista.wait('ZW'))
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        ## Test ..QL4
        self.vista.write('..QL4')
        self.assertEqual(self.vista.wait('S Y S T E M   Q W I K S'),1)
        self.assertEqual(self.vista.wait('DOS'),1)
        self.vista.writectrl(chr(27) + '[6~') # page down several times
        self.vista.writectrl(chr(27) + '[6~')
        self.vista.writectrl(chr(27) + '[6~')
        self.vista.writectrl(chr(27) + '[6~')
        self.assertTrue(self.vista.wait('ZW'))
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        ## F1-1, F1-2, F1-3, F1-4 = ..QL1,QL2,QL3,QL4
        self.vista.writectrl(chr(27) + 'OP1') # F1-1
        self.assertTrue(self.vista.wait('U S E R   Q W I K S'))
        self.vista.writectrl(chr(27) + chr(27))
        self.vista.wait('>>')

        self.vista.writectrl(chr(27) + 'OP2') # F1-2
        self.assertTrue(self.vista.wait('U S E R   Q W I K S'))
        self.vista.writectrl(chr(27) + chr(27))
        self.vista.wait('>>')

        self.vista.writectrl(chr(27) + 'OP3') # F1-3
        self.assertTrue(self.vista.wait('S Y S T E M   Q W I K S'))
        self.vista.writectrl(chr(27) + chr(27))
        self.vista.wait('>>')

        self.vista.writectrl(chr(27) + 'OP4') # F1-4
        self.assertTrue(self.vista.wait('S Y S T E M   Q W I K S'))
        self.vista.writectrl(chr(27) + chr(27))
        self.vista.wait('>>')

    def test_command_line_shortcuts(self):
        # Left Arrow - Load command line history
        self.vista.writectrl(chr(27) + '[D')
        self.assertTrue(self.vista.wait('7) ..QL4')) # 6th command is QL4
        self.assertTrue(self.vista.wait('Select:'))
        self.vista.write('7')
        self.vista.write('')
        self.assertEqual(self.vista.wait('S Y S T E M   Q W I K S'),1)
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        # Up Arrow - Recall last command
        self.vista.writectrl(chr(27) + '[A') # Up arrow
        self.assertTrue(self.vista.wait('..QL4'))
        self.vista.write('')
        self.assertEqual(self.vista.wait('S Y S T E M   Q W I K S'),1)
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

        # Down Arrow - Recall first command
        self.vista.writectrl(chr(27) + '[B') # Down arrow
        self.assertTrue(self.vista.wait('D ^XV'))
        self.vista.writectrl(chr(27) + '[A') # Up arrow to cancel
        self.assertTrue(self.vista.wait('>>'))

    def test_command_line_error_trap(self):
        self.vista.write('W 1/0')
        self.assertTrue(self.vista.wait('ERROR LINE/CODE: @: W 1/0'))
        self.vista.wait('>>')

    def test_main_help(self):
        self.vista.writectrl(chr(27) + 'H') # ESC-H
        self.assertTrue(self.vista.wait('V S H E L L   H E L P   M E N U'))
        self.assertTrue(self.vista.wait('SELECT:'))
        self.vista.writectrl(chr(27) + '[B') # Down arrow - select Protection
        self.vista.write('') # enter
        self.assertTrue(self.vista.wait('P R O T E C T I O N'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('V S H E L L   H E L P   M E N U'))
        self.assertTrue(self.vista.wait('SELECT:'))
        self.vista.write('Quit')
        self.assertTrue(self.vista.wait('>>'))

    def test_delete_routine(self):
        self.vista.write('..ZR KBANTEST')
        boo = self.vista.wait('OK TO DELETE?')
        self.assertEqual(boo,1)
        self.vista.write('Y')
        boo = self.vista.wait('Removed')
        self.assertEqual(boo,1)
        self.vista.wait('>>')

    def test_editor(self):
        self.vista.write('..E')
        boo = self.vista.wait('ROUTINE')
        self.assertEqual(boo,1)
        self.vista.write('KBANTEST')
        boo = self.vista.wait('[^KBANTEST]')
        self.assertEqual(boo,1)
        self.vista.write('')
        self.vista.write(' W "HELLO VPE",!')
        self.vista.write(' QUIT')
        self.vista.wait('');
        self.vista.writectrl(chr(27)) # end line
        self.vista.writectrl(chr(27))
        self.vista.writectrl(chr(27)) # save routine
        self.vista.writectrl(chr(27))
        self.vista.wait('Save your changes?')
        self.vista.write('')
        self.vista.wait('saved to disk')
        self.vista.wait('>>')
        self.vista.write('D ^KBANTEST')
        boo = self.vista.wait('HELLO VPE')
        self.assertEqual(boo,1)
        self.vista.wait('>>')

    def test_showSymbolTable(self):
        self.vista.write('..ZW')
        self.assertTrue(self.vista.wait('%ut')) # We put this guy in at the very beginning
        self.vista.writectrl(chr(27)) # exit
        self.vista.writectrl(chr(27))
        self.vista.wait('>>')

    def test_showCalendar(self):
        self.vista.write('..CAL')
        self.assertTrue(self.vista.wait('S I X   M O N T H   P L A N N E R'))
        self.vista.wait('>>')

    def test_showASCIITable(self):
        self.vista.write('..ASCII')
        self.assertTrue(self.vista.wait('A S C I I   C H A R A C T E R   S E T'))
        self.vista.wait('>>')

    def test_systemShell(self):
        self.vista.write('..DOS')
        self.assertTrue(self.vista.wait('@'))
        self.vista.write('exit')
        self.assertTrue(self.vista.wait('>>'))

    def test_VEDD(self):
        # Set DUZ(0) to contain # for VGL
        self.vista.write('S DUZ(0)="#"')
        # Test entry and exit from VEDD
        self.vista.write('..VEDD')
        self.assertTrue(self.vista.wait('FILE:'))
        self.vista.write('52')
        self.assertTrue(self.vista.wait('PRESCRIPTION'))
        self.assertTrue(self.vista.wait('Select OPTION:'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('Select FILE:'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('>>'))
        
        # Go back in
        self.vista.write('..VEDD 52')
        self.assertTrue(self.vista.wait('PRESCRIPTION'))
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test listing indexes (X)
        self.vista.write('X')
        self.assertTrue(self.vista.wait('ACRO')) # name of first index on my screen
        finished = 0
        while not finished:  # *I think there is a race condition here between the try and the except*
            # What I have here *shouldn't* work except if the 'except' takes place more often than the try
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test listing Pointers In (PI)
        self.vista.write('PI')
        self.assertTrue(self.vista.wait('DUE ANSWER SHEET')) # name of pointer file
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test listing Points Out (PO)
        self.vista.write('PO')
        self.assertTrue(self.vista.wait('NEW PERSON')) # name of pointer file
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test listing of Groups
        self.vista.write('GR')
        self.assertTrue(self.vista.wait('IHS')) # name of a group
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test Tracing of Field
        self.vista.write('TR')
        self.assertTrue(self.vista.wait('Enter Field Name'))
        self.vista.write('DRUG')
        self.assertTrue(self.vista.wait('DRUG  (6)'))
        self.vista.write('1')
        self.vista.wait('MAIN_MENU')
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test individual field DD
        self.vista.write('I')
        self.assertTrue(self.vista.wait('Select FIELD:'))
        self.vista.write('6')
        self.assertTrue(self.vista.wait('FIELD NAME:       DRUG'))
        finished = 0
        while not finished:
            try:
                self.vista.wait('Select FIELD:',0)
                finished = 1
            except:
                self.vista.write('')
        self.vista.write('I')
        self.assertTrue(self.vista.wait('Select FIELD:'))
        self.vista.write('SIG')
        self.assertTrue(self.vista.wait('SIG1'))
        self.vista.write('2')
        self.assertTrue(self.vista.wait('Select SUBFIELD:'))
        self.vista.write('?')
        self.assertTrue(self.vista.wait('Select SUBFIELD:'))
        self.vista.write('1')
        self.assertTrue(self.vista.wait('Select SUBFIELD:'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select FIELD:'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Test Fld Global Location (big!)
        self.vista.write('G')
        self.assertTrue(self.vista.wait('ALL_FIELDS'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('N=Node'))

        ## Test Obtaining a single node
        self.vista.write('8') # Trade Name
        self.assertTrue(self.vista.wait('TRADE NAME'))
        self.assertTrue(self.vista.wait('<RETURN>'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('N=Node'))

        ## Test ?
        self.vista.write('?') # Help
        self.assertTrue(self.vista.wait('Exit VEDD completely'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('N=Node'))
        
        ## Test Goto. Need to load all the file first using Page down
        ## Page down to the bottom
        for x in range(0, 20):
            self.vista.writectrl(chr(27) + '[6~')
        self.assertTrue(self.vista.wait('<> <> <>'))
        ## Page up to the top
        for x in range(0, 20):
            self.vista.writectrl(chr(27) + '[5~')
        self.assertTrue(self.vista.wait('RX #'))
        ## Goto node 100
        self.vista.write('G') # Goto
        self.assertTrue(self.vista.wait('REF NUMBER:'))
        self.vista.write('100')
        self.assertTrue(self.vista.wait('105'))

        ## Test Node
        self.vista.write('N') # Node
        self.assertTrue(self.vista.wait('NODE:'))
        self.vista.write('?') # help me
        self.assertTrue(self.vista.wait(' P '))
        self.vista.write('P') # P node
        self.assertTrue(self.vista.wait('SUBNODE'))
        self.vista.write('?') # help me
        self.assertTrue(self.vista.wait('0  1'))
        self.vista.write('1') # 1 node
        self.assertTrue(self.vista.wait('BINGO WAIT TIME'))
        self.vista.write('9') # 9 field
        self.assertTrue(self.vista.wait('<RETURN>'))
        self.vista.write('') # exit
        self.assertTrue(self.vista.wait('SUB-FIELD'))
        self.vista.write('') # exit
        self.assertTrue(self.vista.wait('SUBNODE'))
        self.vista.write('') # exit
        self.assertTrue(self.vista.wait('N=Node'))

        ## Test Pointer
        self.vista.write('P')
        self.assertTrue(self.vista.wait('REF NUMBER:'))
        self.vista.write('3') # help me
        self.assertTrue(self.vista.wait('DATE OF BIRTH'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        ## Page up to the top
        for x in range(0, 7):
            self.vista.writectrl(chr(27) + '[5~')
        self.assertTrue(self.vista.wait('RX #'))

        # Exit G
        self.vista.writectrl(chr(27) + chr(27)) # Go back

        # Templates - T
        self.vista.write('T')
        self.assertTrue(self.vista.wait('PRINT TEMPLATES')) # name of a group
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # File Description
        self.vista.write('D')
        self.assertTrue(self.vista.wait('File description for PRESCRIPTION file.'))
        self.vista.wait('MAIN_MENU')
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # File Characteristics
        self.vista.write('C')
        self.assertTrue(self.vista.wait('IDENTIFIERS:'))
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Required Fields
        self.vista.write('R')
        self.assertTrue(self.vista.wait('RX #'))
        finished = 0
        while not finished:
            try:
                self.vista.wait('MAIN_MENU',0)
                finished = 1
            except:
                self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # VGL - Don't run though. We will test later
        self.vista.write('VGL')
        self.assertTrue(self.vista.wait('...Global ^'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # H - Help
        self.vista.write('H')
        self.assertTrue(self.vista.wait('Bypasses opening screen.'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # PR - Turn printing mode on and try these options
        for option in [ 'X', 'PI', 'PO', 'GR' , 'T', 'C', 'R']:
            self.vista.write('PR')
            self.assertTrue(self.vista.wait('DEVICE'))
            self.vista.write('NULL')
            self.assertTrue(self.vista.wait('Select OPTION:'))
            self.vista.write(option)
            self.assertTrue(self.vista.wait('Select OPTION:'))

        # PR - Turn printing mode on and use 'I' which requires some user interaction
        self.vista.write('PR')
        self.assertTrue(self.vista.wait('DEVICE'))
        self.vista.write('NULL')
        self.assertTrue(self.vista.wait('Select OPTION:'))
        self.vista.write('I')
        self.assertTrue(self.vista.wait('Select FIELD:'))
        self.vista.write('.01')
        self.vista.write('1')
        self.vista.write('2')
        self.vista.write('3')
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # PR - Turn printing mode on and use 'G' which requires some user interaction
        self.vista.write('PR')
        self.assertTrue(self.vista.wait('DEVICE'))
        self.vista.write('NULL')
        self.assertTrue(self.vista.wait('Select OPTION:'))
        self.vista.write('G')
        self.vista.write('')
        self.assertTrue(self.vista.wait('Select OPTION:'))

        # Exit VEDD
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('>>'))

        # Enter VEDD via published entry point
        self.vista.write('D ^XVEMD')
        self.assertTrue(self.vista.wait('VElectronic Data Dictionary'))
        self.assertTrue(self.vista.wait('Select FILE:'))
        self.vista.write('60')
        self.assertTrue(self.vista.wait('Select OPTION:'))
        self.vista.write('G')
        self.vista.write('')
        self.assertTrue(self.vista.wait('N=Node'))
        self.vista.write('DA')
        self.assertTrue(self.vista.wait('REF NUMBERS(S):'))
        self.vista.write('1')
        self.assertTrue(self.vista.wait('DISPLAY TYPE'))
        self.vista.write('?')
        self.assertTrue(self.vista.wait('DISPLAY TYPE'))
        self.vista.write('')
        self.assertTrue(self.vista.wait('LABORATORY TEST NAME'))
        self.vista.write('`1')
        self.assertTrue(self.vista.wait('D A T A   D I S P L A Y'))
        self.assertTrue(self.vista.wait('File: LABORATORY TEST'))
        self.assertTrue(self.vista.wait('LABORATORY TEST NAME'))
        self.vista.write('')
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('Select OPTION:'))
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.vista.writectrl(chr(27) + chr(27)) # Go back
        self.assertTrue(self.vista.wait('>>'))



    def test_UserList(self):
        self.vista.write('..UL')
        self.assertTrue(self.vista.wait('U S E R   L I S T'))
        self.assertTrue(self.vista.wait('>>'))
        
    def test_stopVPE(self):
        self.vista.write('HALT')

if __name__ == '__main__':
    # OSEHRA Testing Framework Setup
    test_suite_driver = TestHelper.TestSuiteDriver(__file__)
    test_suite_details = test_suite_driver.generate_test_suite_details()
    test_suite_details.coverage_subset = ['XV*']
    test_suite_driver.pre_test_suite_run(test_suite_details)
    test_driver = TestHelper.TestDriver("Main")

    # Python Unit Testing setup
    del sys.argv[1:]  # don't pass the arguments down to the unit tester

    # Next stanza: run tests in order of declaration, top to bottom.
    loader = unittest.TestLoader()
    ln = lambda f: getattr(VPEUnitTests, f).im_func.func_code.co_firstlineno
    lncmp = lambda a, b: cmp(ln(a), ln(b))
    loader.sortTestMethodsUsing = lncmp

    # Turn on profiling
    #pr = cProfile.Profile()
    #pr.enable()

    # Run the main code
    unittest.main(testLoader=loader, verbosity=2, exit=False)

    # Disable profiling
    #pr.disable()

    # Print stats
    #s = StringIO.StringIO()
    #sortby = 'cumulative'
    #ps = pstats.Stats(pr, stream=s).sort_stats(sortby)
    #ps.print_stats()
    #print s.getvalue()

#---------------------------------------------------------------------------
# Copyright 2017 Sam Habiel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

