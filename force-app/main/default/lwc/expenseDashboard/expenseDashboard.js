import { LightningElement,wire } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { refreshApex} from '@salesforce/apex';
    
import getMyExpenses from '@salesforce/apex/ExpenseController.getMyExpenses';

import createExpense from '@salesforce/apex/ExpenseController.createExpense';

import getMyVisitsForExpense from '@salesforce/apex/ExpenseController.getMyVisitsForExpense';



export default class ExpenseDashboard extends LightningElement {

    expenses =[];
    wiredExpensesResult;
    isNewExpenseModalOpen = false;
    expenseType = '';
    amount;
    expenseDate;
    visitId = '';
    description = '';
    visits = [];
    visitId = '';
    createdExpenseId;

    acceptedFormats = [
    '.pdf',
    '.png',
    '.jpg',
    '.jpeg'
];

    columns =[
        {label: 'Expense Number', fieldName : 'Name'},
        {label: 'Expense Type', fieldName : 'Expense_Type__c'},
        {label: 'Amount', fieldName : 'Amount__c'},
        {label: 'Expense Date', fieldName : 'Expense_Date__c'},
        {label: 'Status', fieldName : 'Status__c'}
    ];

    @wire(getMyExpenses)
    wiredExpenses(result){
        this.wiredExpensesResult = result;
        const{ data, error} = result;
        if (data){
            this.expenses = data;
        } else if (error){
            console.error('Error loading expenses', error);
            this.showToast('Error','Unable to load expenses.','error');
        }

    }

    handleNewExpense(){
        this.isNewExpenseModalOpen = true;
    }

    handleCloseModal(){
        this.isNewExpenseModalOpen = false;
        this.resetForm();
    }

    resetForm() {

    this.expenseType = '';

    this.amount = null;

    this.expenseDate = null;

    this.visitId = '';

    this.description = '';

    this.createdExpenseId = null;

}


    handleSuccess(){
        this.showToast(
            'Sucess',
            'Expense saved successfully.',
            'success'
        );
        this.isNewExpenseModalOpen = false;

        refreshApex(
            this.wiredExpensesResult
        );
    }

    showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
            title,
            message,
            variant
        })
    );
    }

handleInputChange(event){
    const field = event.target.name;
    this[field] = event.target.value;
}

handleSaveExpense(){
    const expense = {
        Expense_Type__c:
            this.expenseType,

        Amount__c:
            this.amount,

        Expense_Date__c:
            this.expenseDate,

        Visit__c:
            this.visitId || null,

        Description__c:
            this.description
    };
    createExpense({expense})
        .then((result)=>{
            this.createdExpenseId = result.Id;

            this.showToast(
                'Success',
                'Expense saved as Draft.',
                'success'
            );
        
            return refreshApex(
                this.wiredExpensesResult
            );
        })

        .catch(error => {
            console.error(error);

            this.showToast(
                'Error',
                error.body?.message || 'Unable to save expense.',
                'error'
            );
        });

}


get expenseTypeOptions() {

    return [

        {
            label: 'Travel',
            value: 'Travel'
        },

        {
            label: 'Food',
            value: 'Food'
        },

        {
            label: 'Accommodation',
            value: 'Accommodation'
        },

        {
            label: 'Entertainment',
            value: 'Entertainment'
        },

        {
            label: 'Other',
            value: 'Other'
        }

    ];

}

    @wire(getMyVisitsForExpense)
    wiredVisits({data, error}){
        if (data){
            this.visits = data.map(visit =>{
                return{
                    label: `${visit.Name} - ${visit.Doctor__r?.Name || 'No Doctor'} - ${visit.Visit_Date__c}`,
                    value: visit.Id
                };
            });

        } else if (error){
            console.error('Error loading visits', error);
        }
    }


handleUploadFinished(event) {

    const uploadedFiles =
        event.detail.files;

    this.showToast(
        'Success',
        `${uploadedFiles.length} receipt uploaded successfully.`,
        'success'
    );

}




}