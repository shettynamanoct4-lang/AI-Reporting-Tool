import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class NavigatePageRefrence extends NavigationMixin(LightningElement) {
    navigateToList(){
        let pageReference= {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
               filterName: 'Recent'
            }
        };
        this[NavigationMixin.Navigate](pageReference,true);
    }
}