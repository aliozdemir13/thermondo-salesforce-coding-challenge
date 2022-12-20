/**
 * File:        TMD_IRequestParser
 * Date:        December 19, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Interface for request generation
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public interface TMD_IRequestParser {

    /**
     * @author Ali Ozdemir
     * @name parseRequest
     * @date December 19, 2022
     * @description method definition to generate request body for given sobjects
     * @param List<SObject> 
     * @return Object
     */
    Object parseRequest(List<SObject> listOfRecords);
}
