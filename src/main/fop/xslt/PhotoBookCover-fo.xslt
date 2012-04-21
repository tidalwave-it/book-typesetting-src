<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:pb="http://tidalwave.it/ns/photobook#1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="photoPath"/>
    <xsl:param name="format"/>

    <xsl:variable name="horizontalMargin">0</xsl:variable>
    <xsl:variable name="verticalMargin">0</xsl:variable>
    
    <xsl:include href="sizes.xslt" />
    <xsl:include href="commons.xslt" />
    <xsl:include href="xhtml5-fo.xslt" />

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template match="/" >
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master 
                    master-name="cover" 
                    page-width="{$coverWidth}{$unit}" 
                    page-height="{$coverHeight}{$unit}" 
                    margin="0pt">
                    <fo:region-body background-color="{$coverBackgroundColor}" />
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
        <xsl:variable name="title" select="pb:title"/>
        <xsl:variable name="subtitle" select="pb:subtitle"/>
        <xsl:variable name="author" select="pb:author"/>
        
        <fo:page-sequence master-reference="cover">
            <fo:flow 
                flow-name="xsl-region-body"> 

                <!-- back cover -->
                <fo:block-container 
                    position="absolute" 
                    left="0pt" 
                    top="0pt"
                    width="{$flapWidth}{$unit}" 
                    height="{$coverHeight}{$unit}">
                    <!-- TODO: call front-cover -->
                    <fo:table 
                        table-layout="fixed" 
                        width="100%">
                        <fo:table-column 
                            column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <fo:table-row
                                height="{$coverHeight}{$unit}">
                                <fo:table-cell 
                                    display-align="center">
                                    <fo:table 
                                        table-layout="fixed"
                                        width="100%">
                                        <fo:table-body>
                                            <fo:table-row>
                                                <fo:table-cell>
                                                    <fo:block 
                                                        text-align="right">
                                                        <fo:external-graphic 
                                                            width="{$flapWidth}{$unit}" 
                                                            height="{$coverHeight}{$unit}" 
                                                            content-width="scale-to-fit"
                                                            content-height="scale-to-fit" 
                                                            src="{$photoPath}/{pb:back-cover-photo/@id}.jpg"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </fo:table-body>
                                    </fo:table>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:block-container>                

                <!-- spine -->
                <fo:block-container
                    position="absolute" 
                    left="{$flapWidth}{$unit}" 
                    top="0pt"
                    width="{$gutterWidth}{$unit}" 
                    height="{$coverHeight}{$unit}">
                    <fo:block-container 
                        height="{$gutterWidth}{$unit}" 
                        width="{$coverHeight}{$unit}"
                        reference-orientation="-90">                                                        
                        <fo:table 
                            table-layout="fixed"
                            width="100%">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-column column-width="{$coverHeight}{$unit}"/>
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-body>
                                <xsl:variable name="fontSize" select="0.6 * $gutterWidth"/>
                                <fo:table-row
                                    height="{$gutterWidth}{$unit}">
                                    <fo:table-cell
                                        column-number="2" 
                                        display-align="center">
                                        <fo:block 
                                            color="rgb(255,255,255)"
                                            font-family="Gruppo" 
                                            font-weight="normal"
                                            font-size="{$fontSize}pt"
                                            text-align="center">
                                            <xsl:value-of select="$title"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$subtitle"/>
                                            <xsl:text> - </xsl:text>
                                            <fo:inline 
                                                font-size="60%">
                                                <xsl:value-of select="$author"/>
                                            </fo:inline>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>            
                    </fo:block-container>                
                </fo:block-container>                

                <!-- front cover -->
                <fo:block-container 
                    position="absolute" 
                    right="0pt" 
                    top="0pt"
                    width="{$flapWidth}{$unit}" 
                    height="{$coverHeight}{$unit}">

                    <xsl:call-template name="front-cover">
                        <xsl:with-param name="photoId" select="pb:front-cover-photo/@id"/>
                        <xsl:with-param name="width" select="$flapWidth"/>
                        <xsl:with-param name="height" select="$coverHeight"/>
                        <xsl:with-param name="align">left</xsl:with-param>
                        <xsl:with-param name="span">full-height</xsl:with-param>
                    </xsl:call-template> 
                    
                    <fo:block-container 
                        position="absolute" 
                        left="0pt" 
                        top="{$topCoverMargin}{$unit}"
                        width="{$usableSemiCoverWidth}{$unit}" 
                        height="{$usableCoverHeight}{$unit}">
                        <xsl:call-template name="front-cover-overlay">
                            <xsl:with-param name="title" select="$title"/>
                            <xsl:with-param name="subtitle" select="$subtitle"/>
                            <xsl:with-param name="author" select="$author"/>
                        </xsl:call-template> 
                    </fo:block-container>                
                    
                    <!-- front inside flap -->
                    <xsl:if test="$insideFlapWidth > 0">
                        <fo:block-container 
                            position="absolute" 
                            right="{$bleed}{$unit}" 
                            top="{$topCoverMargin}{$unit}"
                            width="{$insideFlapWidth}{$unit}" 
                            height="{$usableCoverHeight}{$unit}"
                            overflow="hidden">
                            <fo:block 
                                color="white"
                                margin-left="20mm"
                                margin-right="5mm"
                                font-family="Muli"  
                                font-weight="300"
                                font-style="italic"
                                font-size="16pt">
                                <xsl:apply-templates select="/pb:photobook/pb:fragment[@id='frontInsideFlap']"/>
                            </fo:block>    
                        </fo:block-container>                
                    </xsl:if>
                    
                </fo:block-container>                
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
</xsl:stylesheet>
