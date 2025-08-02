import { LightningElement , track, wire} from 'lwc';
import getAcco from '@salesforce/apex/wireEg.getAcco';
const columns = [
    {
        label: 'Name',
        fieldName : 'Name',
        type:  'text'
    },
    {
        label: 'Account Id',
        fieldName: 'Id',
        type: 'text'

    },
    {
        label: 'Account Number',
        fieldName: 'AccountNumber',
        type: 'number'
    },
];



export default class ImperativeMethod extends LightningElement {
    @track columns=columns;
    @track data;
    data=[];

    connectedCallback(){
        getAcco()
        .then(result => {
            this.data=result;
            console.log(JSON.stringify(JSON.parse(this.data)));
        })
        .catch(error => {
            console.error("Error Occured");
        })
    }
}