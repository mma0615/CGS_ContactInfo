@istest
public with sharing class CGS_ContactInfoControllerTest 
{
    @istest
    public static void testCGS_GlobalContactInfo()
    {
        CGS_GlobalContactInfo GContactInfo = new CGS_GlobalContactInfo();
        
        string defaultValue = string.valueOf(GContactInfo.getDefaultValue());
        System.assertNotEquals( null, defaultValue, 'No Default Value found' );
        
        defaultValue = string.valueOf(GContactInfo.getValues() );
        System.assertNotEquals( null, defaultValue, 'No Values found' );
    }

    @istest
    public static void TestCGS_ContactInfoControllerHandleresult() 
    {
        Test.startTest();
        
        //***** Testing handleresult
        CGS_ContactInfoController callback = new CGS_ContactInfoController();       
        // Create test result and context objects.
        Metadata.DeployResult result = new Metadata.DeployResult();
        result.numberComponentErrors = 1;
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();

        // Invoke the callback's handleResult method.
        callback.handleResult(result, context);
        
        Test.stopTest();
        
    }

    @istest
    public static void TestCGS_ContactInfoControllerGetRecords() 
    {
		List<Contact_Information_Header__mdt> CIH_MDTList = 
            [select id, MasterLabel from Contact_Information_Header__mdt]; 
        system.debug(CIH_MDTList[0].id) ;
        
        Test.startTest();
                
        //**** Testing getRecords  
        //with Valid Id      
        CGS_ContactInfoController.lwcData lwcData = CGS_ContactInfoController.getRecords(CIH_MDTList[0].id);        
        System.assertNotEquals( 0, lwcData.ContactInfoDetailList.size(), 'No lwc Data Return' );
        
        //with Invalid Id 
        lwcData = CGS_ContactInfoController.getRecords(null); 
        System.assertEquals(0, lwcData.ContactInfoDetailList.size(), 'Not lwc Data Return' );
        
        Test.stopTest();
        
    }


    @istest
    public static void TestCGS_ContactInfoController() 
    {
		List<Contact_Information_Header__mdt> CIH_MDTList = 
            [select id, MasterLabel from Contact_Information_Header__mdt]; 
        system.debug(CIH_MDTList[0].id) ;
        
        Test.startTest();
        
        //**** Testing updateMetadataContact        
        List<Contact_Information_Detail__mdt> CID_MDTList = 
            [select id, MasterLabel, DeveloperName, Type__c, Sequence__c, Value__c, 
                Hide_Label__c, CSS_Class__c, Bold__c
                from Contact_Information_Detail__mdt 
                where Contact_Information_Header__c = :CIH_MDTList[0].id
                    and Type__c = 'Text' order by Sequence__c];
        
        //***** Testing 
        Map<string, string> fieldsToUpdateMap = new Map<string, string>();
        fieldsToUpdateMap.put(CID_MDTList[0].DeveloperName, 'Test');
        String fieldsToUpdate = JSON.serialize(fieldsToUpdateMap);
        System.debug('fieldsToUpdate: ' + fieldsToUpdate);
        
        Map<string, boolean> fieldsBoldToUpdateMap = new Map<string, boolean>();
        fieldsBoldToUpdateMap.put(CID_MDTList[0].DeveloperName, true);
        String fieldsBoldToUpdate = JSON.serialize(fieldsBoldToUpdateMap);
        System.debug('fieldsBoldToUpdate: ' + fieldsBoldToUpdate);
        
        Map<string, boolean> fieldsHideLabelToUpdateMap = new Map<string, boolean>();
        fieldsHideLabelToUpdateMap.put(CID_MDTList[0].DeveloperName, true);
        String fieldsHideLabelToUpdate = JSON.serialize(fieldsHideLabelToUpdateMap);
        System.debug('fieldsHideLabelToUpdate: ' + fieldsHideLabelToUpdate);
        
        Map<string, integer> fieldsSequenceToUpdateMap = new Map<string, integer>();
        fieldsSequenceToUpdateMap.put(CID_MDTList[0].DeveloperName, 20);
        String fieldsSequenceToUpdate = JSON.serialize(fieldsSequenceToUpdateMap);
        System.debug('fieldsSequenceToUpdate: ' + fieldsSequenceToUpdate);
        
        Map<string, string> fieldsCSSClassToUpdateMap = new Map<string, string>();
        fieldsCSSClassToUpdateMap.put(CID_MDTList[0].DeveloperName, 'abc');
        String fieldsCSSClassToUpdate = JSON.serialize(fieldsCSSClassToUpdateMap);
        System.debug('fieldsCSSClassToUpdate: ' + fieldsCSSClassToUpdate);
        
        CGS_ContactInfoController.updateMetadataContact(fieldsToUpdate, fieldsBoldToUpdate, 
                                                        fieldsHideLabelToUpdate, fieldsCSSClassToUpdate, 
                                                        fieldsSequenceToUpdate);
        Test.stopTest();
        
    }
}