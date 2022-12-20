/**
 * File:        TMD_ICalloutHandler
 * Date:        December 19, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Interface for request generation
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public interface TMD_ICalloutHandler {
    
    /**
     * @author Ali Ozdemir
     * @name doCallout
     * @date December 19, 2022
     * @description method definition to perform callouts
     * @param String
     * @param Object
     * @return HttpResponse
     */
    HttpResponse doCallout(String methodType, Object requestBody);
}
