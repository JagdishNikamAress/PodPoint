/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trMetadataDescriber {
    global trMetadataDescriber() {

    }
    global static Map<Schema.SObjectType,TASKRAY.trMetadataDescriber.ObjectMetadataDescribeResult> getBoardDescribeData() {
        return null;
    }
global class FieldMetadataDescribeResult {
    global Boolean isAccessible {
        get;
        set;
    }
    global Boolean isCreateable {
        get;
        set;
    }
    global Boolean isEncrypted {
        get;
        set;
    }
    global Boolean isGroupable {
        get;
        set;
    }
    global Boolean isUpdateable {
        get;
        set;
    }
    global FieldMetadataDescribeResult(Schema.SObjectField fieldToken) {

    }
}
global class ObjectMetadataDescribeResult {
    global ObjectMetadataDescribeResult(Schema.SObjectType objectToken) {

    }
    global TASKRAY.trMetadataDescriber.FieldMetadataDescribeResult getField(String fieldName) {
        return null;
    }
}
}
