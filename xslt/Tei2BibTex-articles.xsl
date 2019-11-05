<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output encoding="UTF-8" indent="yes" method="text" name="text" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- this stylesheet generates a Bibtex file with bibliographic metadata for each <div> in the body of the TEI source file. File names are based on the source's @xml:id and the @xml:id of the <div>. -->
    <!-- to do:
        + add information on edition: i.e. TEI edition
        + add information on collaborators on the digital edition
        comment: this information cannot be added to BibTeX for articles appart from the generic "annote" tag -->
    <xsl:include href="Tei2BibTex-functions.xsl"/>
    <!-- all parameters and variables are set in Tei2BibTex-functions.xsl -->
    <xsl:template match="/">
        <xsl:apply-templates select="descendant::tei:text/tei:body/descendant::tei:div"/>
    </xsl:template>
    <xsl:template
        match="tei:div">
        <!-- tei:div[@type = 'section'][not(ancestor::tei:div[@type = ('article', 'bill', 'item')])] | tei:div[@type = ('article', 'item')][not(ancestor::tei:div[@type = 'bill'])] | tei:div[@type = ('article', 'item')][not(ancestor::tei:div[@type = 'item'][@subtype = 'bill'])] | tei:div[@type = 'bill'] | tei:div[@type = 'item'][@subtype = 'bill'] -->
        <xsl:choose>
            <!-- prevent output for sections of legal texts -->
            <xsl:when
                test="ancestor::tei:div[@type = 'bill'] or ancestor::tei:div[@subtype = 'bill']"/>
            <!-- prevent output for mastheads -->
            <xsl:when test="@type='masthead' or @subtype='masthead'"/>
            <!-- prevent output for sections of articles -->
            <xsl:when test="ancestor::tei:div[@type='item']"/>
            <xsl:when test="@type = ('section', 'item')">
                <xsl:result-document href="../metadata/{concat($vFileId,'-',@xml:id)}.bib"
                    method="text">
                    <xsl:call-template name="tBibHead"/>
                    <xsl:call-template name="tDiv2Bib">
                        <xsl:with-param name="pInput" select="."/>
                    </xsl:call-template>
                </xsl:result-document>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
