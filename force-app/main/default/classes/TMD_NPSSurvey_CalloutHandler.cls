
/**
 * File:        TMD_NPSSurvey_CalloutHandler.cls
 * Date:        December 19, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for NPS Survey callouts
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public with sharing class TMD_NPSSurvey_CalloutHandler implements TMD_ICalloutHandler {
    private static TMD_ErrorLogger logger;

    /**
     * @author Ali Ozdemir
     * @name doCallout
     * @date December 19, 2022
     * @description method to perform callouts
     * @param SObject
     * @param String
     * @param Object
     * @return Boolean
     */
    public HttpResponse doCallout(String methodType, Object requestBody) {
        HttpResponse res = new HttpResponse();
        HttpRequest req = new HttpRequest();
        logger = new TMD_ErrorLogger();
        try {
            // Instantiate a new Http object
            Http h = new Http();

            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            req.setEndpoint('callout:TMD_NPS_System/orders');
            req.setMethod(methodType);
            req.setBody(JSON.serialize(requestBody));

            // Send the request, and return a response
            res = h.send(req);
            // log if callout failed
            if(res.getStatusCode() != 200) {
                logger.addError(res.getBody(), 'TMD_NPSSurvey_CalloutHandler');
                logger.saveErrors();
            }
        } catch (Exception e) {
            logger.addError(e, req, res, 'TMD_NPSSurvey_CalloutHandler');
        } finally {
            logger.saveErrors();
        }
        return res;
    }
    
}
