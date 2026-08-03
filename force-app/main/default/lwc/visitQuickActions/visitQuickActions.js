import { LightningElement } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';

export default class VisitQuickActions extends NavigationMixin(LightningElement) {

    newVisit() {

        this[NavigationMixin.Navigate]({

            type: 'standard__objectPage',

            attributes: {

                objectApiName: 'Visit__c',

                actionName: 'new'

            }

        });

    }

    refreshDashboard() {

        window.location.reload();

    }

}
