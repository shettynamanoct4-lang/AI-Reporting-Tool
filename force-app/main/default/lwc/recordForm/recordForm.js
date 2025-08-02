import { LightningElement , track} from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import ACCOUNT_ID from '@salesforce/schema/Contact.AccountId';
import NAME from '@salesforce/schema/Contact.Name';
import PHONE from '@salesforce/schema/Contact.Phone';

export default class RecordForm extends LightningElement {
    objectApiName=CONTACT_OBJECT;
    recordId='0035g00000JCSUrAAP';
    @track fields= [ACCOUNT_ID,NAME,PHONE ];
}