<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:redirect="http://xml.apache.org/xalan/redirect"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:pb="http://tidalwave.it/ns/photobook#1.0"
                extension-element-prefixes="redirect">

    <xsl:include href="StringUtils.xslt" />
    <xsl:include href="xhtml5-fo.xslt" />
    
    <xsl:variable name="textGreyColor">rgb(90, 90, 90)</xsl:variable> <!-- note this is repeated in other places -->
    <xsl:variable name="captionFontFamily">Muli</xsl:variable>
    <xsl:variable name="titleFontFamily">Lusitana</xsl:variable>
    <xsl:variable name="coverBackgroundColor">rgb(47,75,94)</xsl:variable>
    <xsl:variable name="pageHorizontalMargin">2cm</xsl:variable>
    <xsl:variable name="pageVerticalMargin">1cm</xsl:variable>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template match="pb:fragment">
        <fo:block>
            <xsl:apply-templates select="node()" mode="xhtml5"/>
<!--            <xsl:apply-templates select="@* | node()" mode="xhtml5"/>-->
        </fo:block>
    </xsl:template>
    
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="adobe-metadata">
        <xsl:param name="title"/>
        <xsl:param name="subtitle"/>
        <xsl:param name="author"/>
        
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
            <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <rdf:Description rdf:about=""
                                 xmlns:dc="http://purl.org/dc/elements/1.1/">
                    <dc:title>
                        <xsl:value-of select="title"/>
                    </dc:title>
                    <dc:creator>
                        <xsl:value-of select="author"/>
                    </dc:creator>
                    <dc:description>
                        <xsl:value-of select="subtitle"/>
                    </dc:description>
                </rdf:Description>
                <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
                    <xmp:CreatorTool>Apache FOP</xmp:CreatorTool>
                </rdf:Description>
            </rdf:RDF>
        </x:xmpmeta>
    </xsl:template>
    
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="front-cover">
        <xsl:param name="photoId"/>
        <xsl:param name="width"/>
        <xsl:param name="height"/>
        <xsl:param name="align"/>
        <xsl:param name="span">fit</xsl:param>
        
        <xsl:variable name="w">
            <xsl:choose>
                <xsl:when test="$span = 'full-width'">
                    <xsl:value-of select="$width"/>
                    <xsl:value-of select="$unit"/>
                </xsl:when>
                <xsl:when test="$span = 'full-height'">
                    <xsl:text>99cm</xsl:text>
                </xsl:when>
                <xsl:when test="$span = 'fit'">
                    <xsl:value-of select="$width"/>
                    <xsl:value-of select="$unit"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable> 
        <xsl:variable name="h">
            <xsl:choose>
                <xsl:when test="$span = 'full-width'">
                    <xsl:text>99cm</xsl:text>
                </xsl:when>
                <xsl:when test="$span = 'full-height'">
                    <xsl:value-of select="$height"/>
                    <xsl:value-of select="$unit"/>
                </xsl:when>
                <xsl:when test="$span = 'fit'">
                    <xsl:value-of select="$height"/>
                    <xsl:value-of select="$unit"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable> 
        <xsl:variable name="cellAlign">
            <xsl:choose>
                <xsl:when test="$span = 'full-width'">
                    <xsl:text>before</xsl:text>
                </xsl:when>
                <xsl:when test="$span = 'full-height'">
                    <xsl:text>before</xsl:text>
                </xsl:when>
                <xsl:when test="$span = 'fit'">
                    <xsl:text>center</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable> 
        
        <fo:table 
            table-layout="fixed"
            width="100%">
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-body>
                <fo:table-row
                    height="{$h}">
                    <fo:table-cell                   
                        display-align="{$cellAlign}">
                        <fo:table 
                            table-layout="fixed" 
                            width="100%">
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block 
                                            text-align="{$align}">
                                            <fo:external-graphic 
                                                width="{$w}" 
                                                height="{$h}" 
                                                content-width="scale-to-fit"
                                                content-height="scale-to-fit" 
                                                src="{$photoPath}/{$photoId}.jpg"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="front-cover-overlay">
        <xsl:param name="title"/>
        <xsl:param name="subtitle"/>
        <xsl:param name="author"/>
        
        <fo:block-container 
            position="absolute" 
            left="2cm" 
            top="0cm"
            width="5cm" 
            height="3cm">
            <fo:block 
                color="rgb(217,217,218)"
                font-family="{$titleFontFamily}"  
                font-weight="bold"
                font-size="80pt">
                <xsl:value-of select="$title"/>
            </fo:block>
            <!-- portfolio 1 must be aligned with the vertical part of Birds - no serif, using margin-left -->
            <fo:block 
                color="rgb(217,217,218)"
                line-height="4mm"
                margin-left="2mm"
                font-family="{$titleFontFamily}"  
                font-weight="normal"
                font-size="30pt">
                <xsl:value-of select="$subtitle"/>
            </fo:block>
        </fo:block-container>                
        <fo:block-container 
            position="absolute" 
            right="2cm" 
            bottom="0cm"
            width="10cm" 
            height="1cm">
            <fo:block
                color="rgb(217,217,218)"
                font-family="{$titleFontFamily}"  
                font-weight="normal"
                font-size="24pt"
                text-align="right">
                <xsl:value-of select="$author"/>
            </fo:block>
        </fo:block-container>                
    </xsl:template>
    
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="title-page">
        <xsl:param name="title"/>
        <xsl:param name="subtitle"/>
        <xsl:param name="author"/>
        
        <fo:table
            table-layout="fixed" 
            width="100%">
            <fo:table-column column-width="{$pageHorizontalMargin}"/>
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="{$pageHorizontalMargin}"/>
            <fo:table-body>
                <fo:table-row height="{$usablePageHeight}{$unit}">
                    <fo:table-cell 
                        column-number="2" 
                        display-align="center">
                        <fo:block 
                            font-family="Lusitana"
                            font-size="120pt" 
                            text-align="center"
                            font-weight="bold">
                            <xsl:value-of select="$title"/>
                        </fo:block>
                        <fo:block 
                            font-family="Lusitana"
                            font-size="40pt" 
                            text-align="center"
                            color="{$textGreyColor}">
                            <xsl:value-of select="$subtitle"/>
                        </fo:block>
                        <fo:block 
                            space-before="3cm"
                            font-family="Lusitana"
                            font-size="20pt" 
                            text-align="center">
                            <xsl:value-of select="$author"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>            
    </xsl:template>
    
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="colophony">
        <fo:block-container 
            position="absolute" 
            left="0pt" 
            top="0pt"
            width="100%" 
            height="100%">
            <fo:table 
                table-layout="fixed"
                width="100%"
                height="{$usablePageHeight}{$unit}">
                <fo:table-column column-width="proportional-column-width(0.67)"/>
                <fo:table-column column-width="{$pageHorizontalMargin}"/>
                <fo:table-column column-width="proportional-column-width(0.33)"/>
                <fo:table-body>
                    <fo:table-row height="{$usablePageHeight}{$unit}">
                        <fo:table-cell 
                            column-number="1" 
                            display-align="after">
                            <fo:block>
                                <xsl:apply-templates select="/pb:photobook/pb:fragment[@id='copyright']"/>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell 
                            column-number="3" 
                            display-align="after">
                            <fo:block>
                                <fo:external-graphic
                                    width="6cm" 
                                    height="6cm" 
                                    content-width="scale-to-fit"
                                    content-height="scale-to-fit" 
                                    src="{$photoPath}/20070923-0031.jpg"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>            
        </fo:block-container>                
    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="templated-text">
        <xsl:param name="template"/>
        <xsl:param name="placeHolder1"/>
        <xsl:param name="value1"/>
        <xsl:param name="placeHolder2"/>
        <xsl:param name="value2"/>
        
        <xsl:variable name="serializedNode">
            <xsl:apply-templates select="/pb:photobook/pb:fragment[@id=$template]/*" mode="serializer"/>
        </xsl:variable>
        <xsl:variable name="temp">
            <xsl:call-template name="replace-substring">
                <xsl:with-param name="original">
                    <xsl:call-template name="replace-substring">
                        <xsl:with-param name="original" select="$serializedNode"/>
                        <xsl:with-param name="substring" select="$placeHolder1"/>
                        <xsl:with-param name="replacement" select="$value1"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="substring" select="$placeHolder2"/>
                <xsl:with-param name="replacement" select="$value2"/>
            </xsl:call-template>
        </xsl:variable>
                                <!-- FIXME: refactor so you don't use an external file -->
        <xsl:variable name="fileName">
            <xsl:text>/tmp/</xsl:text>
            <xsl:value-of select="generate-id(.)"/>
            <xsl:text>-fragment.xml</xsl:text>
        </xsl:variable>
