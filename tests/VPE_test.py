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

    def test_startVPE(self):
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

    def test_list_qwiks(self):
        self.vista.write('..')
        boo = self.vista.wait('ZW')
        self.assertEqual(boo,1)
        self.vista.wait('>>')

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
#---------------------------------------------------------------------------
