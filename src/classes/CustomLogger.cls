/**
    * @Name:        CustomLogger 
    * @Description: Class to be used to persist custom logs (via the Custom_Log__c object) in Salesforce
    *                   Example of a info implementation :
    *                   CustomLogger.info(CustomLogger.PROJECT_AMEY_UU, 'Transaction was successfull');
    *
    *                   Example of logging an error :
    *                   try {
    *                       // do something
    *                   }
    *                   catch (System.exception ex) {
    *                           CustomLogger.error(CustomLogger.PROJECT_AMEY_UU, exception);
    *                   }
    *					
    *					When all events have been logged, alweays call save prior to execution enb.  Logs
    *					will only exist for the extent of the session in whic they are initiated
	*					
	*					CustomLogger.save();
    *
    * @author:      Jared Watson
    * @version:     1.0
    * Change Log 
    *
    * Date          author          Change Description
    * -----------------------------------------------------------------------------------
    * 19/07/2017    Jared Watson    Created Class
*/
public with sharing class CustomLogger {

    public static List<Custom_Log__c> customLogCache = new list<Custom_Log__c>();

    // Project Names 
    // - Please add additional project names here and then use the new constant
    // - NO STRINGS IN THE ACTUAL METHODS!
    // - this is so if you wish to change the actual Project label,
    //   you can do so in one place.
    public static final String PROJECT_AMEY_UU = 'Amey UU Water Meter Replacement';
    
    // Log types
    // - If you want to add more log types (such as Info etc...)
    //   please do so here and then reference the new constant in the methods
    // - NO STRINGS IN THE ACTUAL METHODS!
    // - Best practice is to also add the new value to the picklist on 
    //   the Custom Log object Custom_Log__c.Type__c
    private static final String LOG_TYPE_INFO   = 'Info';
    private static final String LOG_TYPE_DEBUG = 'Debug';
    private static final String LOG_TYPE_ERROR  = 'Error';
    
    
    public static void info(String projectName, String message) {
        log(projectName, LOG_TYPE_INFO, message);
    }
    
    public static void debug(String projectName, String message) {
        log(projectName, LOG_TYPE_DEBUG, message);
    }
    
    public static void error(String projectName, String message) { 
        log(projectName, LOG_TYPE_ERROR, message);
    }
    
    public static void error(String projectName, System.Exception ex) {
        log(projectName, LOG_TYPE_ERROR, ex.getMessage() + '; ' + ex.getTypeName() + '; ' + ex.getStackTraceString());
    }
    
    // Persists logs for current transaction
    public static void save() {
        if (customLogCache != null && customLogCache.size() > 0) {
            try {
                upsert customLogCache;
            }
            catch(System.exception ex) {
                // to be decided
            }
        }
    }
    
    // Create and populate a new Custom_Log__c object
    // and add it to the static list that will
    // be inserted at the end of a transaction
    private static void log(String projectName, String logType, String message) {
        Custom_Log__c log = new Custom_Log__c();
        
        // Do logging that is generic enough
        // to be applicable to all projects
        log.Project__c             = projectName;
        log.Time_Stamp__c          = getTimeStamp();
        log.Type__c                = logType;
        log.Message__c             = message;
        
        // Do logging that is specific to a particular project
        specificLogging(projectName, log);
        
        // Add to static list so that we do not have numerous DML statements 
        // throughout a transaction
        customLogCache.add(log);
        system.debug(message);
    }
    
    // Add an else statement to do do logging
    // specific to your project
    private static void specificLogging(String projectName, Custom_Log__c log) {
        if (projectName == PROJECT_AMEY_UU) {
            //add project specific data items here...
        }
    }
    
    // As logs are not immediately inserted 
    // (they are added to a list to be inserted at the end of a transaction)
    // so the CreatedDate field on Custom_Log__c is not useful to us.
    // We will generate a timestamp and populate the Time_Stamp__c field
    // so we can keep track of when individual logs were logged.
    private static String getTimeStamp() {
        return 'TS ' + String.valueOfGMT( System.now() );
    }
}