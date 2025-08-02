import { LightningElement , track, wire} from 'lwc';
import acccountsList from '@salesforce/apex/wrapLwcActRating.acccountsList';
import acccountsList1 from '@salesforce/apex/wrapLwcActRating.acccountsList2';

export default class ComboBoxToShowAccountRating extends LightningElement {
    @track selectedRating = '';
    @track gotOptions=[];
    /*(You can also use this) @track options=[];
    */  
    @track listOfAccounts=[];
    
    get options(){
        return this.gotOptions;
    }

    connectedCallback(){
        /*
        acccountsList1()
        .then(result =>{
            let arr=[]
            for(var i = 0 ; i<result.length ; i++){
                arr.push({label: result[i].Rating, value: result[i].Rating})    
            }
            this.gotOptions=arr

        }) */
        let arr = [];
        arr.push({label:"Hot", value:"Hot"},
        {label:"Cold", value:"Cold"}, {label:"Warm", value:"Warm"})
        this.gotOptions = arr;
    }

    


    changeHandler(event){
        this.selectedRating= event.target.value; // we can also use event.detail.value


        acccountsList ({str: this.selectedRating})
        .then(res =>{
            this.listOfAccounts=res
        })
        .catch(error=>{
            console.log("Error:",error);
        })
    }


}