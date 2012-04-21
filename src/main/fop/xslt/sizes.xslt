<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xhtml="http://www.w3.org/1999/xhtml">

    <xsl:variable name="unit">pt</xsl:variable>
    
    <xsl:variable name="sizes" select="document('formats.xml')/formats/format[@id=$format]"/>
    
    <xsl:variable name="coverWidth" select="$sizes/coverWidth"/>
    <xsl:variable name="coverHeight" select="$sizes/coverHeight"/>
    <xsl:variable name="bleed" select="$sizes/bleed"/>
    <xsl:variable name="gutterWidth" select="$sizes/gutterWidth"/>
    <xsl:variable name="insideFlapWidth" select="$sizes/insideFlapWidth"/>
    <xsl:variable name="pageWidth" select="$sizes/pageWidth"/>
    <xsl:variable name="pageHeight" select="$sizes/pageHeight"/>
    <xsl:variable name="safeBoundaryMargin" select="$sizes/safeBoundaryMargin"/>
    <xsl:variable name="safeBoundaryBindingMargin" select="$sizes/safeBoundaryBindingMargin"/>
    <xsl:variable name="safeCoverMargin" select="$sizes/safeCoverMargin"/>
        
    <!-- derived sizes -->
    <xsl:variable name="flapWidth"            select="($coverWidth - $gutterWidth) div 2"/> 
    <xsl:variable name="semiCoverWidth"       select="$flapWidth - $insideFlapWidth - $bleed"/> 
    <xsl:variable name="usablePageWidth"      select="$pageWidth - $bleed * 2 - $safeBoundaryMargin - $safeBoundaryBindingMargin - $horizontalMargin * 2"/> 
    <xsl:variable name="usablePageHeight"     select="$pageHeight - $bleed * 2 - $safeBoundaryMargin * 2 - $verticalMargin * 2"/> 
    
    <xsl:variable name="topMargin"            select="$bleed + $safeBoundaryMargin + $verticalMargin"/>
    <xsl:variable name="bottomMargin"         select="$bleed + $safeBoundaryMargin + $verticalMargin"/>
    <xsl:variable name="internalMargin"       select="$safeBoundaryBindingMargin + $horizontalMargin"/>
    <xsl:variable name="externalMargin"       select="$bleed + $safeBoundaryMargin + $horizontalMargin"/>

    <xsl:variable name="usableCoverWidth"     select="$coverWidth - $bleed * 2 - $safeCoverMargin * 2"/> 
    <xsl:variable name="usableCoverHeight"    select="$coverHeight - $bleed * 2 - $safeCoverMargin * 2"/> 
    
    <xsl:variable name="topCoverMargin"       select="$bleed + $safeCoverMargin"/>
    <xsl:variable name="externalCoverMargin"  select="$bleed + $safeCoverMargin"/>
    <xsl:variable name="usableSemiCoverWidth" select="$flapWidth - $insideFlapWidth - $bleed - $safeCoverMargin"/> 
    
</xsl:stylesheet>
