import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import LEAD_SOURCE from '@salesforce/schema/Contact.LeadSource';

export default class CreateAndShowRec extends LightningElement {
    @track ContactId;
    objectName = CONTACT_OBJECT;
    Name = LAST_NAME;
    LeadSource  = LEAD_SOURCE;
    @track display=false;
    handleSuccess(event){
        this.display=true;
        this.ContactId = event.detail.Id;
       // const is = JSON.parse(JSON.stringify(this.ContactId));
       // console.log(JSON.stringify(is));
       console.log(this.ContactId);
        const events = new ShowToastEvent({
            title: 'Successful',
            message: 'Contact Created',
            variant: 'success'
        })
        this.dispatchEvent(events);

        

    }


    

}