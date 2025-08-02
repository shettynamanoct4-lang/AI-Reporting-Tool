import { LightningElement, track } from 'lwc';
import goAc from '@salesforce/apex/ProComboData.goAc'; 
import concom from '@salesforce/apex/ProComboData.concom';

const columns=[
    {
        label: 'Contact Name',
        fieldName : 'Name'
    },
    {
        label: 'Phone Number',
        fieldName: 'Phone'
    }
]
export default class ProjComboData extends LightningElement {
    @track value;
    gotOptions=[];
    isVisible=false;
    @track data=[];
    columns=columns;
    get options(){
        return this.gotOptions;
    }

    connectedCallback(){
        goAc()
        .then(result =>{
            let arr=[]
            for(var i=0; i<result.length; i++){
                arr.push({label:result[i].Name, value: result[i].Id})
            }
            this.gotOptions=arr
        })
    }

    changeHandler(event){
        this.value=event.target.value;
        this.isVisible=true

        concom({recievedAcc : this.value})
        .then(res =>{
            this.data=res
        })
        .catch(error=>{
            console.log("Error:",error);
        })
    }

}