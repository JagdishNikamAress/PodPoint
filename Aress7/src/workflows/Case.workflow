<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Annex_D_Jeopardy</fullName>
        <description>Annex D &apos;Jeopardy&apos;</description>
        <protected>false</protected>
        <recipients>
            <recipient>marketing@pod-point.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Annex_D_Jeopardy</template>
    </alerts>
    <alerts>
        <fullName>Feedback_Form_on_Case_Closure</fullName>
        <description>Feedback Form on Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/CustomerSurvey1</template>
    </alerts>
    <alerts>
        <fullName>Feedback_Form_on_Case_Closure_web_user</fullName>
        <description>Feedback Form on Case Closure to web user</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/CustomerSurvey1</template>
    </alerts>
    <alerts>
        <fullName>Install_Quote_Cost</fullName>
        <description>Install Quote Cost</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Survey_Install_Cost_Quoted</template>
    </alerts>
    <alerts>
        <fullName>Install_case_is_ready_to_be_commissioned</fullName>
        <description>Install case is ready to be commissioned</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Install_case_is_Ready_to_be_Commissioned</template>
    </alerts>
    <alerts>
        <fullName>Install_case_is_scheduled</fullName>
        <description>Install case is scheduled</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Install_case_is_scheduled</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_case</fullName>
        <description>Maintenance case Created with account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Maintenance_Case_Escalated</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_case_Scheduled</fullName>
        <description>Maintenance case Scheduled with account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Maintenance_Case_Scheduled</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_case_completed</fullName>
        <description>Maintenance case Completed with account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Maintenance_Case_Completed</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_case_incompleted</fullName>
        <description>Maintenance case Incomplete with account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Maintenance_Case_Incomplete</template>
    </alerts>
    <alerts>
        <fullName>OLEV_Email_1</fullName>
        <description>OLEV Email 1</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OLEV_Emails_Automated/OLEV_Email_1</template>
    </alerts>
    <alerts>
        <fullName>OLEV_Email_2</fullName>
        <description>OLEV Email 2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OLEV_Emails_Automated/OLEV_Email_2</template>
    </alerts>
    <alerts>
        <fullName>Send_Email</fullName>
        <description>Send Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>emma.jones@pod-point.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Customer_Support_Case_Open_24_Hours</template>
    </alerts>
    <alerts>
        <fullName>Support_case</fullName>
        <description>Support case Created with account</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Support_Case_Created</template>
    </alerts>
    <alerts>
        <fullName>Survey_Case_is_Scheduled</fullName>
        <description>Survey Case is Scheduled</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Survey_Case_is_Scheduled</template>
    </alerts>
    <alerts>
        <fullName>Survey_Case_is_complete</fullName>
        <description>Survey Case is complete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Survey_Complete</template>
    </alerts>
    <alerts>
        <fullName>Tesco_Trial_Support_Case_Alert</fullName>
        <ccEmails>charlie.harbage@pod-point.com</ccEmails>
        <description>Tesco Trial Support Case Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>alex.mckinney@pod-point.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>charles.roberts@pod-point.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>katrina.sherwani@pod-point.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Tesco_Trial_Support_Case</template>
    </alerts>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <description>Close the Case when status remain pending for 7 Days.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Case_Owner_Change_Date</fullName>
        <description>Last date/time when Case Owner has changed.</description>
        <field>Last_Case_Owner_Change_Date__c</field>
        <formula>NOW()</formula>
        <name>Last Case Owner Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Date_When_SA_Became_Quoted</fullName>
        <field>Date_When_Survey_Became_Quoted__c</field>
        <formula>NOW()</formula>
        <name>Populate Date When SA Became Quoted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Date_When_SA_Became_Scheduled_F</fullName>
        <field>Date_When_Survey_Became_Scheduled__c</field>
        <formula>NOW()</formula>
        <name>Populate Date When SA Became Scheduled F</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_24_Hours_Since_Case_Created</fullName>
        <description>Update the 24 Hours Since Case Created</description>
        <field>X24_Hours_Since_Case_Created__c</field>
        <literalValue>1</literalValue>
        <name>Update the 24 Hours Since Case Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check the 24 Hours checkbox Since Case Created</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Tick checkbox after 24 hours since Case creation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_the_24_Hours_Since_Case_Created</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Close case after 7 days on Pending</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>Jones,Meredith,Mclean,Platipodis</value>
        </criteriaItems>
        <description>Close case after 7 days on Pending.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Date When Survey Became Quoted</fullName>
        <actions>
            <name>Populate_Date_When_SA_Became_Quoted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Survey_Status__c, &apos;Quoted&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date When Survey Became Scheduled</fullName>
        <actions>
            <name>Populate_Date_When_SA_Became_Scheduled_F</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Survey_Status__c, &apos;Scheduled&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Case Owner Change Date</fullName>
        <actions>
            <name>Last_Case_Owner_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email when Case opens for more than 24 business hrs</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>Jones,Meredith,Mclean,Platipodis</value>
        </criteriaItems>
        <description>Send Email to Emma Jones when case is open for more than 24 hrs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
