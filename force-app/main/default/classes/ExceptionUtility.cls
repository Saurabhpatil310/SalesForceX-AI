public with sharing class ExceptionUtility {
    public static void throwBusinessException(String message){
        
        throw new AuraHandledException(message);
        
    }

}