public with sharing class ExpenseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Expense__c> getMyExpenses(){
        return ExpenseService.getMyExpenses();
    }

    @AuraEnabled
    public static Expense__c createExpense(Expense__c expense){
        return ExpenseService.createExpense(expense);
}
}