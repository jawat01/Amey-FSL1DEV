@isTest
public class CustomLoggerTest{
    
    static testMethod void insertInfoLog(){
        
        test.startTest();
        CustomLogger.info('TESTPROJECT', 'INFO MESSAGE');
        CustomLogger.save();
        test.stopTest();

        List<Custom_Log__c> logs = [SELECT id, Name
                                    FROM Custom_Log__c];
        System.assert(logs.size() > 0);

    }

    static testMethod void insertDebugLog(){
        
        test.startTest();
        CustomLogger.debug('TESTPROJECT', 'DEBUG MESSAGE');
        CustomLogger.save();
        test.stopTest();

        List<Custom_Log__c> logs = [SELECT id, Name
                                    FROM Custom_Log__c];
        System.assert(logs.size() > 0);

    }

    static testMethod void insertErrorLog(){
        
        test.startTest();
        CustomLogger.error('TESTPROJECT', 'ERROR MESSAGE');
        CustomLogger.save();
        test.stopTest();

        List<Custom_Log__c> logs = [SELECT id, Name
                                    FROM Custom_Log__c];
        System.assert(logs.size() > 0);

    }

    static testMethod void insertExceptionLog(){
        test.startTest();
        try{
            insert new Lead();
        }
        catch(DMLException ex){
            CustomLogger.error('TESTPROJECT', ex);
        }
        CustomLogger.save();
        test.stopTest();

        List<Custom_Log__c> logs = [SELECT id, Name
                                    FROM Custom_Log__c];
        System.assert(logs.size() > 0);

    }
}