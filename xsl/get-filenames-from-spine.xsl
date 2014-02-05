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
    <xsl:variable name="base-dir" select="collection()/*:files/@xml:base" as="xs:string"/>
    <xsl:element name="epub2hub:filelist">
      <xsl:attribute name="xml:base" select="collection()/*:files/@xml:base"/>
      <xsl:for-each select="collection()//*:spine/*:itemref">
        <xsl:variable name="href" select="//*:manifest/*:item[@id eq current()/@idref]/@href" as="xs:string"/>
        <xsl:variable name="file-uri" select="collection()//*:file[matches(@name, concat('(^|[/\\])', $href))]/@name" as="xs:string"/>
        <xsl:element name="file">
          <xsl:attribute name="name" select="$file-uri"/>
          <xsl:attribute name="type" select="'xhtml'"/>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="collection()//*:manifest/*:item[@media-type='text/css']">
        <xsl:variable name="href" select="@href" as="xs:string"/>
        <xsl:variable name="file-uri" select="collection()//*:file[matches(@name, concat('(^|[/\\])', $href))]/@name" as="xs:string"/>
        <xsl:element name="file">
          <xsl:attribute name="name" select="$file-uri"/>
          <xsl:attribute name="type" select="'css'"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>