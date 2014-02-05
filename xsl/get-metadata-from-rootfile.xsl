<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">


  <xsl:template match="/">
    <xsl:apply-templates select="collection()//*:book"/>
  </xsl:template>

  <xsl:template match="*:book">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <!-- <xsl:variable name="dc-list" as="xs:node()+"> -->
      <!--   <info epub-name="dc:contributor" hub-name="bibliomisc/@role"/> -->
      <!--   <info epub-name="dc:coverage" hub-name="bibliocoverage"/> -->
      <!--   <info epub-name="dc:creator" hub-name="author/personname"/> -->
      <!--   <info epub-name="dc:date" hub-name="date"/> -->
      <!--   <info epub-name="dc:description" hub-name="abstract"/> -->
      <!--   <info epub-name="dc:format" hub-name="bibliomisc/@role"/> -->
      <!--   <info epub-name="dc:identifier" hub-name="biblioid"/> -->
      <!--   <info epub-name="dc:language" hub-name="@xml:lang"/> -->
      <!--   <info epub-name="dc:publisher" hub-name="publisher/publishername"/> -->
      <!--   <info epub-name="dc:relation" hub-name="bibliorelation"/> -->
      <!--   <info epub-name="dc:rights" hub-name="copyright"/> -->
      <!--   <info epub-name="dc:source" hub-name="bibliosource"/> -->
      <!--   <info epub-name="dc:subject" hub-name="subjectset/subject/subjectterm"/> -->
      <!--   <info epub-name="dc:title" hub-name="title"/> -->
      <!--   <info epub-name="dc:type" hub-name="bibliomisc/@role"/> -->
      <!-- </xsl:variable> -->
      <xsl:element name="info" xmlns="http://docbook.org/ns/docbook">
        <xsl:element name="keywordset">
          <xsl:attribute name="role" select="'bookinfo'"/>
          <xsl:for-each select="collection()//*:metadata/*">
            <xsl:if test="*">
              <xsl:message terminate="yes" select="'epub2hub WARNING: metadata-elements with substructure not implemented, yet. Content: ', ."/>
            </xsl:if>
            <xsl:element name="keyword">
              <xsl:choose>
                <xsl:when test="@name and @content">
                  <xsl:attribute name="role" select="@name"/>
                  <xsl:value-of select="@content"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="role" select="name()"/>
                  <xsl:value-of select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
      <xsl:copy-of select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
