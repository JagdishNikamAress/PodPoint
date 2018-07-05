<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>When_WO_becomes_scheduled</fullName>
        <description>When WO becomes scheduled</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Homecharge_Install_Scheduled</template>
    </alerts>
    <fieldUpdates>
        <fullName>subject_name</fullName>
        <description>auto populate subject field of WorkOrder by concatenating &quot;WorkType+AccountName&quot; for business account and &quot;WorkType+AccountFirstName+AccountLastName&quot; for person account</description>
        <field>Subject</field>
        <formula>WorkType.Name + &apos; - &apos; + Account.Name + Account.FirstName + &apos; &apos; + Account.LastName</formula>
        <name>subject name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>subject field on wo</fullName>
        <actions>
            <name>subject_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>WorkOrder.WorkTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.AccountId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
