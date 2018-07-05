<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dispatch_Address_Confirmed</fullName>
        <description>Dispatch Address Confirmed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Dispatch_Address_Confirmed</template>
    </alerts>
    <alerts>
        <fullName>Order_is_Dispatched</fullName>
        <description>Order is Dispatched</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Order_Dispatched</template>
    </alerts>
</Workflow>
