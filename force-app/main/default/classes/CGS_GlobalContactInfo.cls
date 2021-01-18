global class CGS_GlobalContactInfo extends VisualEditor.DynamicPickList {

    List<Contact_Information_Header__mdt> CIH_MDTList;

    public CGS_GlobalContactInfo() {
        CIH_MDTList = [select id, MasterLabel from Contact_Information_Header__mdt];
    }

    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = 
            new VisualEditor.DataRow(CIH_MDTList[0].MasterLabel, 
                string.valueOf(CIH_MDTList[0].id) );
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
        
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        if (CIH_MDTList.size() > 0)
        {
            for (Contact_Information_Header__mdt oCIH : CIH_MDTList)
            {
                VisualEditor.DataRow value = 
                    new VisualEditor.DataRow(oCIH.MasterLabel, 
                    string.valueOf(oCIH.Id));
                myValues.addRow(value);
            }            
        }
        return myValues;
    }
}
