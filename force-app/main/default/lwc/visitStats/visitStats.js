import { LightningElement, wire } from 'lwc';

import getVisitStatistics
from '@salesforce/apex/VisitDashboardController.getVisitStatistics';

export default class VisitStats extends LightningElement {

    stats = {};

    @wire(getVisitStatistics)
    wiredStats({ data, error }) {

        if (data) {
            this.stats = data;
        }

        if (error) {
            console.error(error);
        }

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

}
