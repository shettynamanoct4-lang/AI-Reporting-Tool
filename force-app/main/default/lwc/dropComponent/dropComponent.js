import { LightningElement , track} from 'lwc';
import NAME from '@salesforce/schema/Account.Name';
import INDUSTRY from '@salesforce/schema/Account.Industry';
import TYPE from '@salesforce/schema/Account.Type';

export default class DropComponent extends LightningElement {
    fields = [NAME,INDUSTRY,TYPE];
    @track accountId;
    @track meassage="Drop an Account Here";
    dropElement(event){
        this.accountId= event.dataTransfer.getData("account_id");
        this.meassage='';

    }
    allowDrop(event){
        event.preventDefault();
    }
}