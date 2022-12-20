/**
 * File:        TMD_NPSSurvey_Batch.cls
 * Date:        December 19, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for NPS Survey send as batch
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public with sharing class TMD_NPSSurvey_Batch implements Database.batchable<sObject>, Database.AllowsCallouts {
    public Set<String> orderIds;
    private static TMD_ErrorLogger logger;

    public TMD_NPSSurvey_Batch(Set<String> orderIds) {
        this.orderIds = orderIds;
        logger = new TMD_ErrorLogger();
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, OrderNumber, Account.PersonEmail, Survey_Synced__c FROM Order WHERE Id IN :orderIds AND Survey_Synced__c = false]);
    }
    
    public void execute(Database.BatchableContext BC, List<Order> records) {  
        try {
            TMD_NPSSurvey_RequestParser parser = new TMD_NPSSurvey_RequestParser();
            List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper> listOfRequestBodies = (List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper>) parser.parseRequest(records);
            // validate the size for the callout type
            TMD_NPSSurvey_CalloutHandler calloutHandler = new TMD_NPSSurvey_CalloutHandler();
            // handle callout for synch sent
            HttpResponse res = calloutHandler.doCallout('POST', listOfRequestBodies);

            // to mock flow on unit tests
            if(Test.isRunningTest()) {
                for(Order ord: records) {
                    ord.Survey_Synced__c = true;
                }
                update records;
            }
        } catch(Exception e) {
            logger.addError(e, null, null, 'TMD_NPSSurvey_Batch');
            System.debug('Error -- '+e.getMessage() + ' stack trace ' + e.getStackTraceString());
        } finally {
            logger.saveErrors();
        }
    }   

    public void finish(Database.BatchableContext BC){}
}
