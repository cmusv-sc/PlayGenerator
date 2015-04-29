
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
	<xsl:output method="text"/>
	<xsl:variable name="className" select="/entity/@class"/>
  <xsl:variable name="varName" select="functx:lowercase-first($className)"/>
  <!--
    ********************************************************************
    ** Generate part of the routes file
    *****************************************************************-->
	<xsl:template match="/entity">
# <xsl:value-of select="$className"/>
GET     /<xsl:value-of select="$className"/>/get<xsl:value-of select="$className"/>/:id     @controllers.<xsl:value-of select="$className"/>Controller.get<xsl:value-of select="$className"/>(id: Long, format: String="json")
GET     /<xsl:value-of select="$className"/>/getAll<xsl:value-of select="$className"/>     @controllers.<xsl:value-of select="$className"/>Controller.getAll<xsl:value-of select="$className"/>(format: String="json")
POST    /<xsl:value-of select="$className"/>/add<xsl:value-of select="$className"/>     @controllers.<xsl:value-of select="$className"/>Controller.add<xsl:value-of select="$className"/>
PUT     /<xsl:value-of select="$className"/>/update<xsl:value-of select="$className"/>/:id     @controllers.<xsl:value-of select="$className"/>Controller.update<xsl:value-of select="$className"/>(id: Long)
DELETE  /<xsl:value-of select="$className"/>/delete<xsl:value-of select="$className"/>/:id     @controllers.<xsl:value-of select="$className"/>Controller.delete<xsl:value-of select="$className"/>(id: Long)
</xsl:template>
  <xsl:function as="xs:string?" name="functx:lowercase-first" xmlns:functx="http://www.functx.com">
    <xsl:param as="xs:string?" name="arg"/>
    <xsl:sequence select="    concat(lower-case(substring($arg,1,1)),              substring($arg,2)) "/>
  </xsl:function>
</xsl:stylesheet>
