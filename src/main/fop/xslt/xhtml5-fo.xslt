<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xhtml="http://www.w3.org/1999/xhtml">

<!--    <xsl:template match="@* | node()" mode="xhtml5">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="xhtml5"/>
        </xsl:copy>
    </xsl:template>-->

    <xsl:template match="text()" mode="xhtml5">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="xhtml:body" mode="xhtml5">
        <xsl:apply-templates select="* | text()" mode="xhtml5"/>
    </xsl:template>
    
    <xsl:template match="xhtml:b" mode="xhtml5">
        <fo:inline font-weight="bold">
            <xsl:apply-templates select="* | text()" mode="xhtml5"/>
        </fo:inline>
    </xsl:template>
    
    <xsl:template match="xhtml:i" mode="xhtml5">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="* | text()" mode="xhtml5"/>
        </fo:inline>
    </xsl:template>
    
    <!-- FIXME: use style instead -->
    <xsl:template match="xhtml:div" mode="xhtml5">
        <xsl:element name="block" namespace="http://www.w3.org/1999/XSL/Format">
            <xsl:if test="@margin-top">
                <xsl:attribute name="space-before">
                    <xsl:value-of select="@margin-top"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@margin-bottom">
                <xsl:attribute name="space-after">
                    <xsl:value-of select="@margin-bottom"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="* | text()" mode="xhtml5"/>
        </xsl:element>
    </xsl:template>
    
    <!-- FIXME: HTML5 doesn't allow <font>, use <span> with style instead -->
    <xsl:template match="xhtml:font" mode="xhtml5">
        <xsl:element name="inline" namespace="http://www.w3.org/1999/XSL/Format">
            <xsl:if test="@color">
                <xsl:attribute name="color">
                    <xsl:value-of select="@color"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@face">
                <xsl:attribute name="font-family">
                    <xsl:value-of select="@face"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@size">
                <xsl:attribute name="font-size">
                    <xsl:value-of select="@size"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@font-weight">
                <xsl:attribute name="font-weight">
                    <xsl:value-of select="@font-weight"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="* | text()" mode="xhtml5"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xhtml:br" mode="xhtml5">
        <fo:block> </fo:block>
    </xsl:template>
    
    <xsl:template match="xhtml:nobr" mode="xhtml5">
        <fo:inline wrap-option="no-wrap">
            <xsl:apply-templates select="* | text()" mode="xhtml5"/>
        </fo:inline>
    </xsl:template>

</xsl:stylesheet>
