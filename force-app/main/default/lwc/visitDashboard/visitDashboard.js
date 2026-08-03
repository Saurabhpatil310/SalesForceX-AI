import { LightningElement, wire } from 'lwc';

import checkIn from '@salesforce/apex/visitDashboardController.checkIn';
import checkOut from '@salesforce/apex/visitDashboardController.checkOut';
import completeVisit from '@salesforce/apex/visitDashboardController.completeVisit';

import getTodayVisits from '@salesforce/apex/VisitDashboardController.getTodayVisits';

import { ShowToastEvent }
from 'lightning/platformShowToastEvent';

import { refreshApex }
from '@salesforce/apex';



const columns = [

    {label:'Visit',fieldName:'Name'},

    {label:'Doctor',fieldName:'doctorName'},

    {label:'Status',fieldName:'Status__c'},

    {label:'Priority',fieldName:'Priority__c'},

    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Check In', name: 'checkin' },
                { label: 'Check Out', name: 'checkout' },
                { label: 'Complete Visit', name: 'complete' },
                { label: 'View', name: 'view' }
            ]
        }
    }


];

    
export default class VisitDashboard extends LightningElement {

    columns = columns;

    visits=[];

    wiredVisitsResult;

@wire(getTodayVisits)
wiredVisits(result){

    this.wiredVisitsResult = result;

    const { data, error } = result;

    if(data){

        this.visits = data.map(item => {

            return {

                ...item,

                doctorName: item.Doctor__r?.Name

            };

        });

    }

}

    handleRowAction(event){

    const action = event.detail.action.name;

    const row = event.detail.row;

    switch(action){

        case 'view':

            // Navigate

            break;

        case 'checkin':
              checkIn({visitId:row.Id})
              .then(() =>{
                this.showToast(
                    'Success',
                    'Visit Checked In',
                    'success'
                );
                return refreshApex(this.wiredVisitsResult);
              })
              .catch(error => {
                this.showToast(
                    'Error',
                    error.body.message,
                    'error'
                );
              });
            break;

        case 'checkout':

            checkOut({visitId:row.Id})
            .then(() => {
                this.showToast(
                    'Success',
                    'Visit Checked Out',
                    'success'
                );
                return refreshApex(this.wiredVisitsResult);
            })
            .catch(error => {
                this.showToast(
                    'Error',
                    error.body.message,
                    'error'
                );
            });

            break;


        case 'complete':

            completeVisit({visitId:row.Id})
            .then(() => {
                this.showToast(
                    'Success',
                    'Visit Completed',
                    'success'
                );
                return refreshApex(this.wiredVisitsResult);
            })
            .catch(error => {
                this.showToast(
                    'Error',
                    error.body.message,
                    'error'
                );
            });

            break;

    }


};
showToast(title, message, variant) {

    this.dispatchEvent(

        new ShowToastEvent({

            title: title,
            message: message,
            variant: variant

        })

    );

refreshApex(this.wiredVisitsResult);

}

}
