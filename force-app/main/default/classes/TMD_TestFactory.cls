/**
 * File:        TMD_TestFactory.cls
 * Date:        December 20, 2022
 * Created By:  Ali Ozdemir
 * *************************************************************************
 * Description: Class responsible for creating test data
 * *************************************************************************
 * History:
 * Date:                Modified By:            Description:
 */
public with sharing class TMD_TestFactory {
    

    /**
     * @author Ali Ozdemir
     * @name createPersonAccountRecords
     * @date December 20, 2022
     * @description method to create test account
     * @param String
     * @return Account
     */
    public static Account createPersonAccountRecords(String emailAddress, String personAccountRecordType) {
        // create test account
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = :personAccountRecordType];
        Account acc = new Account(Lastname = 'testLastname', PersonEmail = emailAddress, RecordTypeId = rt.Id);
        insert acc;

        return acc;
    }
    
    /**
     * @author Ali Ozdemir
     * @name createOrderRecords
     * @date December 20, 2022
     * @description method to create test orders
     * @param Id
     * @param Integer
     * @return List<Order>
     */
    public static List<Order> createOrderRecords(Id accountId, Integer recordAmount) {
        // create multiple orders
        List<Order> ordersList = new List<Order>();
        for(Integer i = 0; i < recordAmount; i++) {
            ordersList.add(new Order(AccountId = accountId, EffectiveDate = Date.today(), Status = 'Draft'));
        }
        insert ordersList;

        return ordersList;
    }

    /**
     * @author Ali Ozdemir
     * @name createOrderRecord
     * @date December 20, 2022
     * @description method to create test order
     * @param Id
     * @param Integer
     * @return Order
     */
    public static Order createOrderRecord(Id accountId) {
        // create a single order
        Order ord = new Order(AccountId = accountId, EffectiveDate = Date.today(), Status = 'Draft');
        insert ord;

        return ord;
    }

    /**
     * @author Ali Ozdemir
     * @name createOrderItems
     * @date December 20, 2022
     * @description method to create order items
     * @param Id
     * @param Integer
     * @return List<Order>
     */
    private static void createOrderItems(List<Order> orders) {
        List<OrderItem> orderItemsList = new List<OrderItem>();
        // test pricebook id for being able to create pricebook entries which will be used for order item
        Id pricebookId = Test.getStandardPricebookId();
        // product creation for test
        Product2 productRecord = new Product2(ProductCode = '1234', Name = 'test product');
        insert productRecord;
        // pricebook entry creation for product above
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productRecord.Id, UnitPrice = 100);
        insert pbe;
        // order item creation per order
        for(Order ord : orders) {
            orderItemsList.add(new OrderItem(PricebookEntryId = pbe.Id, OrderId = ord.Id, Quantity = 3, UnitPrice = 100000));
        }
        insert orderItemsList;
    }
}
