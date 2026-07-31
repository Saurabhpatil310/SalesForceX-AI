public with sharing class LoggingService {
    public static void logException(
        String module,
        String className,
        String methodName,
        Exception ex
    )
    {
        try{
            Application_Log__c log = new Application_Log__c();
            log.Module__c = module;
            log.Class_Name__c  = className;
            log.Method_Name__c = methodName;
            log.Error_Message__c = ex.getMessage();
            log.Stack_Trace__c = ex.getStackTraceString();
            log.User__c = UserInfo.getUserId();
            log.Logged_On__c = System.now();
            log.Severity__c = 'ERROR';
            log.Status__c = 'Open';
            
            insert log;
        	
        }catch(exception e){
            System.debug('Logging Failed:'+ e.getMessage());
        }
    }

}