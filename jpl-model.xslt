
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
    <xsl:output method="text"/>
    <xsl:variable name="className" select="/entity/@class"/>
    <!--
    ********************************************************************
    ** Generate the model skeleton. 
    ** Foreign keys are not currently supported and need to be manually added  
    *****************************************************************-->
    <xsl:template match="/entity">
        <xsl:text>package models;

import java.util.Date;
import javax.persistence.*;

@Entity
public class </xsl:text>
        <xsl:value-of select="$className"/>
        <xsl:text>
{
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
	</xsl:text>
    <xsl:apply-templates mode="generateField" select="property"/>
    <xsl:text>
     /**
     * Constructor
     */
    public </xsl:text>
        <xsl:value-of select="$className"/><xsl:text>() {}
	    
    public </xsl:text>
        <xsl:value-of select="$className"/>(<xsl:apply-templates mode="generateConstructorParam" select="property"/>
        <xsl:text>) {</xsl:text>
        <xsl:apply-templates mode="generateInitializers" select="property"/>
     }
     <xsl:apply-templates mode="generateGetterSetter" select="property"/>
}</xsl:template><!--
    *****************************************************************
    ** Generate a private field declaration.
    **************************************************************-->
    <xsl:template match="property" mode="generateField">
    <xsl:if test="@type='Date'"><xsl:text> 
    </xsl:text>@Temporal(TemporalType.TIMESTAMP)</xsl:if>
    private <xsl:value-of select="@type"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name"/>;</xsl:template><!--
    *****************************************************************
    ** Generate a "get" method for a property.
    **************************************************************-->
    <xsl:template match="property" mode="generateGetterSetter">
    public <xsl:value-of select="@type"/>
        <xsl:text> get</xsl:text>
        <xsl:value-of select="functx:uppercase-first(@name)"/>() {
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
    <xsl:template match="property" mode="generateConstructorParam">
        <xsl:text xml:space="preserve"></xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:if test="position() != last( )">, </xsl:if>
    </xsl:template><!--
    *****************************************************************
    ** Generate the initialization code inside of the constructor.
    **************************************************************-->
    <xsl:template match="property" mode="generateInitializers">
        <xsl:text xml:space="preserve">
		this.</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text> = </xsl:text>
        <xsl:value-of select="@name"/>;</xsl:template>
    
    <xsl:function as="xs:string?" name="functx:uppercase-first" xmlns:functx="http://www.functx.com">
        <xsl:param as="xs:string?" name="arg"/>
        <xsl:sequence select="    concat(upper-case(substring($arg,1,1)),              substring($arg,2))  "/>
    </xsl:function>
    <xsl:function as="xs:string?" name="functx:lowercase-first" xmlns:functx="http://www.functx.com">
        <xsl:param as="xs:string?" name="arg"/>
        <xsl:sequence select="    concat(lower-case(substring($arg,1,1)),              substring($arg,2)) "/>
    </xsl:function>
</xsl:stylesheet>
