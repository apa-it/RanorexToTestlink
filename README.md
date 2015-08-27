# RanorexToTestlink-XSLTransformation
  
##What it does:
It takes Ranorex-rxtst-files as input and produces separate files for each test case in a TestLink-compatible format.
The reason it doesn't export entire test projects/suites or folders is that it wouldn't be practical for manual test cases.
By only exporting test cases it remains more flexible and allows for individual imports of Ranorex test cases.
  
##Requirements:
- An XSLT 2.0 processor is required for the transformation (eg. Saxon)
- Test cases must either be child-elements of test suites or folders (test case under test case is ignored)
- The custom field in TestLink must be named CommunicationChannel (for details see http://www.ranorex.com/blog/integrating-ranorex-with-testlink-and-jenkins-2 )
  
##Usage example (with Saxon and all files in the same folder):
java -jar saxon9he.jar TestSuite.rxtst RanorexToTestlink.xsl