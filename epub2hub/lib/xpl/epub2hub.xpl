<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
  xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:bc="http://transpect.le-tex.de/book-conversion"
  xmlns:epub2hub="http://www.le-tex.de/namespace/epub2hub"
  xmlns:html2hub="http://www.le-tex.de/namespace/html2hub"
  xmlns:transpect="http://www.le-tex.de/namespace/transpect"
  xmlns:letex="http://www.le-tex.de/namespace"
  name="epub2hub"
  version="1.0">
  
  <p:input port="conf" primary="true">
    <p:document href="../../../conf/conf.xml"/>
  </p:input>
  <!-- <p:input port="schema" primary="false"> -->
  <!--   <p:documentation>Excepts the Hub RelaxNG XML schema</p:documentation> -->
  <!--   <p:document href="../../common/../../schema/Hub/hub.rng"/> -->
  <!-- </p:input> -->
  
  <p:output port="hub" primary="false">
    <p:pipe port="result" step="html2hub"/>
    <!-- <p:inline> -->
    <!--   <hurz/> -->
    <!-- </p:inline> -->
  </p:output>
  <!-- <p:output port="html" primary="false"> -->
  <!--   <p:pipe port="result" step="epub2html"/> -->
  <!-- </p:output> -->
  <!-- <p:output port="htmlreport" primary="false"> -->
  <!--   <p:pipe port="result" step="htmlreport"/> -->
  <!-- </p:output> -->
  
  <p:option name="epubfile" required="true"/>
  <p:option name="hub-version" select="'1.1'"/>
  
  <p:option name="series" select="''"/> 
  <p:option name="work" select="''"/> 
  <p:option name="publisher" select="''"/>
  
  <p:option name="debug" select="'yes'"/> 
  <p:option name="debug-dir-uri" select="'debug'"/>
  
  <p:option name="progress" required="false" select="'yes'"/>
  <p:option name="check" required="false" select="'yes'"/>
  
  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl" />
  <p:import href="http://transpect.le-tex.de/html2hub/xpl/html2hub.xpl"/>
  <p:import href="http://transpect.le-tex.de/book-conversion/converter/xpl/empty-report.xpl"/>
  <!-- <p:import href="http://transpect.le-tex.de/book-conversion/converter/xpl/validate-with-schematron.xpl"/> -->
  <!-- <p:import href="http://transpect.le-tex.de/book-conversion/converter/xpl/check-styles.xpl"/> -->
  <p:import href="http://transpect.le-tex.de/xproc-util/store-debug/store-debug.xpl"/>
  <p:import href="http://transpect.le-tex.de/book-conversion/converter/xpl/errorPI2svrl.xpl"/>
  <!-- <p:import href="http://transpect.le-tex.de/calabash-extensions/ltx-validate-with-rng/rng-validate-to-PI.xpl"/> -->
  
  
  <p:import href="paths.xpl"/>

  
  <transpect:epub2hub-paths name="epub2hub-paths"> 
    <p:with-option name="pipeline" select="'epub2hub.xpl'"/> 
    <p:with-option name="publisher" select="$publisher"/> 
    <p:with-option name="series" select="$series"/> 
    <p:with-option name="work" select="$work"/> 
    <p:with-option name="file" select="$epubfile"/> 
    <p:with-option name="debug" select="$debug"/> 
    <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> 
    <p:with-option name="progress" select="$progress"/> 
    <p:input port="conf"> 
      <p:pipe port="conf" step="epub2hub"/> 
    </p:input>
  </transpect:epub2hub-paths>
  
  <p:sink/>
  
  <!-- <html2hub:convert name="html2hub"> -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!--   <p:with-option name="html" select="/c:param-set/c:param[@name eq 'file']/@value"/> -->
  <!--   <p:with-option name="hub-version" select="$hub-version"/> -->
  <!--   <p:with-option name="srcpaths" select="'yes'"/> -->
  <!-- </html2hub:convert> -->
   
  <!-- <p:sink/> -->
  
  <!-- <bc:empty-report name="create-empty-report"> -->
  <!--   <p:with-option name="pipeline" select="'epub2hub'"/> -->
  <!-- </bc:empty-report> -->
  
  <!-- <p:sink/> -->
  
  <!-- <bc:check-styles name="check-styles"> -->
  <!--   <p:input port="source"> -->
  <!--     <p:pipe port="result" step="evolve-hub-dyn"/> -->
  <!--   </p:input> -->
  <!--   <p:input port="html-in"> -->
  <!--     <p:empty/> -->
  <!--   </p:input> -->
  <!--   <p:input port="report-in"> -->
  <!--     <p:pipe port="result" step="create-empty-report"/> -->
  <!--   </p:input> -->
  <!--   <p:input port="parameters"> -->
  <!--     <p:pipe port="result" step="paths"/> -->
  <!--   </p:input>   -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!--   <p:with-option name="active" select="$check"/> -->
  <!-- </bc:check-styles> -->
  
  <!-- <bc:validate-with-schematron name="validate-business-rules"> -->
  <!--   <p:input port="html-in"> -->
  <!--     <p:empty/> -->
  <!--   </p:input> -->
  <!--   <p:input port="report-in"> -->
  <!--     <p:pipe port="report" step="check-styles"/> -->
  <!--   </p:input> -->
  <!--   <p:input port="parameters"> -->
  <!--     <p:pipe port="result" step="paths"/> -->
  <!--   </p:input> -->
  <!--   <p:with-param name="family" select="'business-rules'"/> -->
  <!--   <p:with-param name="step-name" select="'validate-business-rules'"/> -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!--   <p:with-option name="active" select="$check"/> -->
  <!-- </bc:validate-with-schematron> -->
  
  <!-- <letex:validate-with-rng-PI name="rng2pi"> -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!--   <p:input port="schema"> -->
  <!--     <p:pipe port="schema" step="docx2epub"/> -->
  <!--   </p:input> -->
  <!--   <p:input port="source"> -->
  <!--     <p:pipe port="result" step="evolve-hub-dyn"/> -->
  <!--   </p:input> -->
  <!-- </letex:validate-with-rng-PI> -->
  
  <!-- <letex:store-debug pipeline-step="rngvalid/with-PIs"> -->
  <!--   <p:with-option name="active" select="$debug"/> -->
  <!--   <p:with-option name="base-uri" select="$debug-dir-uri"/> -->
  <!-- </letex:store-debug> -->
  
  <!-- <transpect:errorPI2svrl name="errorPI2svrl" severity="error"> -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!--   <p:input port="report-in"> -->
  <!--     <p:pipe port="report" step="validate-business-rules"/> -->
  <!--   </p:input> -->
  <!-- </transpect:errorPI2svrl> -->
  
    
  <!-- <transpect:patch-svrl name="htmlreport"> -->
  <!--   <p:input port="svrl"> -->
  <!--     <p:pipe step="errorPI2svrl" port="report"/> -->
  <!--   </p:input> -->
  <!--   <p:input port="params"> -->
  <!--     <p:pipe port="result" step="paths"/> -->
  <!--   </p:input> -->
  <!--   <p:with-option name="severity-default-name" select="'Warning'"/>     -->
  <!--   <p:with-option name="report-title" select="/c:param-set/c:param[@name eq 'work-basename']/@value"> -->
  <!--     <p:pipe port="result" step="paths"/> -->
  <!--   </p:with-option> -->
  <!--   <p:with-option name="debug" select="$debug"/> -->
  <!--   <p:with-option name="debug-dir-uri" select="$debug-dir-uri"/> -->
  <!-- </transpect:patch-svrl> -->
  
  
</p:declare-step>