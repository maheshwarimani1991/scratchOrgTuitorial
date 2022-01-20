public class FieldInfoWrapper {
    @AuraEnabled public String label;
    @AuraEnabled public String apiName;
    @AuraEnabled public String type;

    public FieldInfoWrapper(String label, String apiName, String type) {
        this.label = label;
        this.apiName = apiName;
        this.type = type;
    }
}