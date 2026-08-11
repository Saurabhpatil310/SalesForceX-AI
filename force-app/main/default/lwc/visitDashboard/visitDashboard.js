import { LightningElement, wire } from 'lwc';

import checkIn from '@salesforce/apex/visitDashboardController.checkIn';
import checkOut from '@salesforce/apex/visitDashboardController.checkOut';
import completeVisit from '@salesforce/apex/visitDashboardController.completeVisit';

import getTodayVisits from '@salesforce/apex/VisitDashboardController.getTodayVisits';

import { ShowToastEvent }
from 'lightning/platformShowToastEvent';

import { refreshApex }
from '@salesforce/apex';

import { NavigationMixin }
from 'lightning/navigation';




const columns = [

    {label:'Visit',fieldName:'Name'},

    {label:'Doctor',fieldName:'doctorName'},

    {label:'Status',fieldName:'Status__c'},

    {label:'Priority',fieldName:'Priority__c'},

    {label:'Assigned To',fieldName:'representativeName'},

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

    
export default class VisitDashboard extends NavigationMixin(LightningElement) {

    columns = columns;

    visits=[];

    filteredVisits = [];

    searchKey = '';

    selectedStatus = 'All';

    wiredVisitsResult;

    page = 1;

    pageSize = 10;

    totalPages = 0;


@wire(getTodayVisits)
wiredVisits(result){

    this.wiredVisitsResult = result;

    const { data, error } = result;

    if(data){

        this.visits = data.map(item => {

            return {

                ...item,

            doctorName:item.Doctor__r?.Name,

            representativeName:item.Representative__r?.Name


            };

        });
        this.filteredVisits = [...this.visits];

    }

}

    handleRowAction(event){

    const action = event.detail.action.name;

    const row = event.detail.row;

    switch(action){

        case 'view':

            this[NavigationMixin.Navigate]({

            type:'standard__recordPage',

            attributes:{

            recordId:row.Id,

            objectApiName:'Visit__c',

            actionName:'view'
            }
        });
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

get statusOptions() {

    return [

        { label: 'All', value: 'All' },

        { label: 'Planned', value: 'Planned' },

        { label: 'In Progress', value: 'In Progress' },

        { label: 'Completed', value: 'Completed' },

        { label: 'Missed', value: 'Missed' },

        { label: 'Cancelled', value: 'Cancelled' }

    ];

}

handleSearch(event){

    this.searchKey = event.target.value.toLowerCase();

    this.filterVisits();

}

handleStatusChange(event){

    this.selectedStatus = event.detail.value;

    this.filterVisits();

}

filterVisits(){

    this.filteredVisits = this.visits.filter(visit=>{

        const doctor =
            visit.doctorName
            ? visit.doctorName.toLowerCase()
            : '';

        const searchMatch =
            doctor.includes(this.searchKey);

        const statusMatch =
            this.selectedStatus==='All' || visit.Status__c===this.selectedStatus;

        return searchMatch && statusMatch;

    });

}

updatePagination(){

    const start =
        (this.page-1)*this.pageSize;

    const end =
        start+this.pageSize;

    this.filteredVisits =
        this.filteredVisits.slice(start,end);

}

nextPage(){

    if(this.page<this.totalPages){

        this.page++;

        this.filterVisits();

    }

}

previousPage(){

    if(this.page>1){

        this.page--;

        this.filterVisits();

    }

}



}
