import { LightningElement, wire } from 'lwc';

import getTodayVisits from '@salesforce/apex/VisitDashboardController.getTodayVisits';

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

    @wire(getTodayVisits)

    wiredVisits({data,error}){

        if(data){

            this.visits=data.map(item=>{

                return{

                    ...item,

                    doctorName:item.Doctor__r?.Name

                }

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

            break;

        case 'checkout':

            break;

        case 'complete':

            break;

    }


}

}
