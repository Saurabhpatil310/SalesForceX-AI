public with sharing class ExpenseSelector {

    public static List <Expense__c> getMyExpenses(){

        return[
            SELECT id,name, Expense_Type__c, Amount__c, Expense_Date__c, Description__c, Status__c, Visit__c,Visit__r.Name, Submitted_By__c
            FROM Expense__c
            WHERE Submitted_By__c = : UserInfo.getUserId()
            ORDER BY CreatedDate DESC
        ];

    }
    
} 