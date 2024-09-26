<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.hannover-re.com/lh/pos/application/v2.2"
                xmlns:ns2="http://ns.hr-xml.org/2007-04-15">

  <!--
  ====================================================================
  ============ Configuration for questions to be excluded ============
  ====================================================================
   -->

  <xsl:variable name="questionsToExclude" select="'
    LastName
    FirstName
    Title
    Salutation
    Gender
    DateOfBirth
    LanguagesSpoken
    Role
    _CountryCode
    PostalCode
    _City
    _StreetName
    _HouseNumber
    InceptionDate
    InsuranceSum
    PolicyDuration
    InsuranceMotive
    ApplicationDate
    SignatureDate
  '" />

  <xsl:variable name="questionTypesToExclude" select="'
    virtual
    group
    assessment-factor-group
  '" />

  <!--
  ====================================================================
  ============ Begin Template ========================================
  ====================================================================
   -->

  <xsl:param name="language" select="/*/language" />

  <xsl:template match="/*">
    <Application schemaVersion="2.2.0">
      <xsl:call-template name="applicationData" />
      <xsl:call-template name="assessmentData" />
      <xsl:call-template name="decisionData" />
    </Application>
  </xsl:template>

  <xsl:template name="applicationData">
    <ApplicationData>
      <CedentId><xsl:value-of select="./meta/ras/cedent/id"/></CedentId>
      <CedentApplicationId>Undefined</CedentApplicationId>
      <!-- TODO: default value -->
      <CreationDate>1970-01-01T00:00:00</CreationDate>
      <ApplicationDate><xsl:value-of select="./questionnaire/questions/question[id='ApplicationDate']/answer"/></ApplicationDate>
      <xsl:if test="./questionnaire/questions/question[id='SignatureDate']/answer">
        <SignatureDate><xsl:value-of select="./questionnaire/questions/question[id='SignatureDate']/answer"/></SignatureDate>
      </xsl:if>
      <!-- TODO: default value -->
      <LastChangeDate>1970-01-01T00:00:00</LastChangeDate>
      <ApplicationLanguage><xsl:value-of select="$language"/></ApplicationLanguage>
      <xsl:call-template name="persons"/>
      <xsl:call-template name="insuranceCovers"/>
    </ApplicationData>
  </xsl:template>

  <xsl:template name="persons">
    <xsl:if test="/*/assessmentFactors/assessmentFactor[id='InsuredPerson']">
      <Persons>
        <xsl:for-each select="/*/assessmentFactors/assessmentFactor[id='InsuredPerson']">
          <xsl:variable name="personId" select="id" />
          <Person>
            <xsl:attribute name="id">
              <xsl:call-template name="getPersonReference" >
                <xsl:with-param name="id" select="$personId"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="mapSimplePersonTextData">
              <xsl:with-param name="person" select="$personId"/>
              <xsl:with-param name="attribute">LastName</xsl:with-param>
              <xsl:with-param name="outputElement">LastName</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="mapSimplePersonTextData">
              <xsl:with-param name="person" select="$personId"/>
              <xsl:with-param name="attribute">FirstName</xsl:with-param>
              <xsl:with-param name="outputElement">FirstName</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="mapSimplePersonTextData">
              <xsl:with-param name="person" select="$personId"/>
              <xsl:with-param name="attribute">Title</xsl:with-param>
              <xsl:with-param name="outputElement">Title</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="mapSimplePersonTextData">
              <xsl:with-param name="person" select="$personId"/>
              <xsl:with-param name="attribute">Salutation</xsl:with-param>
              <xsl:with-param name="outputElement">Salutation</xsl:with-param>
            </xsl:call-template>
            <GenderCode>
              <xsl:variable name="selectedGender">
                <xsl:call-template name="getQuestionAnswerId" >
                  <xsl:with-param name="scope" select="$personId"/>
                  <xsl:with-param name="question">Gender</xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              <xsl:call-template name="mapGenderCode">
                <xsl:with-param name="gender" select="$selectedGender"/>
              </xsl:call-template>
            </GenderCode>
            <DateOfBirth>
              <xsl:call-template name="getQuestionDataSimple">
                <xsl:with-param name="scope" select="$personId"/>
                <xsl:with-param name="question">DateOfBirth</xsl:with-param>
              </xsl:call-template>
            </DateOfBirth>
            <Roles>
              <xsl:choose>
                <xsl:when test="/*/questionnaire/questions/question[id=concat($personId, '.', 'Role')]/answer/option">
                  <xsl:for-each select="/*/questionnaire/questions/question[id=concat($personId, '.', 'Role')]/answer/option">
                    <xsl:choose>
                      <!-- ends-with(id, 'Role') -->
                      <xsl:when test="substring(id, (string-length(id) - string-length('Role')) + 1) = 'Role'">
                        <Role><xsl:value-of select="substring-before(id, 'Role')"/></Role>
                      </xsl:when>
                      <xsl:otherwise>
                        <Role><xsl:value-of select="id"/></Role>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!-- default role -->
                  <Role>InsuredPerson</Role>
                </xsl:otherwise>
              </xsl:choose>
            </Roles>
            <LanguagesSpoken>
              <xsl:choose>
                <xsl:when test="/*/questionnaire/questions/question[id = 'InsuredPerson.LanguagesSpoken']/answer/entry/elements/element/answer">
                  <xsl:for-each select="/*/questionnaire/questions/question[id = 'InsuredPerson.LanguagesSpoken']/answer/entry/elements/element/answer">
                    <LanguageSpoken><xsl:value-of select="."/></LanguageSpoken>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!-- use default language since the field is mandatory -->
                  <LanguageSpoken><xsl:value-of select="$language"/></LanguageSpoken>
                </xsl:otherwise>
              </xsl:choose>
            </LanguagesSpoken>
            <AddressDetails>
              <ns2:CountryCode><!-- FIXME: missing mandatory AddressDetails._CountryCode
              <xsl:call-template name="getQuestionDataSimple">
                <xsl:with-param name="scope" select="$personId"/>
                <xsl:with-param name="question">AddressDetails._CountryCode</xsl:with-param>
              </xsl:call-template>
             -->DE</ns2:CountryCode>
              <ns2:PostalCode>
                <xsl:call-template name="getQuestionDataSimple">
                  <xsl:with-param name="scope" select="$personId"/>
                  <!-- FIXME: should be rather InsuredPerson.AddressDetails._PostalCode than InsuredPerson.PostalCode -->
                  <xsl:with-param name="question">PostalCode</xsl:with-param>
                </xsl:call-template>
              </ns2:PostalCode>
              <!-- <ns2:Region/> -->
              <ns2:Municipality>
                <xsl:call-template name="getQuestionDataSimple">
                  <xsl:with-param name="scope" select="$personId"/>
                  <xsl:with-param name="question">AddressDetails._City</xsl:with-param>
                </xsl:call-template>
              </ns2:Municipality>
              <ns2:DeliveryAddress>
                <!--  <ns2:AddressLine/> -->
                <ns2:StreetName>
                  <xsl:call-template name="getQuestionDataSimple">
                    <xsl:with-param name="scope" select="$personId"/>
                    <xsl:with-param name="question">AddressDetails._StreetName</xsl:with-param>
                  </xsl:call-template>
                </ns2:StreetName>
                <ns2:BuildingNumber>
                  <xsl:call-template name="getQuestionDataSimple">
                    <xsl:with-param name="scope" select="$personId"/>
                    <xsl:with-param name="question">AddressDetails._HouseNumber</xsl:with-param>
                  </xsl:call-template>
                </ns2:BuildingNumber>
                <!-- <ns2:Unit/> -->
                <!-- <ns2:PostOfficeBox/> -->
              </ns2:DeliveryAddress>
            </AddressDetails>
            <!-- <CommunicationDetails /> -->
            <xsl:call-template name="preExistingInsurances"/>
          </Person>
        </xsl:for-each>
      </Persons>
    </xsl:if>
  </xsl:template>

  <xsl:template name="preExistingInsurances">
    <xsl:if test="//question[id = 'PreExistingApplicationsOrInsurances']">
      <PreExistingInsurances>
        <xsl:for-each select="//question[id = 'PreExistingApplicationsOrInsurances']/answer/entry">
          <PreExistingInsurance>
            <Company>
              <Text>
                <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                <xsl:value-of select="elements/element[id = 'NameOfCompany']/answer"/>
              </Text>
            </Company>
            <SumInsured>
              <Value><xsl:value-of select="elements/element[id = 'InsuranceAmount']/answer"/></Value>
              <!-- FIXME: currency of insured sum is not defined for pre existing insurances (optional) -->
              <!-- <Currency>EUR</Currency>  -->
            </SumInsured>
            <!-- default: not declined -->
            <Declined>false</Declined>
          </PreExistingInsurance>
        </xsl:for-each>
      </PreExistingInsurances>
    </xsl:if>
  </xsl:template>

  <!-- TODO: finish cover mapping -->
  <xsl:template name="insuranceCovers">
    <xsl:if test="/*/results/products/product/covers/cover">
      <InsuranceCovers>
        <!-- TODO: where are the covers that belong to the product? -->
        <xsl:for-each select="/*/products/product">
          <xsl:variable name="coverId" select="id" />
          <InsuranceCover>
          <!-- <xsl:attribute name="entityId">LifeCover</xsl:attribute> -->
          <xsl:attribute name="id"><xsl:value-of select="$coverId"/></xsl:attribute>
            <xsl:variable name="inceptionDate">
              <xsl:call-template name="getQuestionDataSimple">
                <xsl:with-param name="scope" select="$coverId"/>
                <xsl:with-param name="question">InceptionDate</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$inceptionDate != ''">
              <InceptionDate>
                <xsl:value-of select="$inceptionDate"/>
              </InceptionDate>
            </xsl:if>
            <xsl:variable name="insuranceSum">
              <xsl:call-template name="getQuestionDataSimple">
                <xsl:with-param name="scope" select="$coverId"/>
                <xsl:with-param name="question">InsuranceSum</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$insuranceSum != ''">
              <SumInsured>
                <Value>
                  <xsl:value-of select="$insuranceSum"/>
                </Value>
                <!-- FIXME: no insured sum present in json -->
                <Currency>EUR</Currency>
              </SumInsured>
            </xsl:if>
            <xsl:variable name="policyDuration">
              <xsl:call-template name="getQuestionDataSimple">
                <xsl:with-param name="scope" select="$coverId"/>
                <xsl:with-param name="question">PolicyDuration</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <PeriodOfCover>
              <Duration>
                <xsl:choose>
                  <xsl:when test="$policyDuration != ''">
                    <inMonths><xsl:value-of select="$policyDuration"/></inMonths>
                  </xsl:when>
                  <xsl:otherwise>
                    <inMonths>0</inMonths>
                  </xsl:otherwise>
                </xsl:choose>
              </Duration>
            </PeriodOfCover>
            <xsl:variable name="insuranceMotive">
              <xsl:call-template name="getQuestionAnswerId">
                <xsl:with-param name="scope" select="$coverId"/>
                <xsl:with-param name="question">InsuranceMotive</xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$insuranceMotive != ''">
              <Motive>
                  <xsl:value-of select="$insuranceMotive"/>
              </Motive>
            </xsl:if>
            <!-- FIXME: typeOfRiskCovered is not present in json -->
            <TypeOfRiskCovered>LifeTerm</TypeOfRiskCovered>
            <xsl:if test="caption">
              <Name>
                <Text>
                  <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                  <xsl:value-of select="caption"/>
                </Text>
              </Name>
            </xsl:if>
            <PersonReferences>
              <!-- FIXME: static since there is no person reference in json -->
              <PersonReference>#Person_InsuredPerson</PersonReference>
            </PersonReferences>
            <xsl:call-template name="riders"/>
          </InsuranceCover>
        </xsl:for-each>
      </InsuranceCovers>
    </xsl:if>
  </xsl:template>

  <xsl:template name="riders">
    <xsl:if test="/*/products/product/riders/rider">
      <Riders>
        <xsl:for-each select="/*/products/product/riders/rider">
          <Rider>
            <xsl:attribute name="id"><xsl:value-of select="concat(id, '_01')"/></xsl:attribute>
            <xsl:attribute name="entityId"><xsl:value-of select="id"/></xsl:attribute>
            <!-- FIXME: no Inception date present in json
              <InceptionDate/>
            -->
            <!-- FIXME: no insured sum present in json -->
            <SumInsured>
              <Value>100000.00</Value>
              <Currency>EUR</Currency>
            </SumInsured>
            <!-- FIXME: no duration present in json -->
            <PeriodOfCover>
              <Duration>
                <inMonths>60</inMonths>
              </Duration>
            </PeriodOfCover>
            <!-- FIXME: typeOfRiskCovered is not present in json -->
            <TypeOfRiskCovered>TPD own</TypeOfRiskCovered>
            <Name>
              <Text lang="en"><xsl:value-of select="caption"/></Text>
            </Name>
            <PersonReferences>
              <PersonReference>#Person_InsuredPerson</PersonReference>
            </PersonReferences>
          </Rider>
        </xsl:for-each>
      </Riders>
    </xsl:if>
  </xsl:template>

  <xsl:template name="assessmentData">
    <AssessmentData>
      <Data>
        <!-- FIXME map dynamically -->
        <xsl:variable name="personId">InsuredPerson</xsl:variable>
        <!-- TODO: default value -->
        <ValidFrom>1970-01-01T00:00:00</ValidFrom>
        <xsl:variable name="personReference">
          <xsl:call-template name="getPersonReference" >
            <xsl:with-param name="id" select="$personId"/>
          </xsl:call-template>
        </xsl:variable>
        <PersonReference><xsl:value-of select="concat('#', $personReference)"/></PersonReference>

        <xsl:call-template name="mapPersonWeight" >
          <xsl:with-param name="personId" select="$personId"/>
        </xsl:call-template>

        <xsl:call-template name="mapPersonHeight" >
          <xsl:with-param name="personId" select="$personId"/>
        </xsl:call-template>
        <xsl:if test="/*/assessmentFactors/assessmentFactor[category = 'Occupational']">
          <Occupations>
            <xsl:for-each select="/*/assessmentFactors/assessmentFactor[category = 'Occupational']">
              <Occupation>
                <Name>
                  <Text>
                    <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                    <xsl:value-of select="label"/>
                  </Text>
                </Name>
              </Occupation>
            </xsl:for-each>
          </Occupations>
        </xsl:if>
        <xsl:choose>
          <!-- question/Id ends with '.IsSmoker' -->
          <xsl:when test="/*/questionnaire//questions/question[substring(id, string-length(id) - 8) = '.IsSmoker']/answer[id = 'Yes']">
            <SmokerIndicator>true</SmokerIndicator>
          </xsl:when>
          <xsl:when test="/*/assessmentFactors/assessmentFactor[id = 'Smoker']">
            <SmokerIndicator>true</SmokerIndicator>
          </xsl:when>
          <xsl:when test="/*/assessmentFactors/assessmentFactor[id = 'Smoking']">
            <SmokerIndicator>true</SmokerIndicator>
          </xsl:when>
          <xsl:when test="/*/assessmentFactors/assessmentFactor[id = 'NicotineDependence']">
            <SmokerIndicator>true</SmokerIndicator>
          </xsl:when>
          <xsl:when test="/*/assessmentFactors/assessmentFactor[id = 'TobaccoUse']">
            <SmokerIndicator>true</SmokerIndicator>
          </xsl:when>
          <xsl:otherwise>
            <SmokerIndicator>false</SmokerIndicator>
          </xsl:otherwise>
        </xsl:choose>
        <!-- <AnnualIncome> -->
        <!-- <CaptureLanguage> -->
        <!-- flatten the tree structure of questions from source xml (to keep the questions in order a recursive approach would be needed instead) -->
        <Questions>
          <xsl:for-each select="/*/questionnaire/questions/question">
            <xsl:call-template name="question"/>
          </xsl:for-each>
          <!-- <xsl:apply-templates select="//questionnaire//questions" /> -->
        </Questions>
        <xsl:call-template name="assessmentFactors"/>
        <xsl:call-template name="assessmentResults"/>
      </Data>
    </AssessmentData>
  </xsl:template>

  <xsl:template name="question">
    <xsl:variable name="questionId" select="id" />
    <xsl:variable name="questionType" select="type" />

    <!-- Remove prefix of question scope to retrieve the pure question id -->
    <xsl:variable name="questionIdWithoutScope">
      <xsl:call-template name="GetLastSegment">
        <xsl:with-param name="value" select="$questionId" />
        <xsl:with-param name="separator" select="'.'" />
      </xsl:call-template>
    </xsl:variable>

    <!-- Check if the question should be excluded by questionId -->
    <xsl:if test="not(contains(concat(' ', $questionsToExclude, ' '),concat(' ', $questionIdWithoutScope, ' ')))">
      <!-- Check if the question should be excluded by Type -->
      <xsl:if test="not((contains(concat(' ', $questionTypesToExclude, ' '),concat(' ', $questionType, ' '))))">
        <Question>
          <xsl:attribute name="entityId"><xsl:value-of select="$questionId" /></xsl:attribute>
          <QuestionScope>
            <xsl:choose>
              <xsl:when test="scope = 'GLOBAL'">
                <Application />
              </xsl:when>
              <xsl:otherwise>
                <!-- TODO: clarify multiple person approach with RAS -->
                <PersonReferenceId>#Person_InsuredPerson</PersonReferenceId>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="starts-with(scope, 'INSURANCEPRODUCT:')">
              <InsuranceCoverReferenceId>
                <xsl:value-of select="concat('#', substring-after(scope, 'INSURANCEPRODUCT:'))"/>
              </InsuranceCoverReferenceId>
            </xsl:if>
            <xsl:if test="starts-with(scope, 'ASSESSMENTFACTOR:')">
              <AssessmentFactorId>
                <xsl:value-of select="concat('#AF_', substring-after(scope, 'ASSESSMENTFACTOR:'))"/>
              </AssessmentFactorId>
            </xsl:if>
            <!-- check if surrounding element is a question that has reflexive questions -->

            <xsl:choose>
              <xsl:when test="../../type = 'assessment-factor-group'">
                <xsl:if test="../../../../id">
                  <QuestionReferenceId><xsl:value-of select="concat('#', ../../../../id)" /></QuestionReferenceId>
                </xsl:if>
              </xsl:when>
              <xsl:when test="../../id">
                <QuestionReferenceId><xsl:value-of select="concat('#', ../../id)" /></QuestionReferenceId>
              </xsl:when>
            </xsl:choose>
          </QuestionScope>
          <Index><xsl:value-of select="index" /></Index>
          <Question>
            <Text>
              <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
              <xsl:value-of select="caption" />
            </Text>
          </Question>
          <xsl:choose>
            <xsl:when test="constraints/required/text() = 'true'">
              <Optional>false</Optional>
            </xsl:when>
            <xsl:when test="constraints/required/text() = 'false'">
              <Optional>true</Optional>
            </xsl:when>
            <xsl:otherwise>
              <Optional>true</Optional>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="answer">
            <xsl:call-template name="answer">
              <xsl:with-param name="questionEntityId"><xsl:value-of select="$questionId" /></xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:call-template name="declarativeStatements"/>
        </Question>
      </xsl:if>
    </xsl:if>

    <!-- FIXME: how to display question groups in HR LH XML? -->
    <xsl:if test="type != 'group' and type != 'assessment-factor-group'">
    </xsl:if>

    <xsl:for-each select="questions/question">
      <xsl:call-template name="question"/>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="answer">
    <xsl:param name="questionEntityId"/>
    <Answers>
      <xsl:attribute name="type">
        <xsl:call-template name="mapAnswerType" >
          <xsl:with-param name="type" select="../type"/>
        </xsl:call-template>
      </xsl:attribute>
        <xsl:choose>
         <xsl:when test="../type = 'multiselection'">
           <xsl:for-each select="../options/option">
             <xsl:variable name="optionId"><xsl:value-of select="id"/></xsl:variable>
             <Answer>
               <!--
                <xsl:attribute name="entityId"><xsl:value-of select="concat('A_', $questionEntityId, '_', position())" /></xsl:attribute>
                 -->
               <xsl:attribute name="entityId"><xsl:value-of select="$optionId" /></xsl:attribute>
                <Text>
                  <Text>
                    <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                    <xsl:value-of select="label" />
                  </Text>
              </Text>
              <Value>
                <xsl:choose>
                  <xsl:when test="../../answer/option[id=$optionId]">true</xsl:when>
                  <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>
              </Value>
             </Answer>
           </xsl:for-each>
         </xsl:when>
         <xsl:when test="../type = 'singleselection'">
           <xsl:for-each select="../options/option">
             <xsl:variable name="optionId"><xsl:value-of select="id"/></xsl:variable>
             <Answer>
               <!--
                <xsl:attribute name="entityId"><xsl:value-of select="concat('A_', $questionEntityId, '_', position())" /></xsl:attribute>
                 -->
               <xsl:attribute name="entityId"><xsl:value-of select="$optionId" /></xsl:attribute>
                <Text>
                  <Text>
                    <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                    <xsl:value-of select="label" />
                  </Text>
                </Text>
                <Value>
                  <xsl:choose>
                    <xsl:when test="../../answer/id = id">true</xsl:when>
                    <xsl:otherwise>false</xsl:otherwise>
                  </xsl:choose>
                </Value>
             </Answer>
           </xsl:for-each>
         </xsl:when>
         <xsl:when test="../type = 'assessment-factor-search'">
           <xsl:for-each select="assessmentFactor">
             <Answer>
               <xsl:attribute name="entityId" ><xsl:value-of select="concat('A_AF_', id)" /></xsl:attribute>
               <Value>
                 <xsl:value-of select="label" />
               </Value>
             </Answer>
           </xsl:for-each>
         </xsl:when>
         <xsl:when test="../type = 'list'">
           <xsl:call-template name="mapListTypeAnswer">
             <xsl:with-param name="questionEntityId" select="$questionEntityId"/>
           </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
           <Answer>
             <xsl:attribute name="entityId" ><xsl:value-of select="concat('A_', $questionEntityId)" /></xsl:attribute>
             <Value>
               <xsl:value-of select="." />
             </Value>
           </Answer>
         </xsl:otherwise>
       </xsl:choose>
    </Answers>
  </xsl:template>

  <xsl:template name="mapListTypeAnswer">
   <xsl:param name="questionEntityId"/>
   <xsl:for-each select="entry">
     <xsl:variable name="rowIndex"><xsl:value-of select="position() - 1"/></xsl:variable>
     <xsl:for-each select="elements/element">
       <xsl:variable name="columnIndex"><xsl:value-of select="position() - 1"/></xsl:variable>
       <xsl:variable name="columnId"><xsl:value-of select="id"/></xsl:variable>
       <Answer>
         <xsl:attribute name="entityId">
           <xsl:value-of select="concat('A_', $questionEntityId,'_', $columnId, '_', ($rowIndex+1))" />
         </xsl:attribute>
         <Text>
           <xsl:attribute name="tableColumnIndex">
             <xsl:value-of select="$columnIndex" />
           </xsl:attribute>
           <xsl:attribute name="tableColumnType">
             <xsl:call-template name="mapAnswerType">
               <xsl:with-param name="type" select="type" />
             </xsl:call-template>
           </xsl:attribute>
           <Text>
             <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
             <xsl:value-of select="caption" />
           </Text>
         </Text>
         <xsl:choose>
           <xsl:when test="type = 'singleselection'">
             <RowText>
               <xsl:attribute name="tableRowIndex"><xsl:value-of select="$rowIndex" /></xsl:attribute>
               <Text>
                 <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                 <xsl:value-of select="answer/label" />
               </Text>
             </RowText>
             <Value>
               <xsl:value-of select="answer/id" />
             </Value>
           </xsl:when>
           <xsl:when test="type = 'assessment-factor-search'">
             <RowText>
               <xsl:attribute name="tableRowIndex"><xsl:value-of select="$rowIndex" /></xsl:attribute>
               <Text>
                 <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                 <xsl:value-of select="answer/assessmentFactor/label" />
               </Text>
             </RowText>
             <Value>
               <xsl:value-of select="answer/assessmentFactor/id" />
             </Value>
           </xsl:when>
           <xsl:otherwise>
             <RowText>
               <xsl:attribute name="tableRowIndex"><xsl:value-of select="$rowIndex" /></xsl:attribute>
               <Text>
                 <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                 <xsl:value-of select="answer" />
               </Text>
              </RowText>
              <Value>
                <xsl:value-of select="answer" />
              </Value>
            </xsl:otherwise>
          </xsl:choose>
        </Answer>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="declarativeStatements">
    <xsl:if test="./declarativeStatements/declarativeStatement/text()">
      <AdditionalAttributes>
        <xsl:for-each select="declarativeStatements/declarativeStatement">
          <Attribute>
            <Name>DeclarativeStatement</Name>
            <Value>
                <Text>
                  <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:value-of select="./text()"/>
                </Text>
            </Value>
          </Attribute>
        </xsl:for-each>
      </AdditionalAttributes>
    </xsl:if>
  </xsl:template>

  <xsl:template name="assessmentFactors">
    <AssessmentFactors>
      <xsl:for-each select="/*/assessmentFactors/assessmentFactor">
        <AssessmentFactor>
          <xsl:attribute name="entityId" ><xsl:value-of select="concat('AF_', id)" /></xsl:attribute>
          <Name>
            <Text>
              <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
              <xsl:value-of select="label"/>
            </Text>
          </Name>
          <xsl:call-template name="mapAssessmentCategory">
              <xsl:with-param name="assessmentCategory"><xsl:value-of select="category"/></xsl:with-param>
          </xsl:call-template>
        </AssessmentFactor>
      </xsl:for-each>
    </AssessmentFactors>
  </xsl:template>

  <xsl:template name="assessmentResults">
    <AssessmentResults>
        <AssessmentResult>
          <xsl:attribute name="riskAssessmentServiceVersion"><xsl:call-template name="knowledgeBaseVersion"/></xsl:attribute>
          <!-- TODO: default value -->
          <ValidFrom>1970-01-01T00:00:00</ValidFrom>
          <AssessedBy>ReFlex</AssessedBy>
          <Ratings>

            <!-- Product ratings -->
            <xsl:for-each select="/*/results/products/product/ratings/*/ratings/rating">
              <xsl:call-template name="rating">
                <xsl:with-param name="coverId">
                  <xsl:value-of select="../../../../id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>

            <!-- Cover ratings -->
            <xsl:for-each select="/*/results/products/product/covers/cover/ratings/*/ratings/rating">
              <xsl:call-template name="rating">
                <xsl:with-param name="coverId">
                  <xsl:value-of select="../../../../id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>

            <!-- Rider Ratings -->
            <xsl:for-each select="/*/results/products/product/riders/rider/ratings/*/ratings/rating">
              <xsl:call-template name="rating">
                <xsl:with-param name="coverId">
                  <xsl:value-of select="../../../../id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>

            <!-- Rider Cover Ratings -->
            <xsl:for-each select="/*/results/products/product/riders/rider/covers/cover/ratings/*/ratings/rating">
              <xsl:call-template name="rating">
                <xsl:with-param name="coverId">
                  <xsl:value-of select="../../../../id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>

          </Ratings>
        </AssessmentResult>
    </AssessmentResults>
  </xsl:template>

  <xsl:template name="decisionData">
    <DecisionData>
      <Decision>
        <xsl:attribute name="riskAssessmentServiceVersion"><xsl:call-template name="knowledgeBaseVersion"/></xsl:attribute>
        <!-- TODO: default value -->
        <ValidFrom>1970-01-01T00:00:00</ValidFrom>
        <AssessedBy>ReFlex</AssessedBy>
        <Ratings>
          <!-- Product ratings -->
          <xsl:for-each select="/*/results/products/product/ratings/*/ratings/rating">
            <xsl:call-template name="rating">
              <xsl:with-param name="coverId">
                <!-- FIXME: is it correct to refer to the life cover? what to do if a product consists of multiple covers? -->
                <xsl:value-of select="../../../../covers/cover/id"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </Ratings>
      </Decision>
    </DecisionData>
  </xsl:template>

  <xsl:template name="rating">
    <xsl:param name="coverId"/>
    <Rating>
      <Decision><xsl:value-of select="decision"/></Decision>
       <!-- All ResultTypes may contain Text -->
      <xsl:if test="attributes/Text">
        <DecisionText>
          <xsl:for-each select="attributes/Text">
            <Text>
              <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
              <xsl:value-of select="."/>
            </Text>
          </xsl:for-each>
        </DecisionText>
      </xsl:if>
      <xsl:call-template name="ratingTypes"/>
      <InsuranceCoverReference><xsl:value-of select="concat('#', $coverId)"/></InsuranceCoverReference>
    </Rating>
  </xsl:template>

  <xsl:template name="ratingTypes">
    <xsl:choose>
      <!-- ResultType Postpone may contain PostponeDuration (inMonth) -->
      <xsl:when test="decision = 'Postpone'">
        <Postpone>
          <xsl:call-template name="reasons"/>
          <Duration>
            <!-- use inMonths as default until specified -->
            <inMonths><xsl:value-of select="attributes/PostponeDuration"/></inMonths>
          </Duration>
        </Postpone>
      </xsl:when>
      <!-- ResultTypes: ReferToUnderwriter, ReferToExpert, GPR, ReferToClient map to Referral -->
      <xsl:when test="decision = 'ReferToUnderwriter' or decision = 'ReferToExpert' or decision = 'GPR' or decision = 'ReferToClient'">
        <xsl:if test="reason">
          <Referral>
            <xsl:call-template name="reasons"/>
          </Referral>
        </xsl:if>
      </xsl:when>
      <!-- ResultType Offer may contain EMLoading, FlatExtraLoading, FlatExtraDuration, AncillaryEMLoading, Exclusion -->
      <xsl:when test="decision = 'Offer'">
        <!-- since the combination of parameters determine what kind of loading will result
             the mapping is non-trivial see https://reflex-wiki.hannover-re.com/index.php/XML_Mapping_Results#Offer -->
        <xsl:call-template name="offerRatingType">
          <xsl:with-param name="loading">
            <xsl:choose>
              <!-- standard em loading in percent -->
              <xsl:when test="attributes/EMLoading">
                <xsl:value-of select="attributes/EMLoading"/>
              </xsl:when>
              <!-- ancillary em loading in percent -->
              <xsl:when test="attributes/AncillaryEMLoading">
                <xsl:value-of select="attributes/AncillaryEMLoading"/>
              </xsl:when>
              <!-- flat extra loading will only be a loading if no duration is set -->
              <xsl:when test="attributes/FlatExtraLoading and not(attributes/FlatExtraDuration)">
                <xsl:value-of select="attributes/FlatExtraLoading"/>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="temporaryLoading">
            <xsl:choose>
              <!-- temporary loadings are only supported for flat extra durations yet -->
              <xsl:when test="attributes/FlatExtraLoading and attributes/FlatExtraDuration">
                <xsl:value-of select="attributes/FlatExtraLoading"/>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="loadingDuration">
            <xsl:choose>
              <!-- temporary loadings are only supported for flat extra durations yet -->
              <xsl:when test="attributes/FlatExtraDuration">
                <xsl:value-of select="attributes/FlatExtraDuration"/>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="flat">
              <xsl:choose>
              <!-- em loadings in percent -->
              <xsl:when test="attributes/EMLoading or attributes/AncillaryEMLoading">
                <xsl:value-of select="'false'"/>
              </xsl:when>
              <!-- flat loading in permille without duration -->
              <xsl:when test="attributes/FlatExtraLoading and not(attributes/FlatExtraDuration)">
                <xsl:value-of select="'true'"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- default is percent -->
                <xsl:value-of select="'false'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="ancillary">
              <xsl:choose>
              <!-- only AncillaryEMLoading are ancillary -->
              <xsl:when test="attributes/AncillaryEMLoading">
                <xsl:value-of select="'true'"/>
              </xsl:when>
              <!-- default no flag set -->
              <xsl:otherwise>
                <xsl:value-of select="'false'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <!-- ResultType Decline may contain Text -->
      <xsl:when test="decision = 'Decline'">
        <xsl:if test="reason">
          <Decline>
            <xsl:call-template name="reasons"/>
          </Decline>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- put reasons into rating node if no dedicated rating type node exists -->
        <xsl:call-template name="reasons"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    Template to create offer rating nodes. The existence of the different attributes must be determined by the calling template.
    This template simply creates the necessary nodes if the acording parameters are set.
   -->
  <xsl:template name="offerRatingType">
    <xsl:param name="loading"/>
    <xsl:param name="temporaryLoading"/>
    <xsl:param name="loadingDuration"/>
    <xsl:param name="flat"/>
    <xsl:param name="ancillary"/>
    <!-- helper variable to check for empty inputs -->
    <xsl:variable name="empty_string"/>
    <xsl:choose>
      <xsl:when test="$loading != $empty_string or $temporaryLoading != $empty_string or attributes/Exclusion != $empty_string">
        <Offer>
          <xsl:if test="$loading != $empty_string or $temporaryLoading != $empty_string">
            <Loading>
              <xsl:call-template name="reasons" />
              <xsl:if test="$loading != $empty_string">
                <Value>
                  <xsl:value-of select="$loading" />
                </Value>
                <xsl:choose>
                  <xsl:when test="$flat = 'true'">
                    <Unit>permille</Unit>
                  </xsl:when>
                  <xsl:otherwise>
                    <Unit>percent</Unit>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>

              <xsl:call-template name="mapAssessmentCategory">
                <xsl:with-param name="assessmentCategory"><xsl:value-of select="name(../..)"/></xsl:with-param>
              </xsl:call-template>

              <xsl:if test="$loading != $empty_string">
                <xsl:if test="$ancillary = 'true'">
                  <!-- FIXME: should the Ancillary flag be set? -->
                  <Ancillary>true</Ancillary>
                </xsl:if>
              </xsl:if>

              <xsl:if test="$temporaryLoading != $empty_string">
                <TemporaryLoading>
                  <Value>
                    <xsl:value-of select="$temporaryLoading" />
                  </Value>
                  <Unit>permille</Unit>
                  <Delay>
                    <!-- use inMonths as default until specified -->
                    <inMonths>
                      <xsl:value-of select="$loadingDuration" />
                    </inMonths>
                  </Delay>
                </TemporaryLoading>
              </xsl:if>
            </Loading>
          </xsl:if>

          <!-- Exclusion Clause Mapping (can be combined with loadings) -->
          <xsl:if test="attributes/Exclusion">
            <CoverRestriction>
              <xsl:call-template name="reasons" />
              <Type>ExclusionClause</Type>
              <Clause>
                <Text>
                  <xsl:attribute name="lang"><xsl:value-of select="$language" /></xsl:attribute>
                  <xsl:value-of select="attributes/Exclusion" />
                </Text>
              </Clause>
              <xsl:call-template name="mapAssessmentCategory">
                <xsl:with-param name="assessmentCategory"><xsl:value-of select="name(../..)"/></xsl:with-param>
              </xsl:call-template>
            </CoverRestriction>
          </xsl:if>
        </Offer>
      </xsl:when>
      <xsl:otherwise>
        <!-- put reasons into rating node if no Offer node exists -->
        <xsl:call-template name="reasons"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mapAssessmentCategory">
    <xsl:param name="assessmentCategory"/>
    <xsl:if test="$assessmentCategory != 'Global'">
      <Category>
        <xsl:choose>
          <xsl:when test="$assessmentCategory = 'Medical'      ">medical</xsl:when>
          <xsl:when test="$assessmentCategory = 'Occupational' ">occupational</xsl:when>
          <xsl:when test="$assessmentCategory = 'Residential'  ">residential</xsl:when>
          <xsl:when test="$assessmentCategory = 'Avocational'  ">avocational</xsl:when>
          <xsl:when test="$assessmentCategory = 'Medication'   ">medication</xsl:when>
          <xsl:when test="$assessmentCategory = 'Laboratory'   ">laboratory</xsl:when>
          <xsl:when test="$assessmentCategory = 'Personal'     ">personal</xsl:when>
          <xsl:when test="$assessmentCategory = 'Financial'    ">financial</xsl:when>
          <xsl:when test="$assessmentCategory = 'OtherCategory'">other</xsl:when>
          <xsl:otherwise>other</xsl:otherwise>
        </xsl:choose>
      </Category>
    </xsl:if>
  </xsl:template>

  <xsl:template name="reasons">
    <Reasons>
    <xsl:for-each select="reason/assessmentFactors/*">
      <Reason>
        <Text>
          <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
          <xsl:call-template name="assessmentFactorLabel">
            <!-- Pre FLA Patch for declarative statements -->
            <!-- <xsl:with-param name="assessmentFactorId" select="name(.)"/> -->
            <xsl:with-param name="assessmentFactorId" select="."/>
          </xsl:call-template>
        </Text>
      </Reason>
    </xsl:for-each>
  </Reasons>
  </xsl:template>

  <xsl:template name="getPersonReference">
    <xsl:param name="id" />
    <xsl:value-of select="concat('Person_', $id)" />
  </xsl:template>

  <xsl:template name="mapPersonWeight">
    <xsl:param name="personId" />
    <xsl:variable name="weightInKg">
      <xsl:call-template name="getQuestionDataSimple" >
        <xsl:with-param name="scope" select="$personId"/>
        <xsl:with-param name="question">Weight</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$weightInKg != ''">
      <WeightDetails>
        <Weight>
          <xsl:value-of select="concat($weightInKg, '000')"/>
        </Weight>
        <!-- FIXME: handle lbs -->
        <Unit displayAs="kg">g</Unit>
      </WeightDetails>
    </xsl:if>
  </xsl:template>

  <xsl:template name="mapPersonHeight">
    <xsl:param name="personId" />
    <xsl:variable name="heightInCm">
      <xsl:call-template name="getQuestionDataSimple" >
        <xsl:with-param name="scope" select="$personId"/>
        <xsl:with-param name="question">Height</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$heightInCm != ''">
      <HeightDetails>
        <Height><xsl:value-of select="$heightInCm"/></Height>
        <!-- FIXME: handle ins -->
        <Unit displayAs="cm">cm</Unit>
      </HeightDetails>
    </xsl:if>
  </xsl:template>

  <xsl:template name="getQuestionDataSimple">
    <xsl:param name="scope" />
    <xsl:param name="question" />
    <xsl:choose>
      <xsl:when test="$scope">
        <xsl:value-of select="//questions/question[id=concat($scope, '.', $question)]/answer"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="//questions/question[id=$question]/answer"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getQuestionAnswerId">
    <xsl:param name="scope" />
    <xsl:param name="question" />
        <xsl:choose>
      <xsl:when test="$scope">
        <xsl:value-of select="//questions/question[id=concat($scope, '.', $question)]/answer/id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="//questions/question[$question]/answer/id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mapSimplePersonTextData">
    <xsl:param name="person" />
    <xsl:param name="attribute" />
    <xsl:param name="outputElement" />
    <xsl:variable name="value">
      <xsl:call-template name="getQuestionDataSimple">
        <xsl:with-param name="scope" select="$person"/>
        <xsl:with-param name="question" select="$attribute"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$value != ''">
      <xsl:element name="{$outputElement}">
        <Text>
          <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
          <xsl:value-of select="$value"/>
        </Text>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="knowledgeBaseVersion">
    <xsl:variable name="cedentId"><xsl:value-of select="/*/meta/ras/cedent/id"/></xsl:variable>
    <xsl:variable name="kbId"><xsl:value-of select="/*/meta/ras/knowledgebase/id"/></xsl:variable>
    <xsl:variable name="kbVersion"><xsl:value-of select="/*/meta/ras/knowledgebase/version"/></xsl:variable>
    <xsl:value-of select="concat($kbId, '-' , $kbVersion)"/>
  </xsl:template>

  <xsl:template name="mapGenderCode">
    <xsl:param name="gender" />
    <xsl:choose>
      <xsl:when test="$gender='Male'">M</xsl:when>
      <xsl:when test="$gender='Female'">F</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mapAnswerType">
    <xsl:param name="type" />
    <xsl:choose>
      <xsl:when test="$type = 'multiselection'">multiselection</xsl:when>
      <xsl:when test="$type = 'singleselection'">selection</xsl:when>
      <xsl:when test="$type = 'assessment-factor-search'">search</xsl:when>
      <xsl:when test="$type = 'text'">text</xsl:when>
      <xsl:when test="$type = 'date'">date</xsl:when>
      <xsl:when test="$type = 'list'">dynamictable</xsl:when>
      <xsl:when test="$type = 'number'">
        <xsl:choose>
          <xsl:when test="../precision = '0'">numeric</xsl:when>
          <xsl:otherwise>decimal</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="assessmentFactorLabel">
    <xsl:param name="assessmentFactorId" />
    <xsl:value-of select="//assessmentFactors/assessmentFactor[id=$assessmentFactorId]/label"/>
  </xsl:template>

  <!-- Helper template to get last segment after the separator (in contrast to substring-after(...) that gives the substring after the first match) -->
  <xsl:template name="GetLastSegment">
    <xsl:param name="value" />
    <xsl:param name="separator" select="'.'" />
    <xsl:choose>
      <xsl:when test="contains($value, $separator)">
        <xsl:call-template name="GetLastSegment">
          <xsl:with-param name="value" select="substring-after($value, $separator)" />
          <xsl:with-param name="separator" select="$separator" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
