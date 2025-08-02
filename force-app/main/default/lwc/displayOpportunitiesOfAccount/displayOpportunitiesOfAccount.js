import { LightningElement,track,wire,api } from 'lwc';
import getOpptList from '@salesforce/apex/DisplayOppsOfAct.getOppList';

const columns = [
    { label : 'Name', fieldName: 'Name'},
    { label : 'Amount', fieldName: 'Amount'},
    { label : 'Close Date', fieldName: 'CloseDate'}
]

export default class DisplayOpportunitiesOfAccount extends LightningElement {
    
    columns = columns;
    @track data =[];
    @api recordId; //it store the current page record Id
    

    //get related contactlist from apex class
    @wire(getOpptList, {lwcActRecId: '$recordId'})
    wiredFun({data,error}){
        if(data){
            //alert(JSON.stringify(data));
            this.data = data;
            console.log('List of Opp',JSON.stringify(data));
        }
        if(error){
            console.log('error',error);
        }
    }


}