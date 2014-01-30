<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
                xmlns:xs = "http://www.w3.org/2001/XMLSchema"
                xmlns:saxon	= "http://saxon.sf.net/"
                xmlns:letex	= "http://www.le-tex.de/namespace"
                xmlns:epub2hub = "http://www.le-tex.de/namespace/epub2hub"
                exclude-result-prefixes = "xs saxon letex"
                >
  
  <xsl:output
      method="xml"
      encoding="utf-8"
      indent="no"
      cdata-section-elements=''
      />


  <xsl:template match="/" mode="epub2hub:get-filenames-from-spine">
    <xsl:variable name="input-collection" select="collection()" as="node()*"/>
    <xsl:variable name="base-dir" select="$input-collection/*:files/@xml:base" as="xs:string"/>
    <xsl:variable name="rootfile-uri" select="concat($base-dir, $input-collection/*:container//*:rootfile/@full-path)" as="xs:string"/>
    <xsl:element name="epub2hub:filelist">
      <xsl:choose>
        <xsl:when test="doc-available($rootfile-uri)">
          <xsl:for-each select="doc($rootfile-uri)//*:spine/*:itemref">
            <xsl:variable name="href" select="//*:manifest/*:item[@id eq current()/@idref]/@href" as="xs:string"/>
            <xsl:variable name="file-uri" select="$input-collection//*:file[matches(@name, concat('(^|[/\\])', $href))]/@name" as="xs:string"/>
            <xsl:element name="file">
              <xsl:attribute name="name" select="$file-uri"/>
              <xsl:attribute name="type" select="'xhtml'"/>
            </xsl:element>
          </xsl:for-each>
          <xsl:for-each select="doc($rootfile-uri)//*:manifest/*:item[@media-type='text/css']">
            <xsl:variable name="href" select="@href" as="xs:string"/>
            <xsl:variable name="file-uri" select="$input-collection//*:file[matches(@name, concat('(^|[/\\])', $href))]/@name" as="xs:string"/>
            <xsl:element name="file">
              <xsl:attribute name="name" select="$file-uri"/>
              <xsl:attribute name="type" select="'css'"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes" select="'(epub2hub) ERROR: rootfile (', $rootfile-uri, ') not found.'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>