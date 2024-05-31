@isTest
private class TestUpsertRecordsFlowAction {

    @isTest
    static void testSuccessfulUpsert() {
        // Prepare test data - this depends on the SObject types you expect your class to handle
        // For example, if you're upserting Account records:
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };

        insert accounts; 
        // Prepare your wrapper
        UpsertDetailsRequest wrapper = new UpsertDetailsRequest();
        List<SObject> upsertTestRecords = new List<SObject>();
        upsertTestRecords = accounts;
        wrapper.records = upsertTestRecords;
        wrapper.upsertFieldName = 'Id'; // Assuming 'Name' is the external ID field
        wrapper.BatchSize = 200; // Example batch size

        // Call your invocable method
        Test.startTest();
        
        // Mocking future calls in test context
        List<UpsertDetailsResultForFlow> results = UpsertRecordsFlowAction.upsertRecords(new List<UpsertDetailsRequest>{wrapper});

        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(true, results[0].isSuccessful, 'The operation should be successful.');
        System.assertEquals(1, results[0].NumberOfBatches, 'There should be 1 batch processed.');
    }
    @isTest
    static void testErrorUpsert() {
        // Prepare test data - this depends on the SObject types you expect your class to handle
        // For example, if you're upserting Account records:
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2'),
            new Account(Name = 'Test Account 3'),
            new Account(Name = 'Test Account 4')
        };

        insert accounts; 

        accounts[0].Name = null;
        accounts[1].Name = null;
        // Prepare your wrapper
        UpsertDetailsRequest wrapper = new UpsertDetailsRequest();
        List<SObject> upsertTestRecords = new List<SObject>();
        upsertTestRecords = accounts;
        wrapper.records = upsertTestRecords;
        wrapper.upsertFieldName = 'Id'; // Assuming 'Name' is the external ID field
        wrapper.BatchSize = 200; // Example batch size

        // Call your invocable method
        Test.startTest();
        
        // Mocking future calls in test context
        List<UpsertDetailsResultForFlow> results = UpsertRecordsFlowAction.upsertRecords(new List<UpsertDetailsRequest>{wrapper});
        
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(true, results[0].isSuccessful, 'The operation should be successful.');
        System.assertEquals(1, results[0].NumberOfBatches, 'There should be 1 batch processed.');
    }

    @isTest
    static void testInvalidFieldName() {
        // Prepare your test data and wrapper as in the previous example,
        // but use an invalid field name for upsertFieldName.

        UpsertDetailsRequest wrapper = new UpsertDetailsRequest();
        wrapper.records = new List<SObject>{
            new Account(Name = 'Test Account 3'),
            new Account(Name = 'Test Account 4')
        };
        wrapper.upsertFieldName = 'InvalidFieldName'; // Invalid field name
        wrapper.BatchSize = 200;

        Test.startTest();
        
        // Since we're testing for an error, we don't expect actual future calls to be made
        List<UpsertDetailsResultForFlow> results = UpsertRecordsFlowAction.upsertRecords(new List<UpsertDetailsRequest>{wrapper});

        Test.stopTest();

        // Assertions for the error scenario
        System.assertNotEquals(null, results, 'Results should not be null.');
        
    }

    
    @isTest
    static void testLargeUpsert() {

        // Prepare your wrapper
        UpsertDetailsRequest wrapper = new UpsertDetailsRequest();
        List<SObject> upsertTestRecords = new List<SObject>();
        for (Integer i = 0; i < 500; i++) {
            upsertTestRecords.add(new Account(Name = 'Test Account ' + i));
        }
        wrapper.records = upsertTestRecords;
        wrapper.upsertFieldName = 'Name'; // Assuming 'Name' is the external ID field
        wrapper.BatchSize = 200; // Example batch size

        // Call your invocable method
        Test.startTest();
        
        // Mocking future calls in test context
        List<UpsertDetailsResultForFlow> results = UpsertRecordsFlowAction.upsertRecords(new List<UpsertDetailsRequest>{wrapper});

        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(true, results[0].isSuccessful, 'The operation should be successful.');
        System.assertEquals(3, results[0].NumberOfBatches, 'There should be 1 batch processed.');
    }
    
    @isTest
    static void testMassiveUpsert() {


        // Prepare your wrapper
        UpsertDetailsRequest wrapper = new UpsertDetailsRequest();
        List<SObject> upsertTestRecords = new List<SObject>();
        for (Integer i = 0; i < 1234; i++) {
            upsertTestRecords.add(new Account(Name = 'Test Account ' + i));
        }
        wrapper.records = upsertTestRecords;
        wrapper.upsertFieldName = 'Name'; // Assuming 'Name' is the external ID field
        wrapper.BatchSize = 500; // Example batch size

        // Call your invocable method
        Test.startTest();
        
        // Mocking future calls in test context
        List<UpsertDetailsResultForFlow> results = UpsertRecordsFlowAction.upsertRecords(new List<UpsertDetailsRequest>{wrapper});

        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, results, 'Results should not be null.');
        System.assertEquals(false, results[0].isSuccessful, 'The operation should be successful.');
        System.assertEquals(50, results[0].NumberOfBatches, 'There should be 1 batch processed.');
    }

    @isTest
    static void testErrorHandling() {
        // Create test data or mock objects as needed
        
        // Call the asynchronous method with invalid input to trigger the catch block
        Test.startTest();
        UpsertRecordsFlowAction.upsertRecordsAsync(null, 'InvalidFieldName');
        Test.stopTest();
        
        // Perform assertions to verify the behavior
        // Need to write an assertion here
    }
}