import { LightningElement, wire } from 'lwc';

import getTodayVisits from '@salesforce/apex/VisitDashboardController.getTodayVisits';

const columns = [

    {label:'Visit',fieldName:'Name'},

    {label:'Doctor',fieldName:'doctorName'},

    {label:'Status',fieldName:'Status__c'},

    {label:'Priority',fieldName:'Priority__c'}

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

}
