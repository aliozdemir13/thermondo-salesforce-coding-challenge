/**
 * File:        TMD_NPSSurvey_Mock.cls
 * Date:        December 20, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Mock class for unit testing of NPS Survey
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
@isTest
global with sharing class TMD_NPSSurvey_Mock implements HttpCalloutMock {


    global HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper> listOfRequestBodies = (List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper>) JSON.deserialize(req.getBody(), List<TMD_NPSSurvey_RequestParser.NPSSurvey_Request_Wrapper>.class);

        if(listOfRequestBodies[0].customerEmail != null) {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success" : true}');
            response.setStatusCode(200);
         } else {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success" : false}');
            response.setStatusCode(400);
        }
        
        return response; 
    }
}
