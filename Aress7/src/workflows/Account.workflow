<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Strat_Accnt_Stg_Las_Update</fullName>
        <field>Strategic_Account_Stage_Last_Updated__c</field>
        <formula>today()</formula>
        <name>Set Strat Accnt Stg Las Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Strategic Account Stage Change Time Stamp</fullName>
        <actions>
            <name>Set_Strat_Accnt_Stg_Las_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged( Strategic_Account_Stage__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
