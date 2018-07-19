import sys
import unittest
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


class TestGoogleConn(unittest.TestCase):

    def setUp(self):
	hub_hostname=sys.argv[1]
        self.browser = webdriver.Remote(command_executor='http://' + str(hub_hostname) + ':4444/wd/hub', desired_capabilities=DesiredCapabilities.CHROME) 
        self.addCleanup(self.browser.quit)

    def test_PageTitle(self):
        self.browser.get('http://www.google.com')
        self.assertIn('Google', self.browser.title)

if __name__ == '__main__':
    unittest.main(verbosity=4)
