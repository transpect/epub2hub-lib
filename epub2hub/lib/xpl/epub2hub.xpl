<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:bc="http://transpect.io/book-conversion"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:cx="http://xmlcalabash.com/ns/extensions" 
  xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
  xmlns:dbk="http://docbook.org/ns/docbook"
  xmlns:hub="http://transpect.io/hub"
  xmlns:epub2hub="http://transpect.io/epub2hub"
  xmlns:html2hub="http://transpect.io/html2hub" 
  xmlns:tr="http://transpect.io"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  name="epub2hub"
  type="tr:epub2hub"
  version="1.0">
  
  <p:input port="params" kind="parameter" primary="true">
    <p:documentation>Arbitrary parameters that will be passed to the dynamically executed pipeline.</p:documentation>
  </p:input>
  <p:input port="schema" primary="false">
    <p:documentation>Excepts the Hub RelaxNG XML schema</p:documentation>
    <p:document href="../../schema/Hub/hub.rng"/>
  </p:input>

  <p:output port="result" primary="true" sequence="false">
    <p:pipe port="result" step="single-document-with-xml-model"/>
  </p:output>
  
  <p:option name="epubfile" required="true"/>
  <p:option name="hub-version" select="'1.1'"/>
  
  <p:option name="series" select="''"/> 
  <p:option name="work" select="''"/> 
  <p:option name="publisher" select="''"/>
  
  <p:option name="debug" select="'no'"/> 
  <p:option name="debug-dir-uri" select="'debug'"/>
  
  <p:option name="progress" required="false" select="'yes'"/>
  <p:option name="check" required="false" select="'yes'"/>
  
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl" />
  <p:import href="http://transpect.io/calabash-extensions/unzip-extension/unzip-declaration.xpl"/>
  <p:import href="http://transpect.io/html2hub/xpl/html2hub.xpl"/>
  <p:import href="http://transpect.io/xproc-util/simple-progress-msg/xpl/simple-progress-msg.xpl"/>
  <p:import href="http://transpect.io/xproc-util/store-debug/xpl/store-debug.xpl"/>
  <p:import href="http://transpect.io/calabash-extensions/rng-extension/xpl/rng-validate-to-PI.xpl"/>
  <p:import href="http://transpect.io/xproc-util/xml-model/xpl/prepend-hub-xml-model.xpl" />
	<p:import href="http://transpect.io/xproc-util/file-uri/xpl/file-uri.xpl"/>

  <p:variable name="basename" select="replace($epubfile, '^(.+?)([^/\\]+)\.epub$', '$2')"/>
  <p:variable name="status-dir-uri" select="concat($debug-dir-uri, '/status')"/>

  <tr:simple-progress-msg name="start-msg">
    <p:with-option name="file" select="concat('epub2html-start.',$basename,'.txt')"/>
    <p:input port="msgs">
      <p:inline>
        <c:messages>
          <c:message xml:lang="en">Starting conversion from ePub to Hub XML</c:message>
          <c:message xml:lang="de">Beginne Konvertierung von ePub nach Hub XML</c:message>
        </c:messages>
      </p:inline>
    </p:input>
    <p:with-option name="status-dir-uri" select="$status-dir-uri"/>
  </tr:simple-progress-msg>
