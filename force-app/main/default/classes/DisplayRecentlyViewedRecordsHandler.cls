/*
* @Name         DisplayRecentlyViewedRecordsHandler 
* @Author       Himanshu
* @Date         5-July-2021
* @Description  Controller class for DisplayRecentlyViewedRecords LWC component.
*/
public with sharing class DisplayRecentlyViewedRecordsHandler {
    /*
    * @Description  Get User specific object list
    * @Return       Sobject key-value list. 
    */
    @AuraEnabled(cacheable = true)
    public static String getObjectList(){
        try {
            return JSON.serialize(SchemaUtility.getObjectList());
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*
    * @Description  Get list of selected object records
    * @Param		objectName - Select object name
    * @Param        recordCount - No. of records to display
    * @Return       Recordwrapper contains field name mapping and record list. 
    */
    @AuraEnabled(cacheable = true)
    public static RecordWrapper getRecords(String objectName, Integer recordCount) {
        try {
            String query = 'SELECT ';
            List<FieldInfoWrapper> fieldInfoList = SchemaUtility.getFields(objectName);
            for(FieldInfoWrapper fieldInfo : fieldInfoList) {
                query += fieldInfo.apiName + ', ';
            }
            query += ' Id, UserRecordAccess.HasEditAccess FROM ' + objectName + ' ORDER BY CreatedDate DESC LIMIT ' + recordCount;
            System.debug('query : ' + query);
            //SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, Database.query(query));
            //List<SObject> sObjList = securityDecision.getRecords();
            List<SObject> sObjList = Database.query(query);
            RecordWrapper recWrap = new RecordWrapper(fieldInfoList, sObjList);

            return recWrap;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class RecordWrapper {
        @AuraEnabled public List<FieldInfoWrapper> fieldInfoList;
        @AuraEnabled public List<SObject> records;

        public RecordWrapper(List<FieldInfoWrapper> fieldInfoList, List<SObject> records) {
            this.fieldInfoList = fieldInfoList;
            this.records = records;
        }
    }
}