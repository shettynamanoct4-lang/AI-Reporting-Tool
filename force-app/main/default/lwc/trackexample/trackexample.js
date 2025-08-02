import { LightningElement, track } from 'lwc';

export default class Trackexample extends LightningElement {
    @track fullName={
        firstName: '',
        lastName: ''
    };

    changeHandler(event){
        let a = event.target.name;
        if(a=='fName'){
            this.fullName.firstName=event.target.value;
        }
        if(a=='lName'){
            this.fullName.lastName=event.target.value;
        }



    }
}