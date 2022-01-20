public class TestDataFactory {
    
    public static User createUser(String profileName){
        User u = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name= :profileName];
        u.Alias = 'standt';
        u.Email='standarduser@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='standarduser+1@testorg.com';
        return u;
    }
    
    public static List<Account> createAccount(User owner, Integer noOfRecords, Boolean doInsert){
        List<Account> accList = new List<Account>();
        
        for(Integer i=0; i<noOfRecords; i++) {
            Account acc = new Account(Name='TestAccount' + i);
            accList.add(acc);
        }
        if(doInsert){
            insert accList;
        }
        return accList;
    }
    
    public static List<Lead> createLead(User owner, Integer noOfRecords, Boolean doInsert){
        List<Lead> leadList = new List<Lead>();
        
        for(Integer i=0; i<noOfRecords; i++) {
            Lead ld = new Lead(LastName='Name' + i, Company = 'Test Company' + i);
            leadList.add(ld);
        }
        if(doInsert){
            insert leadList;
        }
        return leadList;
    }
}