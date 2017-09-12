import unittest
import sys
sys.path.append('./pexpect_n_vistahelpers/vista')
import TestHelper
import cProfile, pstats, StringIO

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

