import { LightningElement, api } from 'lwc';

import getRecords from '@salesforce/apex/CGS_ContactInfoController.getRecords';
import updateMetadataContact from '@salesforce/apex/CGS_ContactInfoController.updateMetadataContact';
import hasViewRecords from '@salesforce/customPermission/Edit_Contact_Information';

export default class CGS_ContactInfo extends LightningElement 
{
    @api contactInfoId;

    isModalOpen = false;
    fieldsToUpdate = {};
    fieldsBoldToUpdate = {};
    fieldsHideLabelToUpdate = {};
    fieldsSequenceToUpdate = {};
    fieldsCSSClassToUpdate = {};

    CSSOptions = [];

    cRecords;
    error;

    get editAllow() {
        return hasViewRecords;
    }

    connectedCallback()
    {
        getRecords({ contactInfoId: this.contactInfoId })
            .then(result => {
                console.log('getRecords ==> Json Result: ' + JSON.stringify(result));
                this.populateData(result); 
                this.error = undefined;
            })
            .catch(error => {
                console.log('getRecords ==> Json Error: ' + JSON.stringify(result));
                this.error = error;
                this.data = undefined;
            });
    }

    handleFieldChange(event) 
    {
        this.fieldsToUpdate[event.target.name] = event.target.value;
        for (var i = 0; i < this.cRecords.length; i++) 
        {
            if (this.cRecords[i].DeveloperName === event.target.name) 
            {
              this.cRecords[i].Value__c = event.target.value;
              break;
            }
        }
    }

    handleFieldBoldChange(event) 
    {
        this.fieldsBoldToUpdate[event.target.name] = event.target.checked;
        for (var i = 0; i < this.cRecords.length; i++) 
        {
            if (this.cRecords[i].DeveloperName === event.target.name) 
            {
              this.cRecords[i].Bold__c = event.target.checked;
              break;
            }
        }
    }

    handleFieldHideLabelChange(event) 
    {
        this.fieldsHideLabelToUpdate[event.target.name] = event.target.checked;
        for (var i = 0; i < this.cRecords.length; i++) 
        {
            if (this.cRecords[i].DeveloperName === event.target.name) 
            {
              this.cRecords[i].Hide_Label__c = event.target.checked;
              break;
            }
        }
    }

    handleFieldCSSClassChange(event) 
    {
        this.fieldsCSSClassToUpdate[event.target.name] = event.target.value;
        for (var i = 0; i < this.cRecords.length; i++) 
        {
            if (this.cRecords[i].DeveloperName === event.target.name) 
            {
              this.cRecords[i].CSS_Class__c = event.target.value;
              break;
            }
        }
    }
    
    handleFieldSequenceChange(event) 
    {
        this.fieldsSequenceToUpdate[event.target.name] = event.target.value;
        for (var i = 0; i < this.cRecords.length; i++) 
        {
            if (this.cRecords[i].DeveloperName === event.target.name) 
            {
              this.cRecords[i].Sequence__c = event.target.value;
              break;
            }
        }
    }

    openModal() 
    {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }

    cancel() 
    {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;    
    }
    
    submit() 
    {   
        console.log('submit ==> this.fieldsToUpdate: ' + JSON.stringify(this.fieldsToUpdate));
        console.log('submit ==> this.fieldsBoldToUpdate: ' + JSON.stringify(this.fieldsBoldToUpdate));
        console.log('submit ==> this.fieldsHideLabelToUpdate: ' + JSON.stringify(this.fieldsHideLabelToUpdate));
        console.log('submit ==> this.fieldsCSSClassToUpdate: ' + JSON.stringify(this.fieldsCSSClassToUpdate));
        console.log('submit ==> this.fieldsSequenceToUpdate: ' + JSON.stringify(this.fieldsSequenceToUpdate));
        console.log('submit ==> this.cRecords: ' + JSON.stringify(this.cRecords)) ;
        updateMetadataContact({fieldsToUpdate: JSON.stringify(this.fieldsToUpdate),
            fieldsBoldToUpdate: JSON.stringify(this.fieldsBoldToUpdate),
            fieldsHideLabelToUpdate: JSON.stringify(this.fieldsHideLabelToUpdate),
            fieldsCSSClassToUpdate: JSON.stringify(this.fieldsCSSClassToUpdate),
            fieldsSequenceToUpdate: JSON.stringify(this.fieldsSequenceToUpdate)})
        .then((result) => {
            this.error = undefined;
            //alert('Done update');
        })
        .catch((error) => {
            this.error = error;
        });
        
        this.isModalOpen = false;     
    }

    populateData(record) 
       {
        var tempRecord = JSON.parse(JSON.stringify(record));

        this.CSSOptions = [];
        var tempCSSOptions = tempRecord.CSSOptions;
        console.log('populateData ==> tempCSSOptions: ' + tempCSSOptions);
        for (var i = 0; i < tempCSSOptions.length; i++) 
        {
            //console.log('populateData ==> tempCSSOptions[i]: ' +tempCSSOptions[i]);
            var option= new Option(tempCSSOptions[i],tempCSSOptions[i]);
            this.CSSOptions.push(option);
        }
        console.log('populateData ==> : this.CSSOptions' + this.CSSOptions);

        /***** Setting cRecords to display */
        this.cRecords = new Array();
        var tempRecords = tempRecord.ContactInfoDetailList;
        tempRecords.forEach(tRecord => 
        {                
            var temprecord = JSON.parse(JSON.stringify(tRecord));
            this.cRecords.push(temprecord);
            console.log('populateData ==> : ContactInfoDetail' + JSON.stringify(temprecord));            
        });

    }

}