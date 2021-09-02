<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- 
  Mainly transforms the anonymousArrayElements into concrete elements.
  -->
  
<xsl:template match="questions/anonymousArrayElement">
  <question>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </question>
</xsl:template>

<xsl:template match="options/anonymousArrayElement">
  <option>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </option>
</xsl:template>

<xsl:template match="products/anonymousArrayElement">
  <product>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </product>
</xsl:template>

<xsl:template match="covers/anonymousArrayElement">
  <cover>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </cover>
</xsl:template>

<xsl:template match="results/anonymousArrayElement">
  <result>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </result>
</xsl:template>

<xsl:template match="assessmentFactors/anonymousArrayElement">
  <assessmentFactor>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </assessmentFactor>
</xsl:template>

<xsl:template match="reason/assessmentFactors/anonymousArrayElement">
  <assessmentFactor>
    <xsl:value-of select="./id/text()"/>
  </assessmentFactor>
</xsl:template>

<xsl:template match="declarativeStatements/anonymousArrayElement">
  <declarativeStatement>
    <xsl:value-of select="./text()"/>
  </declarativeStatement>
</xsl:template>

<xsl:template match="SourceAssessmentVariableType/anonymousArrayElement">
  <SourceAssessmentVariableType>
    <xsl:value-of select="./text()"/>
  </SourceAssessmentVariableType>
</xsl:template>

<xsl:template match="flexRules/anonymousArrayElement">
  <flexRule>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </flexRule>
</xsl:template>

<xsl:template match="ratings/*/ratings/anonymousArrayElement | ratingsBefore/*/ratings/anonymousArrayElement | ratingsAfter/*/ratings/anonymousArrayElement | ratingsRemoved/*/ratings/anonymousArrayElement | ratingsAdded/*/ratings/anonymousArrayElement">
  <rating>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </rating>
</xsl:template>

<xsl:template match="answer/anonymousArrayElement[../../type='multiselection']">
  <option>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </option>
</xsl:template>

<xsl:template match="answer/anonymousArrayElement[../../type='list']">
  <entry>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </entry>
</xsl:template>

<xsl:template match="answer/anonymousArrayElement[../../type='assessment-factor-search']">
  <assessmentFactor>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </assessmentFactor>
</xsl:template>

<xsl:template match="riders/anonymousArrayElement">
  <rider>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </rider>
</xsl:template>

<xsl:template match="elements/anonymousArrayElement">
  <element>
    <xsl:copy-of select="@*" />
    <xsl:apply-templates select="*|@*" />
  </element>
</xsl:template>

<xsl:template match="@*|node()" priority="-1">
  <xsl:copy>
    <xsl:apply-templates />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
