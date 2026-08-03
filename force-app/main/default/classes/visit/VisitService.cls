/**
 * Service class for managing Visit records.
 * Handles business logic for visits including status updates, follow-ups, and statistics.
 */
public with sharing class VisitService {
    
    /**
     * Handles before insert logic for Visit records.
     *
     * @param visits list of Visit records being inserted
     */
    public static void beforeInsert(List<Visit__c> visits){
        
        try{
            
            for(Visit__c visit : visits){
                system.debug('=======Visit Trigger Start');
                if(visit.Representative__c == null){
                    visit.Representative__c = UserInfo.getUserId();
                    system.debug('representative=' +userInfo.getUserId());
                }
                
                if(String.isBlank(visit.Status__c)){
                    visit.Status__c = VisitConstants.STATUS_PLANNED;
                    system.debug('Visit Status=' + VisitConstants.STATUS_PLANNED);
                }
                
                if(visit.Visit_Date__c == null){
                    visit.Visit_Date__c = Date.today();
                    system.debug('Visit Date=' + visit.Visit_Date__c);
                }
                
                if(visit.Follow_Up__c == True){
                    visit.Next_Visit_Date__c = Date.today().addDays(7);
                    system.debug('===Follow Up Task Created======');
                }
                
            }
        }
        catch(Exception ex){
            LoggingService.logException(
                'Visit Module',
                'VisitService',
                'beforeInsert',
                ex
            );
            throw ex;
            
        }
        
    }
    
    /**
     * Handles before update logic for Visit records.
     * Ensures business rules are enforced prior to saving updates.
     *
     * @param visits list of Visit records being updated
     * @param oldMap map of existing Visit records keyed by Id
     */
    public static void beforeUpdate(
        List<Visit__c> visits,
        Map<Id,Visit__c> oldMap
    ){
        
        try{
            
            for(Visit__c visit : visits){
                
                Visit__c oldVisit = oldMap.get(visit.Id);
                
                if(
                    oldVisit.Status__c == VisitConstants.STATUS_COMPLETED &&
                    visit.Status__c == VisitConstants.STATUS_PLANNED
                ){
                    system.debug('Completed visits cannot be changed back to Planned.');
                    visit.addError(Label.Visit_Completed_Error);
                    
                }
                
            }
        }catch(Exception ex){
            LoggingService.logException(
                'Visit Module',
                'VisitService',
                'beforeInsert',
                ex
            );
            throw ex;
        }
        
    }
    
    /**
     * Creates follow-up tasks for visits marked with follow-up flag.
     *
     * @param visits list of Visit records to process for follow-up tasks
     */
    Public static void createFollowUpTasks(List<Visit__c> visits){
        
        try{
            List<Task> tasks = new List<Task>();
            
            for(Visit__c visit : visits){
                
                if(visit.Follow_Up__c){
                    
                    Task t = new Task();
                    
                    t.Subject = 'Follow up Visit';
                    
                    t.WhatId = visit.Id;
                    
                    t.OwnerId = visit.Representative__c;
                    
                    t.ActivityDate = Date.today().addDays(7);
                    
                    tasks.add(t);
                    
                }
                
            }
            
            if(!tasks.isEmpty()){
                // Validate CRUD permission before performing DML on Task (Security-ApexCRUDViolation)
                if(Schema.sObjectType.Task.isCreateable()){
                    insert tasks;
                } else {
                    // Log and skip insert to avoid security violation
                    LoggingService.logException(
                        'Visit Module',
                        'VisitService',
                        'createFollowUpTasks',
                        new System.SecurityException('Insufficient create permission for Task')
                    );
                }
            }
        }catch(Exception ex){
            LoggingService.logException(
                'Visit Module',
                'VisitService',
                'beforeInsert',
                ex
            );
            throw ex;
        }
        
        
    }
    
    /**
     * Handles after insert logic for Visit records.
     * Creates follow-up tasks based on visit configuration.
     *
     * @param visits list of Visit records inserted
     */
    public static void afterInsert(List<Visit__c> visits){
        
        try{
            createFollowUpTasks(visits);
        }
        catch(Exception ex){
            LoggingService.logException(
                'Visit Module',
                'VisitService',
                'beforeInsert',
                ex
            );
            throw ex;
            
        }
    }


    /**
     * Retrieves Visit records scheduled for today.
     *
     * Delegates to VisitSelector.getTodayVisits() to perform the query and
     * return Visit__c records where the visit date is today.
     *
     * @return list of Visit__c records for today's visits
     */
    public static List<Visit__c> getTodayVisits() {
        return VisitSelector.getTodayVisits();
    }


    /**
     * Retrieves aggregated visit statistics.
     *
     * @return map of statistic names to their integer values
     */
    public static Map<String, Integer> getVisitStatistics() {
        return VisitSelector.getVisitStatistics();
    }



    /**
     * Handles post-update logic for Visit records.
     *
     * @param visits list of updated Visit records
     * @param oldMap map of old Visit records by Id
     */
    public static void afterUpdate(
        List<Visit__c> visits,
        Map<Id,Visit__c> oldMap
    ){
        try{
            
            for(Visit__c visit : visits){
                
                Visit__c oldVisit = oldMap.get(visit.Id);
                
                if(
                    oldVisit.Status__c != VisitConstants.STATUS_COMPLETED &&
                    visit.Status__c == VisitConstants.STATUS_COMPLETED
                ){
                    
                    System.debug(
                        'Visit Completed : Ready for AI Processing'
                    );
                    
                }
                
            }
        }
        catch(Exception ex){
            LoggingService.logException(
                'Visit Module',
                'VisitService',
                'beforeInsert',
                ex
            );
            throw ex;
        }
        
    }
}