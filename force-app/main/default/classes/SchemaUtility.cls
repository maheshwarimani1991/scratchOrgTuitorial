/*
* @Name         SchemaUtility 
* @Author       Himanshu
* @Date         5-July-2021
* @Description  Utility class to get list of accessible object, list of fields
*/
public with sharing class SchemaUtility {
    private static List<ObjectInfoWrapper> objectList;
    private static Map<String, List<FieldInfoWrapper>> objectFieldSetMap = new Map<String, List<FieldInfoWrapper>>();
    
    //Get all the list of object to which user has access
    public static List<ObjectInfoWrapper> getObjectList(){
        if(objectList == null || objectList.isEmpty()){
            objectList = new List<ObjectInfoWrapper>();

            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().values()){
                Schema.DescribeSObjectResult objResult = objTyp.getDescribe();

                if(objResult.accessible && !objResult.isCustomSetting() && objResult.getRecordTypeInfos().size() > 0){
                    objectList.add(new ObjectInfoWrapper(objResult.getLabel(), objResult.getName()));
                }
            }
        }

        return objectList;
    }

    public static List<FieldInfoWrapper> getFields(String objectName) {
        List<FieldInfoWrapper> fieldInfoList;
        if(objectFieldSetMap.containsKey(objectName)){
            fieldInfoList = objectFieldSetMap.get(objectName);
            
            if(!fieldInfoList.isEmpty()){
                return fieldInfoList;
            }
        }

        fieldInfoList = new List<FieldInfoWrapper>();
        Map<String, Schema.FieldSet> fieldSetMap = Schema.getGlobalDescribe().get(objectName).getDescribe().FieldSets.getMap();
        Map<String, SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        if(fieldSetMap.containsKey(objectName + '_FTD')){
            for(Schema.FieldSetMember fsm : fieldSetMap.get(objectName + '_FTD').getFields()) {
                if(isFieldAccessible(fields, fsm.getFieldPath())){
                    fieldInfoList.add(new fieldInfoWrapper(fsm.getLabel(), fsm.getFieldPath(), getFieldType(String.valueOf(fsm.getType()))));
                }
            }
        }else{
            fieldInfoList.add(new fieldInfoWrapper('Name', 'Name', 'text'));
            fieldInfoList.add(new fieldInfoWrapper('Created Date', 'CreatedDate', 'date'));
            fieldInfoList.add(new fieldInfoWrapper('Craeted By', 'CreatedBy.Name', 'text'));
        }
        
        objectFieldSetMap.put(objectName, fieldInfoList);
        return fieldInfoList;
    }

    public static String getFieldType(String fieldType){
        if(fieldType == 'Boolean'){
            return 'boolean';
        }else if(fieldType == 'Currency'){
            return 'currency';
        }else if(fieldType == 'DATETIME' || fieldType == 'Date'){
            return 'date';
        }else if(fieldType == 'Email'){
            return 'email';
        }else if(fieldType == 'Integer' || fieldType == 'Double' || fieldType == 'Long'){
            return 'number';
        }else if(fieldType == 'Percent'){
            return 'percent';
        }else if(fieldType == 'Phone'){
            return 'phone';
        }else if(fieldType == 'URL'){
            return 'url';
        }else {
            return 'text';
        }
    }

    public static Boolean isFieldAccessible(Map<String, SObjectField> fields, String fieldName){
        if(fieldName.contains('.')){
            String parentSobjectName = String.valueOf(fields.get(getFieldPath(fieldName.substringBefore('.'))).getDescribe().getReferenceTo()[0]);
            return isFieldAccessible(Schema.getGlobalDescribe().get(parentSobjectName).getDescribe().fields.getMap(), fieldName.substringAfter('.'));
        }else{
            return fields.get(fieldName).getDescribe().isAccessible();
        }  
    }

    public static String getFieldPath(String fieldName){
        if (fieldName != null) {
            return fieldName.endsWith('__r') ? fieldName.replace('__r', '__c') : fieldName + 'Id';
        }
    
        return null;
    }
}