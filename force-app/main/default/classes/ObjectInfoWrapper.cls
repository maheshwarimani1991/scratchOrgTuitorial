public class ObjectInfoWrapper {
    @AuraEnabled public String label;
    @AuraEnabled public String value;

    public ObjectInfoWrapper(String label, String value) {
        this.label = label;
        this.value = value;
    }
}