import { LightningElement, wire } from 'lwc';

import getTeamStatistics
    from '@salesforce/apex/ManagerDashboardController.getTeamStatistics';

import getRepresentativePerformance
    from '@salesforce/apex/ManagerDashboardController.getRepresentativePerformance';

import getUpcomingVisits
    from '@salesforce/apex/ManagerDashboardController.getUpcomingVisits';


import hasManagerAccess
    from '@salesforce/customPermission/SalesForceX_AI_Manager_Access';

    




export default class ManagerDashboard extends LightningElement {

    stats = {};

    representatives = [];

    upcomingVisits = [];


    @wire(getTeamStatistics)
    wiredStatistics({ data, error }) {

        if (data) {

            this.stats = data;

        } else if (error) {

            console.error('Dashboard Error', error);

        }

    }

    get isManager() {

    return hasManagerAccess;

}

    @wire(getRepresentativePerformance)
wiredPerformance({ data, error }) {

    if (data) {

        this.representatives = data;

    } else if (error) {

        console.error(
            'Performance Error',
            error
        );

    }

}

@wire(getUpcomingVisits)
wiredUpcomingVisits({ data, error }) {

    if (data) {

        this.upcomingVisits = data.map(visit => {

            return {
                ...visit,

                doctorName:
                    visit.Doctor__r?.Name,

                representativeName:
                    visit.Representative__r?.Name
            };

        });

    } else if (error) {

        console.error(
            'Upcoming Visit Error',
            error
        );

    }

}

representativeColumns = [

    {
        label: 'Representative',
        fieldName: 'representativeName'
    },

    {
        label: 'Total Visits',
        fieldName: 'totalVisits',
        cellAttributes: {
        alignment: 'left'
    }
    },

    {
        label: 'Completed',
        fieldName: 'completedVisits',
        cellAttributes: {
        alignment: 'left'
    }
    },

    {
        label: 'Completion %',
        fieldName: 'completionPercentage',
        cellAttributes: {
        alignment: 'left'
    },
        type: 'number',
        typeAttributes: {
            minimumFractionDigits: 1,
            maximumFractionDigits: 1
    }
    }

];

upcomingVisitColumns = [

    {
        label: 'Visit',
        fieldName: 'Name'
    },

    {
        label: 'Doctor',
        fieldName: 'doctorName'
    },

    {
        label: 'Representative',
        fieldName: 'representativeName'
    },

    {
        label: 'Visit Date',
        fieldName: 'Visit_Date__c',
        type: 'date'
    },

    {
        label: 'Status',
        fieldName: 'Status__c'
    },

    {
        label: 'Priority',
        fieldName: 'Priority__c'
    }

];






    get total() {
        return this.stats.Total || 0;
    }

    get planned() {
        return this.stats.Planned || 0;
    }

    get inProgress() {
        return this.stats['In Progress'] || 0;
    }

    get completed() {
        return this.stats.Completed || 0;
    }

    get missed() {
        return this.stats.Missed || 0;
    }

    get cancelled() {
        return this.stats.Cancelled || 0;
    }

}
