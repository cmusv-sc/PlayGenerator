
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
	<xsl:output method="text"/>
	<xsl:variable name="className" select="/dependentObject/@class"/>
  <!--
    ********************************************************************
    ** Generate the class skeleton. Other templates will generate
    ** portions of the class.
    *****************************************************************-->
	<xsl:template match="/dependentObject">
		<xsl:text>package models;

import org.springframework.data.repository.CrudRepository;

import javax.inject.Named;
import javax.inject.Singleton;

@Named
@Singleton
public interface </xsl:text>
    <xsl:value-of select="$className"/>
		<xsl:text>Repository extends CrudRepository&lt;</xsl:text>
	    <xsl:value-of select="$className"/>
	    <xsl:text>, Long&gt; {
}</xsl:text>
</xsl:template>
</xsl:stylesheet>
