import { LightningElement, track } from 'lwc';
import gAc from '@salesforce/apex/ComboAcc.gAc';

export default class ComboBox extends LightningElement {
    @track value;
    @track gotOptions=[];
    /*(You can also use this) @track options=[];
    */  
    
    get options(){
        return this.gotOptions;
    }

    connectedCallback(){
        gAc()
        .then(result =>{
            let arr=[]
            for(var i = 0 ; i<result.length ; i++){
                arr.push({label: result[i].Name, value: result[i].Id})    
            }
            this.gotOptions=arr

        })
    }

    changeHandler(event){
        this.value= event.detail.value; // we can also use event.target.value
    }
}