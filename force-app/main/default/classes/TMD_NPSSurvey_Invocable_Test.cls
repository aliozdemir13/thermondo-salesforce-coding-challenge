/**
 * File:        TMD_NPSSurvey_Invocable_Test.cls
 * Date:        December 20, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for NPS Survey Invocable test
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
@isTest
private with sharing class TMD_NPSSurvey_Invocable_Test {

    @TestSetup
    static void makeData(){
        // create accounts for positive and negative scenarios
        Account acc = TMD_TestFactory.createPersonAccountRecords('test@test.com', 'PersonAccount');
        TMD_TestFactory.createPersonAccountRecords(null, 'PersonAccount');
        // create orders for bulk with account that has email
        TMD_TestFactory.createOrderRecords(acc.Id, 20);
    }
    

    @isTest 
    static void positiveScenario_oneOrderUpdate() {
        Test.startTest();
        // mock the callout
        Test.setMock(HttpCalloutMock.class, new TMD_NPSSurvey_Mock());
        // mock flow to prepare input fields
        List<TMD_NPSSurvey_Invocable.Request> requestsList = new List<TMD_NPSSurvey_Invocable.Request>();
        TMD_NPSSurvey_Invocable.Request req = new TMD_NPSSurvey_Invocable.Request();
        Order ord = [SELECT Id, Survey_Synced__c FROM Order LIMIT 1];
        req.orderId = ord.Id;
        requestsList.add(req);
        // calling invocable class for successful single order update
        List<TMD_NPSSurvey_Invocable.Result> res = TMD_NPSSurvey_Invocable.execute(requestsList);

        // check if error logged
        System.debug('44' + [SELECT Id, Error_Message__c, Class_Name__c FROM TMD_Error_Log__c]);
        System.debug('45' + [SELECT Id FROM TMD_Error_Log__c].isEmpty());
        System.debug('46' + res[0].isSuccess);
        System.assert([SELECT Id FROM TMD_Error_Log__c].isEmpty());
        // check if code executed successfully
        System.assert(res[0].isSuccess);
        Test.stopTest();
    }

    @isTest 
    static void positiveScenario_allOrdersUpdate() {
        Test.startTest();
        // mock the callout
        Test.setMock(HttpCalloutMock.class, new TMD_NPSSurvey_Mock());
        // mock flow to prepare input fields
        List<TMD_NPSSurvey_Invocable.Request> requestsList = new List<TMD_NPSSurvey_Invocable.Request>();
        for(Order ord : [SELECT Id FROM Order WHERE Account.PersonEmail != null]) {
            TMD_NPSSurvey_Invocable.Request req = new TMD_NPSSurvey_Invocable.Request();
            req.orderId = ord.Id;
            requestsList.add(req);
        }
        // calling invocable class for successful single order update
        List<TMD_NPSSurvey_Invocable.Result> res = TMD_NPSSurvey_Invocable.execute(requestsList);

        // check if error logged
        System.debug('66' + [SELECT Id, Error_Message__c, Class_Name__c FROM TMD_Error_Log__c]);
        System.debug('67' + [SELECT Id FROM Order WHERE Survey_Synced__c = false].size());
        System.assert([SELECT Id FROM TMD_Error_Log__c].isEmpty());
        // check for unprocessed orders
        System.assert([SELECT Id FROM Order WHERE Survey_Synced__c = false].size() > 0);
        Test.stopTest();
    }

    @isTest 
    static void negativeScenario_oneOrderUpdate() {
        // mock the callout
        Test.setMock(HttpCalloutMock.class, new TMD_NPSSurvey_Mock());
        // mock flow to prepare input fields
        List<TMD_NPSSurvey_Invocable.Request> requestsList = new List<TMD_NPSSurvey_Invocable.Request>();
        TMD_NPSSurvey_Invocable.Request req = new TMD_NPSSurvey_Invocable.Request();
        Order ord = TMD_TestFactory.createOrderRecord([SELECT Id FROM Account WHERE PersonEmail = null].Id);
        req.orderId = ord.Id;
        requestsList.add(req);
        // calling invocable class for successful single order update
        List<TMD_NPSSurvey_Invocable.Result> res = TMD_NPSSurvey_Invocable.execute(requestsList);

        // check if error logged
        System.assert(![SELECT Id FROM TMD_Error_Log__c].isEmpty());
    }

    @isTest 
    static void negativeScenario_allOrdersUpdate() {
        Test.startTest();
        // mock the callout
        Test.setMock(HttpCalloutMock.class, new TMD_NPSSurvey_Mock());
        // mock flow to prepare input fields
        List<Order> ordersList = TMD_TestFactory.createOrderRecords([SELECT Id FROM Account WHERE PersonEmail = null].Id, 20);
        List<TMD_NPSSurvey_Invocable.Request> requestsList = new List<TMD_NPSSurvey_Invocable.Request>();
        for(Order ord : ordersList) {
            TMD_NPSSurvey_Invocable.Request req = new TMD_NPSSurvey_Invocable.Request();
            req.orderId = ord.Id;
            requestsList.add(req);
        }
        // calling invocable class for successful single order update
        List<TMD_NPSSurvey_Invocable.Result> res = TMD_NPSSurvey_Invocable.execute(requestsList);

        // check if error logged
        System.assert(![SELECT Id FROM TMD_Error_Log__c].isEmpty());
        Test.stopTest();
    }
}