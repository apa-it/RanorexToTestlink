<?xml version="1.0" encoding="UTF-8"?>
<!--
  RanorexToTestlink-XSLTransformation
  
  What it does:
  It takes Ranorex-rxtst-files as input and produces separate files for each test case in a TestLink-compatible format.
  The reason it doesn't export entire test projects/suites or folders is that it wouldn't be practical for manual test cases.
  By only exporting test cases it remains more flexible and allows for individual imports of Ranorex test cases.
  
  Requirements:
  - An XSLT 2.0 processor is required for the transformation (eg. Saxon)
  - Test cases must either be child-elements of test suites or folders (test case under test case is ignored)
  - The custom field in TestLink must be named CommunicationChannel (for details see http://www.ranorex.com/blog/integrating-ranorex-with-testlink-and-jenkins-2 )
  
  Usage example (with Saxon and all files in the same folder):
  java -jar saxon9he.jar TestSuite.rxtst RanorexToTestlink.xsl
  
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/testsuite">
    <xsl:for-each select="*/folder/testcase | content/testcase"> <!-- Only test cases under test suites or folders are used -->
      <xsl:result-document method="xml" href="TC_{@name}.xml">  <!-- Result-document requires XSLT 2.0 -->
        <testcases>
          <testcase>
            <xsl:attribute name="name">
              <xsl:value-of select="replace(@name,'_',' ')" />  <!-- The underscores are replaced by whitespaces -->
            </xsl:attribute>
            <xsl:if test="htmlcomment">  <!-- If a Description is present it is used as the summary in TestLink -->
              <summary>
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[&lt;p&gt;</xsl:text>
                  <xsl:value-of select="replace(htmlcomment, '^\s*(.+?)\s*$', '$1')" />  <!-- Trimming the Ranorex Description since newlines are present -->
                <xsl:text disable-output-escaping="yes">&lt;/p&gt;]]&gt;</xsl:text>
              </summary>
            </xsl:if>
            <execution_type><xsl:text disable-output-escaping="yes">&lt;![CDATA[2]]&gt;</xsl:text></execution_type>  <!-- It is assumed that the imported test cases are automatic -->
            <custom_fields>
              <custom_field>
                <name><xsl:text disable-output-escaping="yes">&lt;![CDATA[CommunicationChannel]]&gt;</xsl:text></name>  <!-- It is assumed that the custom field is named CommunicationChannel -->
                <value>
                  <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                    <xsl:value-of select="@name" />
                  <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                </value>
              </custom_field>
            </custom_fields>
          </testcase>
        </testcases>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>