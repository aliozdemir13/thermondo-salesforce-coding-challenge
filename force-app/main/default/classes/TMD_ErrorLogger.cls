/**
 * File:        TMD_ErrorLogger.cls
 * Date:        December 20, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for error logging
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public with sharing class TMD_ErrorLogger {
    private List<TMD_Error_Log__c> errorLogList;
    
    public TMD_ErrorLogger() {
        errorLogList = new List<TMD_Error_Log__c>();
    }

    /**
     * @author Ali Ozdemir
     * @name addError
     * @date December 20, 2022
     * @description method to add error to list
     * @param Exception
     * @param HttpRequest
     * @param HttpResponse
     * @param String
     */
    public void addError(Exception e, HttpRequest req, HttpResponse res, String className) {
        TMD_Error_Log__c error = new TMD_Error_Log__c(
            Error_Message__c = e.getMessage(),
            Stack_Trace__c = e.getStackTraceString(),
            User__c = UserInfo.getUserId(),
            Class_Name__c = className
        );
        if(req != null) {
            error.Payload__c = req.getBody();
        }
        if(res != null) {
            error.Status_Code__c = String.valueOf(res.getStatusCode());
        }
        errorLogList.add(error);
    }

    /**
     * @author Ali Ozdemir
     * @name addError
     * @date December 20, 2022
     * @description method to add error to list
     * @param Exception
     * @param HttpRequest
     * @param HttpResponse
     * @param String
     */
    public void addError(String message, String className) {
        TMD_Error_Log__c error = new TMD_Error_Log__c(
            Error_Message__c = message,
            User__c = UserInfo.getUserId(),
            Class_Name__c = className
        );
        errorLogList.add(error);
    }

    /**
     * @author Ali Ozdemir
     * @name saveErrors
     * @date December 20, 2022
     * @description method to save errors
     */
    public void saveErrors() {
        insert errorLogList;
    }
}
