<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- ***************************************************************************************************************
    *
    * 
    *
    **************************************************************************************************************** -->
    <xsl:template name="replace-substring">
        <xsl:param name="original"/>
        <xsl:param name="substring"/>
        <xsl:param name="replacement" select="''"/>
        <xsl:choose>
            <xsl:when test="contains($original, $substring)">
                <xsl:value-of select="substring-before($original, $substring)"/>
                <xsl:copy-of select="$replacement"/>
                <xsl:call-template name="replace-substring">
                    <xsl:with-param name="original" select="substring-after($original, $substring)"/>
                    <xsl:with-param name="substring" select="$substring"/>
                    <xsl:with-param name="replacement" select="$replacement"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$original"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <!-- ***************************************************************************************************************
    *
    * 
    *
    **************************************************************************************************************** -->
    <xsl:template name="substring-before-last">
        <xsl:param name="original"/>
        <xsl:param name="substring"/>
        
        <xsl:if test="contains($original, $substring)">
            <xsl:value-of select="substring-before($original, $substring)"/>
            <xsl:value-of select="$substring"/>
            <xsl:call-template name="substring-before-last">
                <xsl:with-param name="original" select="substring-after($original, $substring)"/>
                <xsl:with-param name="substring" select="$substring"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template> 
    
    <!-- ***************************************************************************************************************
    *
    * 
    *
    **************************************************************************************************************** -->
    <xsl:template name="substring-after-last">
        <xsl:param name="original"/>
        <xsl:param name="substring"/>
        
        <xsl:choose>
            <xsl:when test="contains($original, $substring)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="original" select="substring-after($original, $substring)"/>
                    <xsl:with-param name="substring" select="$substring"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$original"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>