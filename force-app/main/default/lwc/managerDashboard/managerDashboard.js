import { LightningElement, wire } from 'lwc';

import getTeamStatistics
    from '@salesforce/apex/ManagerDashboardController.getTeamStatistics';

export default class ManagerDashboard extends LightningElement {

    stats = {};

    @wire(getTeamStatistics)
    wiredStatistics({ data, error }) {

        if (data) {

            this.stats = data;

        } else if (error) {

            console.error('Dashboard Error', error);

        }

    }

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
