@isTest
public class DisplayRecentlyViewedRecordsHandlerTest {

    @testSetup
    public static void createData(){
        //Create User
        User user = TestDataFactory.createUser('Sales User');

        //create Accounts
        TestDataFactory.createAccount(user, 10, true);

        //Create Leads
        TestDataFactory.createLead(user, 10, true);
    }

    @isTest()    
    public static void recentRecordTestMethod(){

        Test.startTest();
        DisplayRecentlyViewedRecordsHandler.getObjectList();

        DisplayRecentlyViewedRecordsHandler.getRecords('Account', 5);

        DisplayRecentlyViewedRecordsHandler.getRecords('Account', 10);
        Test.startTest();
    }
}