<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:pb="http://tidalwave.it/ns/photobook#1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="photoPath"/>
    <xsl:param name="format"/>
    
    <xsl:variable name="horizontalMargin">20</xsl:variable>
    <xsl:variable name="verticalMargin">20</xsl:variable>
    
    <xsl:include href="sizes.xslt" />
    <xsl:include href="commons.xslt" />
    <xsl:include href="xhtml5-fo.xslt" />
    
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master 
                    master-name="white-page" 
                    page-width="{$pageWidth}{$unit}" 
                    page-height="{$pageHeight}{$unit}">
                    <fo:region-body/>
                </fo:simple-page-master>
                <fo:simple-page-master 
                    master-name="black-page" 
                    page-width="{$pageWidth}{$unit}" 
                    page-height="{$pageHeight}{$unit}">
                    <fo:region-body 
                        background-color="black"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:declarations>
                <xsl:call-template name="adobe-metadata">
                    <xsl:with-param name="title" select="pb:title"/>
                    <xsl:with-param name="subtitle" select="pb:subtitle"/>
                    <xsl:with-param name="author" select="pb:author"/>
                </xsl:call-template>                
            </fo:declarations>

            <xsl:apply-templates/>

        </fo:root>
    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template match="pb:photobook">
        <xsl:call-template name="page-template-odd-white">
            <xsl:with-param name="masterPage">white-page</xsl:with-param>
            <xsl:with-param name="contents">
                <xsl:call-template name="title-page">
                    <xsl:with-param name="title" select="pb:title"/>
                    <xsl:with-param name="subtitle" select="pb:subtitle"/>
                    <xsl:with-param name="author" select="pb:author"/>
                </xsl:call-template>                
            </xsl:with-param>
        </xsl:call-template> 
        
        <xsl:call-template name="page-template-even-white">
            <xsl:with-param name="masterPage">white-page</xsl:with-param>
            <xsl:with-param name="showPageNumber">false</xsl:with-param>
            <xsl:with-param name="contents">
                <xsl:call-template name="colophony"/>
            </xsl:with-param>
        </xsl:call-template> 
        
        <xsl:call-template name="page-template-odd-white">
            <xsl:with-param name="masterPage">white-page</xsl:with-param>
            <xsl:with-param name="contents">
                <fo:block>
                    <xsl:if test="$insideFlapWidth = 0">
                        <xsl:variable name="w" select="$usablePageWidth * 0.55"/> 
                        <fo:block-container 
                            position="absolute" 
                            right="0pt" 
                            top="0pt"
                            width="{$w}{$unit}" 
                            height="{$usablePageHeight}{$unit}"
                            overflow="hidden">
                            <fo:block 
                                text-align="right"
                                color="black"
                                margin-top="2cm"
                                margin-bottom="5mm"
                                margin-left="20mm"
                                margin-right="5mm"
                                font-family="Muli"  
                                font-weight="300"
                                font-style="italic"
                                font-size="10pt">
                                <xsl:apply-templates select="/pb:photobook/pb:fragment[@id='frontInsideFlap']"/>
                            </fo:block>    
                        </fo:block-container> 
                    </xsl:if>
                </fo:block>
            </xsl:with-param>
        </xsl:call-template> 
        
        <xsl:apply-templates select="pb:photo"/>
        
        <xsl:call-template name="page-template-even-white">
            <xsl:with-param name="masterPage">white-page</xsl:with-param>
            <xsl:with-param name="showPageNumber">false</xsl:with-param>
            <xsl:with-param name="contents">
                <fo:block 
                    text-align="left"
                    color="black"
                    margin-top="2cm"
                    margin-bottom="5mm"
                    margin-left="20mm"
                    margin-right="5mm"
                    font-family="Muli"  
                    font-weight="300"
                    font-style="plain"
                    font-size="8pt">
                    <xsl:apply-templates select="/pb:photobook/pb:fragment[@id='scientific-and-common-names']"/>
                </fo:block>    
            </xsl:with-param>
        </xsl:call-template> 

    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template match="pb:photo">
        <xsl:call-template name="page-template-even-white">
            <xsl:with-param name="masterPage">white-page</xsl:with-param>
            <xsl:with-param name="contents">
                <xsl:call-template name="templated-text">
                    <xsl:with-param name="template">species-and-location</xsl:with-param>
                    <xsl:with-param name="placeHolder1">@species</xsl:with-param>
                    <xsl:with-param name="value1" select="pb:species"/>
                    <xsl:with-param name="placeHolder2">@location</xsl:with-param>
                    <xsl:with-param name="value2" select="pb:location"/>
                </xsl:call-template>                
            </xsl:with-param>
        </xsl:call-template> 
        <xsl:call-template name="page-template-photo">
            <xsl:with-param name="masterPage">black-page</xsl:with-param>
            <xsl:with-param name="photoId" select="@id"/>
            <xsl:with-param name="bottomCaption">
                <fo:block 
                    font-family="{$captionFontFamily}"
                    font-size="8pt"
                    font-weight="300"
                    color="{$textGreyColor}" 
                    text-align="center">
                    <xsl:value-of select="pb:caption"/>
                </fo:block>                                                                          
            </xsl:with-param>
        </xsl:call-template>        
    </xsl:template>
</xsl:stylesheet>