<!--  neccessary to look at the html2hub progress-->
  <cx:message message=" ################# INFO: STATUS OF EPUB2HUB IS ALPHA, HTML2HUB: WORK IN PROGRESS #################"/>

  <p:sink/>

  <tr:file-uri name="file-uri">
    <p:with-option name="filename" select="$epubfile"><p:empty/></p:with-option>
  </tr:file-uri>
  
  <tr:unzip name="epub-unzip">
    <p:with-option name="zip" select="/*/@os-path" />
    <p:with-option name="dest-dir" select="concat(/*/@os-path, '.tmp')"/>
    <p:with-option name="overwrite" select="'yes'" />
    <p:documentation>Unzips the ePub file.</p:documentation>
  </tr:unzip>

  <p:xslt name="unzip">
    <p:input port="source">
      <p:pipe port="result" step="epub-unzip"/>
    </p:input>
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet version="2.0">
          <xsl:template match="* |@*">
            <xsl:copy>
              <xsl:apply-templates select="@*, node()"/>
            </xsl:copy>
          </xsl:template>
          <xsl:template match="@name">
            <xsl:attribute name="name" select="replace(replace(., '\[', '%5B'), '\]', '%5D')"/>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
    <p:input port="parameters"><p:empty/></p:input>
  </p:xslt>


  <p:load name="container">
    <p:with-option name="href" select="concat(/c:files/@xml:base, 'META-INF/container.xml')">
      <p:pipe port="result" step="unzip"/>
    </p:with-option>
    <p:documentation>Loads container.xml as point of entry.</p:documentation>
  </p:load>

  <p:sink/>

  <p:xslt name="rootfile">
    <p:documentation>XSL that provides the rootfile's uri.</p:documentation>
    <p:input port="source">
      <p:pipe port="result" step="container"/>
    </p:input>
    <p:input port="parameters"><p:empty/></p:input>
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet version="2.0">
          <xsl:param name="base-dir-uri"/>
          <xsl:template match="*:container">
            <c:rootfile>
              <xsl:value-of select="concat($base-dir-uri, *:rootfiles/*:rootfile[1]/@full-path)"/>
            </c:rootfile>
            <xsl:if test="count(*:rootfiles/*:rootfile) eq 0">
              <xsl:message select="'epub2hub WARNING: No rootfile element found in container.xml.'"/>
            </xsl:if>
            <xsl:if test="count(*:rootfiles/*:rootfile) gt 1">
              <xsl:message select="'epub2hub WARNING: More than one rootfile element found in container.xml.'"/>
            </xsl:if>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
    <p:with-param name="base-dir-uri" select="/c:files/@xml:base">
      <p:pipe port="result" step="unzip"/>
    </p:with-param>
  </p:xslt>
  
  <tr:store-debug pipeline-step="epub2hub/rootfile" extension="xml">
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:sink/>

  <p:load name="load-rootfile">
    <p:with-option name="href" select="/c:rootfile">
      <p:pipe port="result" step="rootfile"/>
    </p:with-option>
  </p:load>

  <p:sink/>

  <p:xslt name="filelist">
    <p:input port="source">
      <p:pipe port="result" step="load-rootfile"/>
      <p:pipe port="result" step="unzip"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../xsl/get-filenames-from-spine.xsl">
        <p:documentation>XSL that provides a list of CSS and HTML files in correct order. The order results from the spine element in the rootfile declared in container.xml.</p:documentation>
      </p:document>
    </p:input>
    <p:documentation>See step "load-stylesheet".</p:documentation>
  </p:xslt>

  <tr:store-debug pipeline-step="epub2hub/filelist">
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>
  
  <p:for-each name="html2hub-conversion" cx:depends-on="filelist">
<!-- guessing: there are no iteration items for the wrap-sequence function at the end-->
    <p:documentation>Converts all (x)html files listed in the filelist created in step "filelist" to Hub xml.</p:documentation>
    <p:iteration-source select="/epub2hub:filelist/file[@type='xhtml']"/>
    <p:variable name="base-name" select="file/@name"/>
    <p:variable name="base-dir" select="/c:files/@xml:base">
      <p:pipe port="result" step="unzip"/>
    </p:variable>
    
    <p:load name="load-html">
      <p:with-option name="href" select="concat($base-dir,$base-name)"/>
    </p:load>

    <p:add-xml-base name="add-xml-base"/>
    
    <tr:store-debug>
      <p:with-option name="pipeline-step" select="concat('epub2hub/',$base-name)"/>
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>
    
