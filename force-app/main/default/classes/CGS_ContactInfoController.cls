/*********************
*   PDFViewController
*   @author:        Minh H Ma
*   @date:          12/17/2020
*   descrtiption:   This is to render email template to PDF, save as content file, and 
*                   link the file to provided recordId
*
*                   Parameters:
*                   formId: can be either valid classic or lightning email template's name.
*                   recordId: can be any salesforce record Id.
*                   formParamters: Json string. if passing in object make sure append 'list' to
*                       object name. For example:
*                           contact ==> contactlist
*                           email   ==> emaillist
*                       example formParamters input:
*                           {"contactname":"Sean Forbes","repname":"Tim Pitman","createddate":"12/21/2020","batterlist":[{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" },{ "id": "1003", "type": "Blueberry" },{ "id": "1004", "type": "Devils Food" }]}
*
*   Update History:
*   12/17/2020  Intial Version
*********************/
public with sharing class CGS_ContactInfoController implements Metadata.DeployCallback 
{
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('Success Result-' + result);
        } else {
            System.debug('Failed Result-' + result);
        }
    }

    @AuraEnabled(Cacheable = true)
    public static lwcData getRecords(string contactInfoId)
    {
        System.debug('getRecords ==> contactInfoId: '+ contactInfoId);
        lwcData oLWCData = new lwcData();
        oLWCData.contactInfo = contactInfoId;

        oLWCData.CSSOptions = new list<string>(picklistOptions('Contact_Information_Detail__mdt','CSS_Class__c'));

        System.debug('getRecords ==> oLWCData.CSSOptions: '+ oLWCData.CSSOptions);
        
        List<Contact_Information_Header__mdt> CIH_MDTList = 
            [select id, MasterLabel from Contact_Information_Header__mdt];
            
        oLWCData.ContactInfoDetailList =  
            [select id, MasterLabel, DeveloperName, Type__c, Sequence__c, Value__c, 
                Hide_Label__c, CSS_Class__c, Bold__c
                from Contact_Information_Detail__mdt 
                where Contact_Information_Header__c = :contactInfoId
                    and Hide_Field__c = false order by Sequence__c];
        System.debug('getRecords ==> oLWCData.ContactInfoDetailList: '+ oLWCData.ContactInfoDetailList);
        System.debug('getRecords ==> oLWCData.ContactInfoDetailList.size(): '+ oLWCData.ContactInfoDetailList.size());
        
        System.debug('getRecords ==> oLWCData: ' + oLWCData);
        return oLWCData;

    }

    @AuraEnabled
    public static void updateMetadataContact (String fieldsToUpdate, String fieldsBoldToUpdate,
                String fieldsHideLabelToUpdate, String fieldsCSSClassToUpdate,
                String fieldsSequenceToUpdate)
    {
        string fieldStr;
        Boolean updateBln;

        for (Contact_Information_Detail__mdt CIDObj : [SELECT MasterLabel, DeveloperName,
            value__c, bold__c, Hide_Label__c, sequence__c FROM Contact_Information_Detail__mdt])
        {
            updateBln = false;

            // set CIDObj.Value__c;
            fieldStr = getField(fieldsToUpdate, CIDObj.DeveloperName);
            if (!String.isEmpty(fieldStr) )
            {
                CIDObj.Value__c = fieldStr;
                updateBln = true;
            }

            // set CIDObj.Bold__c;
            fieldStr = getField(fieldsBoldToUpdate, CIDObj.DeveloperName);
            if (!String.isEmpty(fieldStr) )
            {
                CIDObj.Bold__c = false;
                if (fieldStr == 'true')
                    CIDObj.Bold__c = true;
                updateBln = true;
            }

            // set CIDObj.Hide_Label__c;
            fieldStr = getField(fieldsHideLabelToUpdate, CIDObj.DeveloperName);
            if (!String.isEmpty(fieldStr) )
            {
                CIDObj.Hide_Label__c = false;
                if (fieldStr == 'true') 
                    CIDObj.Hide_Label__c = true;
                updateBln = true;
            }

            // set CIDObj.CSS_Class__c;
            fieldStr = getField(fieldsCSSClassToUpdate, CIDObj.DeveloperName);
            if (!String.isEmpty(fieldStr) )
            {
                CIDObj.CSS_Class__c = fieldStr;
                updateBln = true;
            }

            // set CIDObj.Sequence__c;
            fieldStr = getField(fieldsSequenceToUpdate, CIDObj.DeveloperName);
            if (!String.isEmpty(fieldStr) )
            {
                CIDObj.Sequence__c = integer.valueof(fieldStr);
                updateBln = true;
            }
            
            if (updateBln)
            {
                System.debug('updateMetadataContact ==> CIDObj: ' + CIDObj);
                updateMetaData(CIDObj);
            }                
        }        
    }

    private static string getField(string fieldToUpdate, string developerNameStr)
    {
        Map<String, Object> fieldMap = (Map<String, Object>) Json.deserializeUntyped(fieldToUpdate);
        return String.Valueof(fieldMap.get(developerNameStr));
    }

    private static void updateMetaData(Contact_Information_Detail__mdt CIDObj)
    {
        Metadata.CustomMetadata cMetadata = new Metadata.CustomMetadata();
        cMetadata.fullName = 'Contact_Information_Detail__mdt.' + CIDObj.DeveloperName;
        cMetadata.label = CIDObj.masterlabel;
    
        //Update Custom Values
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Value__c';
        customField.value = CIDObj.Value__c;
        cMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'bold__c';
        customField.value = CIDObj.bold__c;
        cMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Hide_Label__c';
        customField.value = CIDObj.Hide_Label__c;
        cMetadata.values.add(customField);

        customField = new Metadata.CustomMetadataValue();
        customField.field = 'sequence__c';
        customField.value = CIDObj.sequence__c;
        cMetadata.values.add(customField);

        //Deploy to perform 'Update'
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(cMetadata);
        CGS_ContactInfoController callback = new CGS_ContactInfoController();
        Id jobId = Test.isRunningTest() ? 'Fake Job Id' : Metadata.Operations.enqueueDeployment(mdContainer, callback);

    }
        
    /*****
     * lwcData
    */
    public with sharing class lwcData 
    {
        @AuraEnabled public string contactInfo;
        @AuraEnabled public List<String> CSSOptions;
        @AuraEnabled public List<Contact_Information_Detail__mdt> ContactInfoDetailList;

        public lwcData() {}
    }

    public Static List<String> picklistOptions (string objStr, string fieldNameStr)
    {
        List<String> picklistOptionList = new List<String>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objStr) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldNameStr).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)
        {
            System.debug('Label: ' + pickListVal.getLabel() + ' / Value: '+ pickListVal.getValue());
            picklistOptionList.add(pickListVal.getLabel());
        }
        
        return picklistOptionList;
    }

}
