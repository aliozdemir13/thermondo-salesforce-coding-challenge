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
public class TMD_NPSSurvey_RequestParser implements TMD_IRequestParser {
    
    /**
     * @author Ali Ozdemir
     * @name parseRequest
     * @date December 19, 2022
     * @description method to generate request body for given orders
     * @param List<SObject> 
     * @return Object
     */
    public Object parseRequest(List<SObject> listOfRecords) {
        // list of request bodies to be use for survey send
        List<NPSSurvey_Request_Wrapper> parsedRequestList = new List<NPSSurvey_Request_Wrapper>();

        for(SObject ord : listOfRecords) {
            // fill the list by generating the request bodies from given order
            parsedRequestList.add(new NPSSurvey_Request_Wrapper((Order) ord));
        }

        return parsedRequestList;
    }

    /**
     * @author Ali Ozdemir
     * @name NPSSurvey_Request_Wrapper
     * @date December 19, 2022
     * @description wrapper class for NPS Survey send for orders
     */
    public class NPSSurvey_Request_Wrapper {
        public String sfId;
        public String orderNumber;
        public String customerEmail;

        private NPSSurvey_Request_Wrapper(Order ord) {
            this.sfId = ord.Id;
            this.orderNumber = ord.OrderNumber;
            this.customerEmail = ord.Account.PersonEmail;
        }
    }
}