<!--        <xsl:variable name="fileName2">
            <xsl:text>/tmp/</xsl:text>
            <xsl:value-of select="generate-id(.)"/>
            <xsl:text>-fragment2.xml</xsl:text>
        </xsl:variable>
        <xsl:variable name="fileName3">
            <xsl:text>/tmp/</xsl:text>
            <xsl:value-of select="generate-id(.)"/>
            <xsl:text>-fragment3.xml</xsl:text>
        </xsl:variable>-->
<!--                                <xsl:value-of select="$fileName"/>-->
        <redirect:write file='{$fileName}'>
            <xsl:value-of disable-output-escaping="yes" select="$temp"/>
        </redirect:write>                               
<!--                                <xsl:apply-templates select="$temp" mode="xhtml5"/>-->
<!--                                <xsl:apply-templates select="xalan:nodeset($temp)" mode="cazzo"/>-->
        <xsl:apply-templates select="document($fileName)" mode="xhtml5"/>
    </xsl:template>
        
    <xsl:template match="text()" mode="serializer" >
        <xsl:value-of select="."/>
    </xsl:template>
        
    <xsl:template match="*" mode="serializer" >
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:value-of select="name(.)" />
        
        <xsl:if test="name(.) = 'body'">
            <xsl:text> xmlns="http://www.w3.org/1999/xhtml"</xsl:text>
        </xsl:if>
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text>='</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>'</xsl:text>
        </xsl:for-each>
         
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates select="*|text()" mode="serializer" />
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name(.)" />
        <xsl:text>&gt;</xsl:text>
    </xsl:template>    
        
    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="page-template-even-white">
        <xsl:param name="contents"/>
        <xsl:param name="masterPage"/>
        <xsl:param name="showPageNumber" select="'true'"/>
        
        <xsl:element name="page-sequence" namespace="http://www.w3.org/1999/XSL/Format">
            <xsl:attribute name="master-reference">
                <xsl:value-of select="$masterPage"/>
            </xsl:attribute>
            <fo:flow flow-name="xsl-region-body"> 
                <fo:block-container 
                    position="absolute" 
                    top="{$topMargin}{$unit}"
                    left="{$externalMargin}{$unit}"
                    width="{$usablePageWidth}{$unit}"
                    height="{$usablePageHeight}{$unit}">
                    <fo:block-container 
                        position="absolute" 
                        left="0pt" 
                        top="0pt"
                        width="100%" 
                        height="100%">
                        <fo:table 
                            table-layout="auto"
                            width="100%"
                            height="{$usablePageHeight}{$unit}">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-body>
                                <fo:table-row height="{$usablePageHeight}{$unit}">
                                    <fo:table-cell 
                                        column-number="1" 
                                        display-align="center">
                                        <fo:block>
                                            <xsl:copy-of select="$contents"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>        
                    </fo:block-container>              
                    
                    <xsl:if test="$showPageNumber = 'true'">
                        <fo:block-container 
                            position="absolute" 
                            left="0pt" 
                            top="0pt"
                            width="100%" 
                            height="100%">
                            <fo:table 
                                table-layout="auto" 
                                width="100%">
                                <fo:table-column column-width="{$usablePageWidth}{$unit}"/>
                                <fo:table-body>
                                    <fo:table-row height="{$usablePageHeight}{$unit}">
                                        <fo:table-cell 
                                            display-align="after">
                                            <fo:block 
                                                text-align="left"
                                                color="black"
                                                font-family="Muli"  
                                                font-weight="300"
                                                font-style="italic"
                                                font-size="8pt">
                                                <fo:page-number/>
                                            </fo:block>    
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block-container>  
                    </xsl:if>
                    
                </fo:block-container>
            </fo:flow>
        </xsl:element>
    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="page-template-odd-white">
        <xsl:param name="contents"/>
        <xsl:param name="masterPage"/>
        
        <xsl:element name="page-sequence" namespace="http://www.w3.org/1999/XSL/Format">
            <xsl:attribute name="master-reference">
                <xsl:value-of select="$masterPage"/>
            </xsl:attribute>
            <fo:flow flow-name="xsl-region-body"> 
                <fo:block-container 
                    position="absolute" 
                    top="{$topMargin}{$unit}"
                    right="{$externalMargin}{$unit}"
                    width="{$usablePageWidth}{$unit}"
                    height="{$usablePageHeight}{$unit}">
                    <fo:block-container 
                        position="absolute" 
                        left="0pt" 
                        top="0pt"
                        width="100%" 
                        height="100%">
                        <fo:table 
                            table-layout="fixed"
                            width="100%"
                            height="{$usablePageHeight}{$unit}">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-body>
                                <fo:table-row height="{$usablePageHeight}{$unit}">
                                    <fo:table-cell 
                                        column-number="1" 
                                        display-align="center">
                                        <fo:block>
                                            <xsl:copy-of select="$contents"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>        
                    </fo:block-container>                
                </fo:block-container>
            </fo:flow>
        </xsl:element>
    </xsl:template>

    <!-- ***************************************************************************************************************
    *
    *
    *
    **************************************************************************************************************** -->
    <xsl:template name="page-template-photo">
        <xsl:param name="contents"/>
        <xsl:param name="photoId"/>
        <xsl:param name="bottomCaption"/>
        <xsl:param name="topCaption"/>
        <xsl:param name="masterPage"/>
        
        <xsl:element name="page-sequence" namespace="http://www.w3.org/1999/XSL/Format">
            <xsl:attribute name="master-reference">
                <xsl:value-of select="$masterPage"/>
            </xsl:attribute>
            <fo:flow flow-name="xsl-region-body"> 
                <fo:block-container 
                    position="absolute" 
                    top="{$topMargin}{$unit}"
                    right="{$externalMargin}{$unit}"
                    width="{$usablePageWidth}{$unit}"
                    height="{$usablePageHeight}{$unit}">
                        
                    <fo:block-container 
                        position="absolute" 
                        left="0pt" 
                        top="0pt"
                        width="100%" 
                        height="100%">
                        <fo:table 
                            table-layout="fixed" 
                            width="100%"
                            height="{$usablePageHeight}{$unit}">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-column column-width="{$usablePageWidth}{$unit}"/>
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-body>
                                <fo:table-row height="{$usablePageHeight}{$unit}">
                                    <fo:table-cell
                                        column-number="2" 
                                        display-align="center">
                                        <xsl:variable name="h" select="0.8 * $usablePageHeight" /> 
                                        <fo:block text-align="center">
                                            <fo:external-graphic
                                                width="100%" 
                                                height="{$h}{$unit}" 
                                                content-width="scale-to-fit"
                                                content-height="scale-to-fit" 
                                                src="{$photoPath}/{$photoId}.jpg"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block-container>   
                    
                    <fo:block-container 
                        position="absolute" 
                        left="0pt" 
                        top="0pt"
                        width="100%" 
                        height="100%">
                        <fo:table 
                            table-layout="fixed" 
                            width="100%">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-column column-width="{$usablePageWidth}{$unit}"/>
                            <fo:table-column column-width="proportional-column-width(1)"/>
                            <fo:table-body>
                                <fo:table-row height="{$usablePageHeight}{$unit}">
                                    <fo:table-cell 
                                        column-number="2" 
                                        display-align="after">
                                        <xsl:copy-of select="$bottomCaption"/>
                                        <fo:block space-before="0cm"/>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block-container>  
                    
                    <xsl:if test="$topCaption">
                        <fo:block-container 
                            position="absolute" 
                            left="0pt" 
                            top="0pt"
                            width="100%" 
                            height="100%">
                            <fo:table 
                                table-layout="fixed" 
                                width="100%">
                                <fo:table-column column-width="proportional-column-width(1)"/>
                                <fo:table-column column-width="{$usablePageWidth}{$unit}"/>
                                <fo:table-column column-width="proportional-column-width(1)"/>
                                <fo:table-body>
                                    <fo:table-row height="{$usablePageHeight}{$unit}">
                                        <fo:table-cell 
                                            column-number="2" 
                                            display-align="before">
                                            <fo:block space-after="0cm"/>
                                            <xsl:copy-of select="$topCaption"/>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block-container>                
                    </xsl:if>

                    <fo:block>
                        <xsl:copy-of select="$contents"/>
                    </fo:block>
                </fo:block-container>
            </fo:flow>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
