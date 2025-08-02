import { LightningElement, track } from 'lwc';
import postOfcBranchName from '@salesforce/apex/PostalIntegrate.postOfcBranchName';

export default class PostalCodeSearch extends LightningElement {
    searchKey;
    displayPostalBranches = "Show Branches";
    @track postalList=[];
    @track show = false;

    changeHandler(){
        this.show = true;
        postOfcBranchName({branchName :this.searchKey})
        .then(response =>{
            this.postalList = JSON.parse(JSON.stringify(response));
            console.log("List Of Postal Branches:"+JSON.stringify(this.postalList ));
        })
        .catch(error =>{
            console.log("Error Occured:"+error );
        })
       // this.show = false;
    }

    handlerChange(event){
        this.searchKey=event.target.value;
    }



}