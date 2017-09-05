import unittest
import sys
sys.path.append('./pexpect_n_vistahelpers/vista')
import TestHelper

class VPEUnitTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        VistA.startCoverage(test_suite_details.coverage_subset)

    @classmethod
    def tearDownClass(cls):
        VistA.stopCoverage('./output/cov.cov')
        VistA.write('halt')

    def test_startVPE(self):
        VistA.write('D ^XV')
        rval = VistA.multiwait(['NAME', 'ID'])
        VistA.write('`1')
        self.assertEqual(VistA.wait('>>'),1)

    def test_list_qwiks(self):
        VistA.write('..')
        boo = VistA.wait('ZW')
        self.assertEqual(boo,1)
        VistA.wait('>>')

    def test_delete_routine(self):
        VistA.write('..ZR KBANTEST')
        boo = VistA.wait('OK TO DELETE?')
        self.assertEqual(boo,1)
        VistA.write('Y')
        boo = VistA.wait('Removed')
        self.assertEqual(boo,1)
        VistA.wait('>>')

    def test_editor(self):
        VistA.write('..E')
        boo = VistA.wait('ROUTINE')
        self.assertEqual(boo,1)
        VistA.write('KBANTEST')
        boo = VistA.wait('[^KBANTEST]')
        self.assertEqual(boo,1)
        VistA.write('')
        VistA.write(' W "HELLO VPE",!')
        VistA.write(' QUIT')
        VistA.wait('');
        VistA.writectrl(chr(27)) # end line
        VistA.writectrl(chr(27))
        VistA.writectrl(chr(27)) # save routine
        VistA.writectrl(chr(27))
        VistA.wait('Save your changes?')
        VistA.write('')
        VistA.wait('saved to disk')
        VistA.wait('>>')
        VistA.write('D ^KBANTEST')
        boo = VistA.wait('HELLO VPE')
        self.assertEqual(boo,1)
        VistA.wait('>>')

    def test_stopVPE(self):
        VistA.write('HALT')

if __name__ == '__main__':
    test_suite_driver = TestHelper.TestSuiteDriver(__file__)
    test_suite_details = test_suite_driver.generate_test_suite_details()
    test_suite_details.coverage_subset = ['XV*']
    test_suite_driver.pre_test_suite_run(test_suite_details)
    test_driver = TestHelper.TestDriver("Main")
    VistA = test_driver.connect_VistA(test_suite_details)

    del sys.argv[1:]
    loader = unittest.TestLoader()
    ln = lambda f: getattr(VPEUnitTests, f).im_func.func_code.co_firstlineno
    lncmp = lambda a, b: cmp(ln(a), ln(b))
    loader.sortTestMethodsUsing = lncmp

    unittest.main(testLoader=loader, verbosity=2)

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