<!--
    <tr:store-debug>
      <p:with-option name="pipeline-step" select="concat('epub2hub/html/', tokenize($base-name, '/')[last()])"/>
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>-->

    <html2hub:convert name="html2hub">
      <p:with-option name="debug" select="$debug" />
      <p:with-option name="debug-dir-uri" select="$debug-dir-uri" />
      <p:with-option name="prepend-hub-xml-model" select="'false'" />
      <p:with-option name="archive-dir-uri" select="$epubfile" />
    </html2hub:convert>

    <tr:store-debug>
      <p:with-option name="pipeline-step" select="concat('epub2hub/hub/', replace(tokenize($base-name, '/')[last()], '\.[^.]+$', ''), '.hub')"/>
      <p:with-option name="active" select="$debug"/>
      <p:with-option name="base-uri" select="$debug-dir-uri"/>
    </tr:store-debug>

  </p:for-each>
    

  <p:wrap-sequence wrapper="book" wrapper-namespace="http://docbook.org/ns/docbook" name="single-document">
    <p:documentation>Assembles Hub xml files resulting from step "html2hub-conversion" (puts chapters into book element). </p:documentation>
  </p:wrap-sequence>
 
  <p:sink/>


  <p:load name="load-metadata-stylesheet" href="../xsl/get-metadata-from-rootfile.xsl">
    <p:documentation>XSL transforming metadata children in the rootfile into keywords in the result document.</p:documentation>
  </p:load>

  <p:xslt name="metadata">
    <p:input port="source">
      <p:pipe port="result" step="load-rootfile"/>
      <p:pipe port="result" step="single-document"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="load-metadata-stylesheet"/>
    </p:input>
  </p:xslt>

  <p:sink/>

  <p:load name="load-hub-keywords-stylesheet" href="../../html2hub/xsl/hub-keywords.xsl"/>

  <p:xslt name="hub-keywords">
    <p:input port="source">
      <p:pipe port="result" step="metadata"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="load-hub-keywords-stylesheet"/>
    </p:input>
    <p:with-param name="archive-dir-uri" select="$epubfile"/>
    <p:with-param name="base-dir-uri" select="/c:files/@xml:base">
      <p:pipe port="result" step="unzip"/>
    </p:with-param>
    <p:with-param name="base-name" select="replace($epubfile, '^(.+?)([^/\\]+\.epub)$', '$2')"/>
    <p:with-param name="src-type" select="concat('epub', replace(/*:package/@version, '\.', ''))">
      <p:pipe port="result" step="load-rootfile"/>
    </p:with-param>
  </p:xslt>

  <tr:prepend-hub-xml-model name="single-document-with-xml-model">
    <p:with-option name="hub-version" select="$hub-version"/>
  </tr:prepend-hub-xml-model>

  <tr:validate-with-rng-PI name="rng2pi">
    <p:with-option name="debug" select="$debug"/>
    <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/>
    <p:input port="schema">
      <p:pipe port="schema" step="epub2hub"/>
    </p:input>
  </tr:validate-with-rng-PI>
  
  <tr:store-debug>
    <p:with-option name="pipeline-step" select="concat('rngvalid/',$basename,'.with-PIs')"/>
    <p:with-option name="active" select="$debug"/>
    <p:with-option name="base-uri" select="$debug-dir-uri"/>
  </tr:store-debug>

  <tr:simple-progress-msg name="success-msg">
    <p:with-option name="file" select="concat('epub2html-success.',$basename,'.txt')"/>
    <p:input port="msgs">
      <p:inline>
        <c:messages>
          <c:message xml:lang="en">Successfully converted ePub to Hub XML</c:message>
          <c:message xml:lang="de">Konvertierung von ePub nach Hub XML erfolgreich abgeschlossen</c:message>
        </c:messages>
      </p:inline>
    </p:input>
    <p:with-option name="status-dir-uri" select="$status-dir-uri"/>
  </tr:simple-progress-msg>

  <p:sink/>

</p:declare-step>