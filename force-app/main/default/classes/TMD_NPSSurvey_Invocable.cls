/**
 * File:        TMD_NPSSurvey_Invocable.cls
 * Date:        December 19, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for NPS Survey send from flow
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public with sharing class TMD_NPSSurvey_Invocable {
    private static TMD_ErrorLogger logger;
 
    /**
     * @author Ali Ozdemir
     * @name execute
     * @date December 19, 2022
     * @description method to handle callout to survey send
     * @param Request
     * @return Result
     */
    @InvocableMethod
    public static List<Result> execute(List<Request> reqList) {
        //Create a Results object to hold the return values
        Result response = new Result();
        List<Result> resultsList = new List<Result>();
        logger = new TMD_ErrorLogger();
        try {
            Set<String> orderIds = new Set<String>();
            for(Request req : reqList) {
                orderIds.add(req.orderId);
                // prepare the response for flow
                response.isSuccess = true;
                response.message = req.orderId; 
                resultsList.add(response);
            }

            if(!orderIds.isEmpty()) {
                if(orderIds.size() <= 30) {
                    List<Order> ordersToSendSurvey = [SELECT Id, OrderNumber, Account.PersonEmail, Survey_Synced__c FROM Order WHERE Id IN :orderIds AND Survey_Synced__c = false AND Account.PersonEmail != null];
                    // parse the request for the NPS system
                    TMD_NPSSurvey_RequestParser parser = new TMD_NPSSurvey_RequestParser();
                    List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper> listOfRequestBodies = (List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper>) parser.parseRequest(ordersToSendSurvey);
                    // validate the size for the callout type
                    TMD_NPSSurvey_CalloutHandler calloutHandler = new TMD_NPSSurvey_CalloutHandler();
                    // handle callout for synch sent
                    HttpResponse res = calloutHandler.doCallout('POST', listOfRequestBodies);
                } else {
                    // batch class for larger datasets
                    Database.executeBatch(new TMD_NPSSurvey_Batch(orderIds), 30);
                }
            } else {
                // error logger for missing information case
                logger.addError('No Order Id Specified.', 'TMD_NPSSurvey_Invocable');
                logger.saveErrors();
            }

        } catch(Exception e) {
            // prepare the error log
            logger.addError(e, null, null, 'TMD_NPSSurvey_Invocable');
            System.debug('Error -- '+e.getMessage() + ' stack trace ' + e.getStackTraceString());
        } finally {
            // save the error logs
            logger.saveErrors();
        }
        return resultsList;    
    }

    public class Request {
        @InvocableVariable(label='OrderId' description='OrderId to use for survey send' required=true)
        public String orderId;
    }

    public class Result {
        @InvocableVariable(label='Message' description='Return message' required=true)
        public String message;
        @InvocableVariable(label='isSuccess' description='Success flag' required=true)
        public Boolean isSuccess;
    }
}
