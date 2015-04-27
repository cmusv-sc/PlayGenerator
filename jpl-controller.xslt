
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
    <xsl:output method="text"/>
    <xsl:variable name="className" select="/dependentObject/@class"/>
    <xsl:variable name="repositoryName" select="concat(functx:lowercase-first($className),'Repository')"/>
    <xsl:variable name="varName" select="functx:lowercase-first($className)"/>
    <!--
    ********************************************************************
    ** Generate the class skeleton. Other templates will generate
    ** portions of the class.
    *****************************************************************-->
    <xsl:template match="/dependentObject">
        <xsl:text>package controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;
import javax.persistence.PersistenceException;

import com.fasterxml.jackson.databind.JsonNode;
import com.google.gson.Gson;

import models.</xsl:text><xsl:value-of select="$className"/>
<xsl:text>;
import models.</xsl:text><xsl:value-of select="$className"/><xsl:text>Repository;

import play.mvc.*;

@Named
@Singleton
public class </xsl:text>
        <xsl:value-of select="$className"/>
        <xsl:text>Controller extends Controller {

    private final </xsl:text><xsl:value-of select="$className"/><xsl:text>Repository </xsl:text><xsl:value-of select="$repositoryName"/><xsl:text>;
    
    @Inject
	public </xsl:text><xsl:value-of select="$className"/><xsl:text>Controller(</xsl:text><xsl:value-of select="$className"/><xsl:text>Repository </xsl:text><xsl:value-of select="$repositoryName"/><xsl:text>) {
		this.</xsl:text><xsl:value-of select="$repositoryName"/><xsl:text> = </xsl:text><xsl:value-of select="$repositoryName"/><xsl:text>;
	}
	
	public Result add</xsl:text><xsl:value-of select="$className"/><xsl:text>() {
		JsonNode json = request().body().asJson();
    	if (json == null) {
    		System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved, expecting Json data");
			return badRequest("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved, expecting Json data");
        }
		
		</xsl:text>
        <xsl:apply-templates mode="deserialize" select="property"/>
        <xsl:text>
        try {
			</xsl:text><xsl:value-of select="$className"/><xsl:text> </xsl:text><xsl:value-of select="$varName"/><xsl:text> = new </xsl:text><xsl:value-of select="$className"/><xsl:text>(</xsl:text>
            <xsl:apply-templates mode="generateConstructorParam" select="property"/>);
            <xsl:value-of select="$repositoryName"/><xsl:text>.save(</xsl:text><xsl:value-of select="$varName"/><xsl:text>);
            System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> saved: " + </xsl:text><xsl:value-of select="$varName"/><xsl:text>.getId());
			return created(new Gson().toJson(</xsl:text><xsl:value-of select="$varName"/><xsl:text>.getId()));
		} catch (PersistenceException pe) {
			pe.printStackTrace();
			System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved");
			return badRequest("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved");
		}
	}
	
    public Result delete</xsl:text><xsl:value-of select="$className"/><xsl:text>(Long id) {
		</xsl:text><xsl:call-template name="getInstanceFromRepository"/>
		if (<xsl:value-of select="$varName"/><xsl:text> == null) {
			System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> not found with id: " + id);
			return notFound("</xsl:text><xsl:value-of select="$className"/><xsl:text> not found with id: " + id);
		}

		userRepository.delete(</xsl:text><xsl:value-of select="$varName"/><xsl:text>);
		System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> is deleted: " + id);
		return ok("</xsl:text><xsl:value-of select="$className"/><xsl:text> is deleted: " + id);
	}
	
    public Result update</xsl:text><xsl:value-of select="$className"/><xsl:text>(long id) {
		JsonNode json = request().body().asJson();
		if (json == null) {
			System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved, expecting Json data");
			return badRequest("</xsl:text><xsl:value-of select="$className"/><xsl:text> not saved, expecting Json data");
		}
		</xsl:text>
        <xsl:apply-templates mode="deserialize" select="property"/>
        try {
            <xsl:call-template name="getInstanceFromRepository"/><xsl:text>
            </xsl:text>
            <xsl:apply-templates mode="generateUpdateStatement" select="property"/>
        <xsl:text>
            System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> updated");
			return created("</xsl:text><xsl:value-of select="$className"/><xsl:text> updated");
		} catch (PersistenceException pe) {
			pe.printStackTrace();
			System.out.println("</xsl:text><xsl:value-of select="$className"/><xsl:text> not updated");
			return badRequest("</xsl:text><xsl:value-of select="$className"/><xsl:text> not updated");
		}
	}
            
            </xsl:text>
        }</xsl:template><!--
    *****************************************************************
    ** Generate a deserialization from json
    **************************************************************-->
    <xsl:template match="property" mode="deserialize">
        <xsl:value-of select="@type"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text> = json.findPath("</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>").asText();
        </xsl:text>
        </xsl:template><!--
    *****************************************************************
    ** Generate a "get" method for a property.
    **************************************************************-->
    <xsl:template match="property" mode="generateUpdateStatement">
            <xsl:value-of select="$varName"/>.set<xsl:value-of select="functx:uppercase-first(@name)"/>(<xsl:value-of select="@name"/><xsl:text>);
            </xsl:text>
    </xsl:template>
    <!--
    *****************************************************************
    ** Generate a update statement
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
    <xsl:template match="property" mode="generateConstructorParam">
        <xsl:text xml:space="preserve"></xsl:text>
    
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
        <xsl:value-of select="@name"/>;
    </xsl:template>
    <!--
    *****************************************************************
    ** Generate the get by ID using repository line
    **************************************************************-->
    <xsl:template name="getInstanceFromRepository">
        <xsl:value-of select="$className"/><xsl:text> </xsl:text><xsl:value-of select="$varName"/><xsl:text> = </xsl:text><xsl:value-of select="$repositoryName"/>.findOne(id);
    </xsl:template>
    
    <xsl:function as="xs:string?" name="functx:uppercase-first" xmlns:functx="http://www.functx.com">
        <xsl:param as="xs:string?" name="arg"/>
        <xsl:sequence select="    concat(upper-case(substring($arg,1,1)),              substring($arg,2))  "/>
    </xsl:function>
    <xsl:function as="xs:string?" name="functx:lowercase-first" xmlns:functx="http://www.functx.com">
        <xsl:param as="xs:string?" name="arg"/>
        <xsl:sequence select="    concat(lower-case(substring($arg,1,1)),              substring($arg,2)) "/>
    </xsl:function>
</xsl:stylesheet>
