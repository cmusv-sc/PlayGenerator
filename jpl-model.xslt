
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
	<xsl:output method="text" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
	<xsl:variable name="className" select="/dependentObject/@class" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
  <!--
    ********************************************************************
    ** Generate the class skeleton. Other templates will generate
    ** portions of the class.
    *****************************************************************-->
	<xsl:template match="/dependentObject" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">package models;

import java.util.Date;
import javax.persistence.*;

@Entity
public class </xsl:text>
    <xsl:value-of select="$className" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
{
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
		</xsl:text>
		<xsl:apply-templates mode="generateField" select="property" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:text>
     /**
     * Constructor
     */
    public </xsl:text>
		<xsl:value-of select="$className" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>(<xsl:apply-templates mode="generateConstructorParam" select="property" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
	  <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">) {
	  </xsl:text><xsl:apply-templates mode="generateInitializers" select="property" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
	  }
    <xsl:apply-templates mode="generateGetterSetter" select="property" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
}</xsl:template><!--
    *****************************************************************
    ** Generate a private field declaration.
    **************************************************************-->
	<xsl:template match="property" mode="generateField" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	private <xsl:value-of select="@type" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> </xsl:text>
		<xsl:value-of select="@name" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>;</xsl:template><!--
    *****************************************************************
    ** Generate a "get" method for a property.
    **************************************************************-->
    <xsl:template match="property" mode="generateGetterSetter">
    public <xsl:value-of select="@type"/>
      <xsl:text> get</xsl:text>
      <xsl:value-of select="functx:uppercase-first(@name)"/>( ) {
        return this.<xsl:value-of select="@name"/>;
    }
    public void set<xsl:value-of select="functx:uppercase-first(@name)"/><xsl:text>(</xsl:text><xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>) {
        this.<xsl:value-of select="@name"/> = <xsl:value-of select="@name"/>;
    }
    </xsl:template>
    <!--
    *****************************************************************
    ** Generate one of the constructor parameters.
    **************************************************************-->
	<xsl:template match="property" mode="generateConstructorParam" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:text xml:space="preserve" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace"></xsl:text>
		<xsl:value-of select="@type" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> </xsl:text>
		<xsl:value-of select="@name" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:if test="position() != last( )" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">, </xsl:if>
	</xsl:template><!--
    *****************************************************************
    ** Generate the initialization code inside of the constructor.
    **************************************************************-->
	<xsl:template match="property" mode="generateInitializers" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:text xml:space="preserve" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
		this.</xsl:text>
		<xsl:value-of select="@name" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> = </xsl:text>
		<xsl:value-of select="@name" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>;</xsl:template>
    
	<xsl:function as="xs:string?" name="functx:uppercase-first" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:functx="http://www.functx.com">
		<xsl:param as="xs:string?" name="arg" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:sequence select="    concat(upper-case(substring($arg,1,1)),              substring($arg,2))  " xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
	</xsl:function>
	<xsl:function as="xs:string?" name="functx:lowercase-first" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:functx="http://www.functx.com">
		<xsl:param as="xs:string?" name="arg" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
		<xsl:sequence select="    concat(lower-case(substring($arg,1,1)),              substring($arg,2)) " xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
	</xsl:function>
</xsl:stylesheet>
