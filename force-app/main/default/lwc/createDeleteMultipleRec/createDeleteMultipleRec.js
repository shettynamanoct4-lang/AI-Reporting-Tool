import { LightningElement, track } from 'lwc';
import crAcc from '@salesforce/apex/multipleRec.crAcc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME from '@salesforce/schema/Account.Name';
import PHONE from '@salesforce/schema/Account.Phone';
import INDUSTRY from '@salesforce/schema/Account.Industry';

export default class CreateDeleteMultipleRec extends LightningElement {
    @track keyIndex=0;
    @track error;
    @track message;
    @track accList=[
        {
            Name:NAME,
            Industry:INDUSTRY,
            Phone:PHONE
        }
    ];
    //Add Row 
    addRow() {
        this.keyIndex+1;   
        this.accList.push ({            
            Name: '',
            Industry: '',
            Phone: ''
        });
        console.log('Enter ',this.accList);
        console.log('Enter ',this.accList);
    }
    changeHandler(event){       
        // alert(event.target.id.split('-'));
         console.log('Access key2:'+event.target.accessKey);
         console.log('id:'+event.target.id);
         console.log('value:'+event.target.value);       
         if(event.target.name==='accName')
             this.accList[event.target.accessKey].Name = event.target.value;
         else if(event.target.name==='accIndustry'){
             this.accList[event.target.accessKey].Industry = event.target.value;
         }
         else if(event.target.name==='accPhone'){
             this.accList[event.target.accessKey].Phone = event.target.value;
         }
     }
     //Save Accounts
     saveMultipleAccounts() {

        console.log("accountlist"+JSON.stringify(this.accList));
        crAcc({ acc : this.accList })
            .then(result => {
                this.message = result;
                this.error = undefined;                
                this.accList.forEach(function(item){                   
                    item.Name='';
                    item.Industry='';
                    item.Phone='';                   
                });

                //this.accList = [];
                if(this.message !== undefined) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Accounts Created!',
                            variant: 'success',
                        }),
                    );
                }
                
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating records',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
     }
     removeRow(event){       
        console.log('Access key2:'+event.target.accessKey);
        console.log(event.target.id.split('-')[0]);
        if(this.accList.length>=1){             
             this.accList.splice(event.target.accessKey,1);
             this.keyIndex-1;
        }
    }  

}