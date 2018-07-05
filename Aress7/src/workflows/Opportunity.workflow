<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Chargent_Confirmation_to_Opp_Owner</fullName>
        <description>Chargent Confirmation to Opp Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Chargent_Payment_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Duplicate_Order</fullName>
        <description>Duplicate Order</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Duplicate_Order_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Survey_is_quoted</fullName>
        <description>Survey is quoted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Survey_Install_Cost_Quoted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Is_Opportunity_Won_to_1</fullName>
        <description>When an opportunity is won this field is marked 1</description>
        <field>Is_Opportunity_Won__c</field>
        <formula>1</formula>
        <name>Change Is Opportunity Won to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HC_Install_Completed_Date</fullName>
        <field>Install_Completed_Date__c</field>
        <formula>NOW()</formula>
        <name>Install Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Boolean is Opportunity Won%3F</fullName>
        <actions>
            <name>Change_Is_Opportunity_Won_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Won</value>
        </criteriaItems>
        <description>When an opportunity is marked won this updates the 	Is_Opportunity_Won__c to &quot;1&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Install Completed Date</fullName>
        <actions>
            <name>HC_Install_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(StageName, &apos;Install Completed&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
