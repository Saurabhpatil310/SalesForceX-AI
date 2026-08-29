public with sharing class ExpenseService {

    public static List<Expense__c> getMyExpenses(){

        return ExpenseSelector.getMyExpenses();
    }

    public static Expense__c createExpense(Expense__c expense){
        expense.Submitted_By__c = UserInfo.getUserId();

        expense.Status__c = 'Draft';

        insert expense;

        return expense;
    }

    public static List<Visit__c> getMyVisitsForExpense(){
        return ExpenseSelector.getMyVisitsForExpense();
    }

}