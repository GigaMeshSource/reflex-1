<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:java="http://xml.apache.org/xslt/java"
                version="1.0" exclude-result-prefixes="java">

    <xsl:param name="titleFontSize" select="'32'"/>
    <xsl:param name="headerBlockFontSize" select="'18'"/>
    <xsl:param name="hintFontSize" select="'10'"/>
    <xsl:param name="subTextFontSize" select="'10'"/>
    <xsl:param name="footerFontSize" select="'10'"/>
    <xsl:param name="groupFontSize" select="'14'"/>
    <xsl:param name="logoUrl">
        url('logo.svg')
    </xsl:param>
    <xsl:param name="questionCaptionWidth" select="'100mm'"/>
    <xsl:param name="resultCaptionWidth" select="'50mm'"/>
    <xsl:param name="resultContentWidth" select="'100mm'"/>
    <xsl:param name="resultDefaultMargin" select="'5mm'"/>
    <xsl:param name="questionAnswerDefaultMarginAndPadding"
               select="'5mm'"/>
    <xsl:param name="hreBlue" select="'#005192'"/>
    <xsl:param name="hreBlueBg" select="'#c0eaf6'"/>


    <xsl:template match="/">
        <fo:root>
            <xsl:attribute name="font-family">
                <xsl:call-template
                        name="i18n">
                    <xsl:with-param name="key" select="'fo.font-family'"/>
                </xsl:call-template>
            </xsl:attribute>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="default"
                                       page-width="210mm" page-height="297mm" margin-top="1cm"
                                       margin-bottom="1cm" margin-left="0cm" margin-right="0cm">
                    <xsl:attribute name="writing-mode">
                        <xsl:call-template
                                name="i18n">
                            <xsl:with-param name="key" select="'fo.writing-mode'"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <fo:region-body margin="3cm"/>
                    <fo:region-before extent="2cm"/>
                    <fo:region-after extent="2cm"/>
                    <fo:region-start extent="2cm"/>
                    <fo:region-end extent="2cm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="first"
                                       page-width="210mm" page-height="297mm" margin-top="1cm"
                                       margin-bottom="1cm" margin-left="0cm" margin-right="0cm">
                    <xsl:attribute name="writing-mode">
                        <xsl:call-template
                                name="i18n">
                            <xsl:with-param name="key" select="'fo.writing-mode'"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <fo:region-body margin="3cm"/>
                    <fo:region-before extent="2cm" region-name="xsl-region-before-first"/>
                    <fo:region-after extent="2cm"/>
                    <fo:region-start extent="2cm"/>
                    <fo:region-end extent="2cm"/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="main">
                    <xsl:attribute name="writing-mode">
                        <xsl:call-template
                                name="i18n">
                            <xsl:with-param name="key" select="'fo.writing-mode'"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference
                                master-reference="first" page-position="first"/>
                        <fo:conditional-page-master-reference
                                master-reference="default" page-position="rest"/>
                        <fo:conditional-page-master-reference
                                master-reference="default"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="main">
                <xsl:attribute name="writing-mode">
                    <xsl:call-template
                            name="i18n">
                        <xsl:with-param name="key" select="'fo.writing-mode'"/>
                    </xsl:call-template>
                </xsl:attribute>
                <fo:static-content flow-name="xsl-region-before-first">
                    <fo:block-container position="absolute"
                                        margin-left="1cm">
                        <fo:block>
                            <fo:external-graphic src="{$logoUrl}" width="150px"
                                                 content-width="scale-to-fit" content-height="scale-to-fit"/>
                        </fo:block>
                    </fo:block-container>
                    <fo:block-container position="absolute" top="4mm"
                                        left="100mm">
                        <fo:block font-size="{$titleFontSize}" color="{$hreBlue}">
                            <xsl:call-template name="i18n">
                                <xsl:with-param name="key" select="'title'"/>
                            </xsl:call-template>
                        </fo:block>
                    </fo:block-container>
                </fo:static-content>

                <fo:static-content flow-name="xsl-region-after">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>

                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block text-align="left" font-style="italic"
                                              font-size="{$footerFontSize}">
                                        <xsl:choose>
                                            <xsl:when
                                                    test="/*/*/questionnaire//question[id='InsuredPerson.LastName']/answer!=''">
                                                <xsl:value-of
                                                        select="/*/*/questionnaire//question[id='InsuredPerson.LastName']/answer"/>
                                                ,
                                            </xsl:when>
                                            <xsl:when
                                                    test="/*/*/provided//questionnaire/InsuredPerson.LastName/answer!=''">
                                                <xsl:value-of
                                                        select="/*/*/provided//questionnaire/InsuredPerson.LastName/answer"/>
                                                ,
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when
                                                    test="/*/*/questionnaire//question[id='InsuredPerson.FirstName']/answer!=''">
                                                <xsl:value-of
                                                        select="/*/*/questionnaire//question[id='InsuredPerson.FirstName']/answer"/>
                                            </xsl:when>
                                            <xsl:when
                                                    test="/*/*/provided//questionnaire/InsuredPerson.FirstName/answer!=''">
                                                <xsl:value-of
                                                        select="/*/*/provided//questionnaire/InsuredPerson.FirstName/answer"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="center" font-style="italic"
                                              font-size="{$footerFontSize}">
                                        <xsl:value-of
                                                select="java:format(java:java.text.SimpleDateFormat.new('yyyy-MM-dd HH:mm:ss'), java:java.util.Date.new())"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block text-align="right" font-style="italic"
                                              font-size="{$footerFontSize}">
                                        <xsl:call-template name="i18n">
                                            <xsl:with-param name="key" select="'footer.pageNoPrefix'"/>
                                        </xsl:call-template>
                                        <fo:page-number/>
                                        <xsl:call-template name="i18n">
                                            <xsl:with-param name="key" select="'footer.pageNoInfix'"/>
                                        </xsl:call-template>
                                        <fo:page-number-citation ref-id="LastPageMarker"/>
                                        <xsl:call-template name="i18n">
                                            <xsl:with-param name="key" select="'footer.pageNoSuffix'"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block keep-together.within-page="5">
                        <xsl:call-template name="personalDetails"/>
                        <xsl:call-template name="productDetails"/>
                        <xsl:call-template name="questionnaireDetails"/>
                        <xsl:call-template name="assessmentResults"/>
                    </fo:block>
                    <fo:block id="LastPageMarker"></fo:block>
                </fo:flow>

            </fo:page-sequence>

        </fo:root>
    </xsl:template>

    <xsl:template name="personalDetails">
        <fo:block>
            <xsl:call-template name="headerBlockStyle"/>
            <fo:block>
                <xsl:call-template name="headerCaptionStyle"/>
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'address.title'"/>
                </xsl:call-template>
            </fo:block>

            <fo:block>
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="proportional-column-width(1)"/>
                    <fo:table-column column-width="proportional-column-width(1)"/>

                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="left">
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.FirstName/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.FirstName/answer"/>
                                    </xsl:if> &#160;
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.LastName/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.LastName/answer"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="left">
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._StreetName/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._StreetName/answer"/>
                                    </xsl:if> &#160;
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._HouseNumber/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._HouseNumber/answer"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block text-align="left">
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.PostalCode/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.PostalCode/answer"/>
                                    </xsl:if> &#160;
                                    <xsl:if test="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._City/answer">
                                        <xsl:value-of
                                                select="/*/*/provided//questionnaire/InsuredPerson.AddressDetails._City/answer"/>
                                    </xsl:if>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="productDetails">
        <fo:block>
            <xsl:call-template name="headerBlockStyle"/>
            <fo:block>
                <xsl:call-template name="headerCaptionStyle"/>
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'productDetails.title'"/>
                </xsl:call-template>
            </fo:block>
            <fo:block>
                <xsl:apply-templates select="/*/*/products/product"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="questionnaireDetails">
        <fo:block keep-together.within-page="5">
            <xsl:call-template name="headerBlockStyle"/>
            <fo:block>
                <xsl:call-template name="headerCaptionStyle"/>
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'questionnaire.title'"/>
                </xsl:call-template>
            </fo:block>
            <fo:block>
                <xsl:if test="count(/*/*/questionnaire/questions/question) &gt; 0">
                    <fo:table table-layout="fixed" width="100%">
                        <fo:table-column column-width="{$questionCaptionWidth}"/>
                        <fo:table-column column-width="proportional-column-width(1)"/>
                        <fo:table-body>
                            <xsl:apply-templates select="/*/*/questionnaire/questions"/>
                        </fo:table-body>
                    </fo:table>
                </xsl:if>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="assessmentResults">
        <fo:block keep-together.within-page="5">
            <xsl:call-template name="headerBlockStyle"/>
            <fo:block>
                <xsl:call-template name="headerCaptionStyle"/>
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'assessment.result.title'"/>
                </xsl:call-template>
            </fo:block>
            <xsl:apply-templates select="/*/*/results/products/product"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="questions">
        <xsl:for-each select="question">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
            match="question[type != 'group' and not(answer/entry/type = 'struct') and declarativeStatements/*]">
        <fo:table-row keep-together.within-page="5">
            <fo:table-cell number-columns-spanned="2">
                <fo:block linefeed-treatment="preserve" padding-bottom="{$questionAnswerDefaultMarginAndPadding}">
                    <xsl:apply-templates select="declarativeStatements"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:apply-templates select="questions/question"/>
    </xsl:template>

    <xsl:template match="declarativeStatements">
        <xsl:for-each select="declarativeStatement">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
            match="question[type != 'group' and not(answer/entry/type = 'struct') and not(declarativeStatements/*)]">
        <fo:table-row keep-together.within-page="5">
            <fo:table-cell>
                <fo:block linefeed-treatment="preserve" padding-bottom="{$questionAnswerDefaultMarginAndPadding}">
                    <xsl:value-of select="index"/>
                    &#160;
                    <xsl:apply-templates select="scope"/>
                    <xsl:value-of select="caption"/>
                    <xsl:if test="hint">
                        <fo:block font-style="italic" font-size="{$hintFontSize}">
                            (
                            <xsl:value-of select="hint"/>
                            )
                        </fo:block>
                    </xsl:if>
                    <xsl:if test="subText">
                        <fo:block font-style="italic" font-size="{$subTextFontSize}">
                            -
                            <xsl:value-of select="subText"/> -
                        </fo:block>
                    </xsl:if>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <!-- Why does padding-left has no effect here? Thats why margin-left 
                    is used. -->
                <fo:block linefeed-treatment="preserve" padding-bottom="{$questionAnswerDefaultMarginAndPadding}"
                          margin-left="{$questionAnswerDefaultMarginAndPadding}">
                    <xsl:call-template name="renderAnswer">
                        <xsl:with-param name="answer" select="answer"/>
                    </xsl:call-template>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>

        <xsl:apply-templates select="questions/question"/>
    </xsl:template>


    <xsl:template
            match="question[type != 'group' and answer/entry/type = 'struct']">
        <fo:table-row page-break-inside="avoid">
            <fo:table-cell number-columns-spanned="2">
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="proportional-column-width(1)"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block linefeed-treatment="preserve"
                                          padding-bottom="{$questionAnswerDefaultMarginAndPadding}">
                                    <xsl:value-of select="index"/>
                                    &#160;
                                    <xsl:apply-templates select="scope"/>
                                    <xsl:value-of select="caption"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block linefeed-treatment="preserve"
                                          padding-bottom="{$questionAnswerDefaultMarginAndPadding}">
                                    <xsl:call-template name="renderDynamicTableAnswer">
                                        <xsl:with-param name="answer" select="answer"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:table-cell>
        </fo:table-row>

        <xsl:apply-templates select="questions/question"/>
    </xsl:template>


    <xsl:template match="question[type = 'group']">
        <xsl:param name="groupLevel"
                   select="count(ancestor-or-self::question[type='group'])"/>

        <fo:table-row>
            <fo:table-cell number-columns-spanned="2"
                           keep-together.within-page="5">
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="{$questionCaptionWidth}"/>
                    <fo:table-column column-width="proportional-column-width(1)"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell number-columns-spanned="2"
                                           keep-together.within-page="5">
                                <fo:block>
                                    <xsl:call-template name="questionGroupCaptionStyle">
                                        <xsl:with-param name="fontSize">
                                            <xsl:choose>
                                                <xsl:when test="$groupLevel = 1">
                                                    <xsl:value-of select="$groupFontSize"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    12
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:with-param>
                                    </xsl:call-template>

                                    <xsl:choose>
                                        <xsl:when test="$groupLevel = 1">
                                            <xsl:attribute name="font-weight">bold</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- Do render numbering for level 1 groups -->
                                            <xsl:value-of select="index"/>
                                            &#160;
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="caption"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <xsl:apply-templates select="questions/question"/>
                    </fo:table-body>
                </fo:table>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="scope">
        <xsl:if
                test="starts-with(., 'ASSESSMENTFACTOR:') and substring(., string-length('ASSESSMENTFACTOR:')+1) != 'InsuredPerson'">
            [
            <xsl:call-template name="assessmentFactorLabel">
                <xsl:with-param name="assessmentFactorId"
                                select="substring(., string-length('ASSESSMENTFACTOR:')+1)"/>
            </xsl:call-template>
            ]&#160;
        </xsl:if>
    </xsl:template>

    <xsl:template match="products/product">
        <fo:block keep-together.within-page="5">
            <fo:block margin-bottom="{$resultDefaultMargin}">
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key"
                                    select="'productDetails.product.title'"/>
                </xsl:call-template>
                &#160;
                <fo:inline font-weight="bold">
                    <xsl:call-template name="productLabel">
                        <xsl:with-param name="productId" select="id"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
            <fo:block>
                <xsl:apply-templates select="riders"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="results/products/product">
        <fo:block keep-together.within-page="5">
            <fo:block margin-bottom="{$resultDefaultMargin}">
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'result.product.title'"/>
                </xsl:call-template>
                &#160;
                <fo:inline font-weight="bold">
                    <xsl:call-template name="productLabel">
                        <xsl:with-param name="productId" select="id"/>
                    </xsl:call-template>
                </fo:inline>
            </fo:block>
            <fo:block margin-left="{$resultDefaultMargin}">
                <xsl:call-template name="result"/>
            </fo:block>
            <fo:block margin-left="{$resultDefaultMargin}">
                <xsl:apply-templates select="covers"/>
            </fo:block>
            <fo:block margin-left="{$resultDefaultMargin}">
                <xsl:apply-templates select="riders"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="result">
        <xsl:apply-templates select="ratings/*/ratings/rating"/>
    </xsl:template>

    <xsl:template match="rating">
        <xsl:param name="caption1"/>
        <xsl:param name="caption2"/>
        <fo:block>
            <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="{$resultCaptionWidth}"/>
                <fo:table-column column-width="proportional-column-width(1)"/>
                <fo:table-body>
                    <xsl:if test="$caption1">
                        <fo:table-row keep-together.within-page="5">
                            <fo:table-cell number-columns-spanned="2">
                                <fo:block color="{$hreBlue}" margin-top="{$resultDefaultMargin}">
                                    <xsl:value-of select="$caption1"/>
                                    &#160;
                                    <fo:inline font-weight="bold">
                                        <xsl:value-of select="$caption2"/>
                                    </fo:inline>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>

                    <xsl:if test="count(id) &gt; 0">
                        <fo:table-row keep-together.within-page="5">
                            <fo:table-cell>
                                <fo:block font-style="italic">
                                    <xsl:call-template name="i18n">
                                        <xsl:with-param name="key" select="'result.decision.title'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block font-weight="bold">
                                    <xsl:attribute name="background-color">
                                        <xsl:choose>
                                            <xsl:when test="id = 'Accept'">LightGreen</xsl:when>
                                            <xsl:when test="id = 'Decline'">Red</xsl:when>
                                            <xsl:otherwise>Yellow</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="caption"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>

                    <xsl:if test="count(attributes/*) &gt; 0">
                        <fo:table-row keep-together.within-page="5">
                            <fo:table-cell>
                                <fo:block font-style="italic">
                                    <xsl:call-template name="i18n">
                                        <xsl:with-param name="key"
                                                        select="'result.decision.details.title'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <xsl:for-each select="attributes/*">
                                    <fo:block>
                                        <xsl:value-of select="caption"/>
                                        :&#160;
                                        <xsl:value-of select="value"/>
                                    </fo:block>
                                </xsl:for-each>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>

                    <xsl:if test="count(reason/assessmentFactors/*) &gt; 0">
                        <fo:table-row keep-together.within-page="5">
                            <fo:table-cell>
                                <fo:block font-style="italic">
                                    <xsl:call-template name="i18n">
                                        <xsl:with-param name="key"
                                                        select="'result.decision.reasons.title'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block>
                                    <xsl:for-each select="reason/assessmentFactors/*">
                                        <xsl:call-template name="assessmentFactorLabel">
                                            <xsl:with-param name="assessmentFactorId"
                                                            select="."></xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:if test="position() &lt; count(../*)">
                                            ,
                                        </xsl:if>
                                    </xsl:for-each>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template match="riders">
        <xsl:choose>
            <xsl:when test="rider/ratings/*/ratings/rating">
                <xsl:apply-templates select="rider"/>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:call-template name="i18n">
                        <xsl:with-param name="key"
                                        select="'productDetails.riders.title'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="rider"/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="rider">
        <xsl:choose>
            <xsl:when test="ratings/*/ratings/rating">
                <xsl:apply-templates select="ratings/*/ratings/rating">
                    <xsl:with-param name="caption1">
                        <xsl:call-template name="i18n">
                            <xsl:with-param name="key" select="'result.rider.title'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="caption2">
                        <xsl:call-template name="riderLabel">
                            <xsl:with-param name="riderId" select="id"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <fo:block margin-left="{$resultDefaultMargin}">
                    <fo:inline font-weight="bold">
                        <xsl:call-template name="riderLabel">
                            <xsl:with-param name="riderId" select="id"/>
                        </xsl:call-template>
                    </fo:inline>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="covers">
        <xsl:apply-templates select="cover"/>
    </xsl:template>

    <xsl:template match="cover">
        <xsl:apply-templates select="ratings/*/ratings/rating">
            <xsl:with-param name="caption1">
                <xsl:call-template name="i18n">
                    <xsl:with-param name="key" select="'result.cover.title'"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="caption2">
                <xsl:value-of select="id"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="assessmentFactorLabel">
        <xsl:param name="assessmentFactorId"/>
        <xsl:value-of
                select="/*/*/assessmentFactors/assessmentFactor[id=$assessmentFactorId]/label"></xsl:value-of>
    </xsl:template>

    <xsl:template name="productLabel">
        <xsl:param name="productId"/>
        <xsl:value-of select="/*/*/products/product[id=$productId]/caption"></xsl:value-of>
    </xsl:template>

    <xsl:template name="riderLabel">
        <xsl:param name="riderId"/>
        <xsl:value-of
                select="/*/*/products/product/riders/rider[id=$riderId]/caption"></xsl:value-of>
    </xsl:template>

    <xsl:template name="renderAnswer">
        <xsl:param name="answer"/>
        <xsl:param name="type" select="$answer/../type"/>
        <xsl:param name="selectionOptions" select="$answer/../options"/>

        <xsl:choose>
            <xsl:when test="$type = 'singleselection'">
                <xsl:call-template name="renderSingleSelectionAnswer">
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type = 'multiselection'">
                <xsl:call-template name="renderMultiSelectionAnswer">
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type = 'assessment-factor-search'">
                <xsl:for-each select="$answer/assessmentFactor">
                    <fo:block>
                        <xsl:value-of select="./label"/>
                    </fo:block>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$type = 'date'">
                <fo:block>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="date" select="$answer"/>
                    </xsl:call-template>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$answer"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="formatDate">
        <xsl:param name="date"/>
        <xsl:param name="year" select="substring($date, 1, 4)"/>
        <xsl:param name="month" select="substring($date, 6, 2)"/>
        <xsl:param name="day" select="substring($date, 9, 2)"/>

        <xsl:value-of select="concat($day, '/', $month, '/', $year)"/>
    </xsl:template>

    <xsl:template name="renderSingleSelectionAnswer">
        <xsl:param name="answer"/>
        <xsl:param name="selectionOptions" select="$answer/../options/option"/>

        <xsl:if test="count($selectionOptions) &gt; 10">
            <xsl:value-of select="$answer/label"/>
        </xsl:if>
        <xsl:if test="not(count($selectionOptions) &gt; 10)">
            <xsl:for-each select="$selectionOptions">
                <fo:block>
                    <xsl:if test="./id = $answer/id">
                        <xsl:attribute name="background-color">
                            <xsl:value-of
                                    select="$hreBlueBg"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="./label"/>
                </fo:block>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>

    <xsl:template name="renderMultiSelectionAnswer">
        <xsl:param name="answer"/>
        <xsl:param name="selectionOptions" select="$answer/../options/option"/>

        <xsl:for-each select="$selectionOptions">
            <fo:block>
                <xsl:if test="$answer/option/id = ./id">
                    <xsl:if test="not(count($selectionOptions) &gt; 10)">
                        <xsl:attribute name="background-color">
                            <xsl:value-of
                                    select="$hreBlueBg"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="./label"/>
                </xsl:if>
                <xsl:if
                        test="$answer/option/id != ./id and not(count($selectionOptions) &gt; 10)">
                    <xsl:value-of select="./label"/>
                </xsl:if>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="renderDynamicTableAnswer">
        <xsl:param name="answer"/>

        <xsl:if test="$answer/entry[1]">
            <fo:table table-layout="fixed" width="100%" margin-left="{$questionAnswerDefaultMarginAndPadding}">
                <xsl:for-each select="$answer/entry[1]/elements/element">
                    <fo:table-column column-width="proportional-column-width(1)"/>
                </xsl:for-each>

                <fo:table-header>
                    <fo:table-row>
                        <xsl:for-each select="$answer/entry[1]/elements/element">
                            <fo:table-cell>
                                <fo:block font-weight="bold">
                                    <xsl:value-of select="caption"/>
                                </fo:block>
                            </fo:table-cell>
                        </xsl:for-each>
                    </fo:table-row>
                </fo:table-header>

                <fo:table-body>
                    <xsl:for-each select="$answer/entry">
                        <fo:table-row>
                            <xsl:for-each select="elements/element">
                                <fo:table-cell>
                                    <fo:block linefeed-treatment="preserve">
                                        <xsl:call-template name="renderAnswer">
                                            <xsl:with-param name="answer" select="answer"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:for-each>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </xsl:if>
    </xsl:template>

    <!-- STYLE TEMPLATES -->

    <xsl:template name="i18n">
        <xsl:param name="key"/>
        <xsl:value-of select="/*/i18n/text[@id=$key]"/>
    </xsl:template>

    <xsl:template name="headerBlockStyle">
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
    </xsl:template>

    <xsl:template name="headerCaptionStyle">
        <xsl:attribute name="color">
            <xsl:value-of select="$hreBlue"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.5mm</xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$hreBlue"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$headerBlockFontSize"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="questionGroupCaptionStyle">
        <xsl:param name="fontSize" select="$headerBlockFontSize"/>
        <xsl:attribute name="padding-bottom">5mm</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$hreBlue"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$fontSize"/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
