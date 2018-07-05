<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Flag_update</fullName>
        <field>Needs_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Flag update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_update_after_Rejection</fullName>
        <field>Needs_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Flag update after Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Expiry_to_30_Days</fullName>
        <description>Sets the expiration date of a quote to 30 days.</description>
        <field>ExpirationDate</field>
        <formula>TODAY() + 30</formula>
        <name>Set Quote Expiry to 30 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Approval_Flag</fullName>
        <field>In_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Update In Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Approval_Flag2</fullName>
        <field>In_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Update In Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_In_Approval_Flag3</fullName>
        <field>In_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Update In Approval Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Default Actions When a Quote is Created</fullName>
        <actions>
            <name>Set_Quote_Expiry_to_30_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Follow_Up_Quote</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/2000</value>
        </criteriaItems>
        <description>When A Quote is Created - Set the default expiry date to 30 days in the future.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_Up_Quote</fullName>
        <assignedToType>owner</assignedToType>
        <description>Creates a follow up task when a quote is created.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Follow Up Quote</subject>
    </tasks>
</Workflow>
