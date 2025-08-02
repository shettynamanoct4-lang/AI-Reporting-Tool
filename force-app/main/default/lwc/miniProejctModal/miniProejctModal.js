import { LightningElement, api, wire} from 'lwc';


import { createRecord } from 'lightning/uiRecordApi';

import PRODUCTS_OBJ from '@salesforce/schema/Product_Order__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MiniProejctModal extends LightningElement {

    
    @api accId
    @api accName

    
    obj1={}

    formFields={}

    changeHandler(event){

        const {name,value}=event.target

        this.obj1[name]=value

    }

    saveRecord(){
        

        let obj2 = {Account__c:this.accId}
        console.log(obj2)

        this.formFields={...this.obj1,...obj2}
        console.log(this.formFields)

        const recordInput={apiName:PRODUCTS_OBJ.objectApiName,fields:this.formFields}

        createRecord(recordInput).then(result=>{
            console.log(result)

           

            this.dispatchEvent(new ShowToastEvent({

                title: 'Success',

                message: 'New Record created',

                variant: 'success'

            }));
            // location.reload()

           

        }).catch(error=>{

            console.error(error);

            this.dispatchEvent(new ShowToastEvent({

                title: 'Failed',

                message: 'Creation of record failed',

                variant: 'error'

            }));

        })

    }

    
    closeModal(){

        this.dispatchEvent(new CustomEvent("close",{

            detail: "Closed Succesfully!!!"

        }))

    }

}