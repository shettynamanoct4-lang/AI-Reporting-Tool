import { LightningElement,track } from 'lwc';

export default class C2pCldSwapna extends LightningElement {
    @track name;
    @track phone;
    @track city;

    changeHandler(event){
        let a = event.target.name;
        if('nm' == a){
            this.name = event.target.value; 

        }
        if('phn' == a){
            this.phone = event.target.value; 

        }
        if('cty' == a){
            this.city = event.target.value; 

        }

    }

    childEvntFire(event){
        const myEvent = new CustomEvent('sumitfire', {
            detail: {
                empName : this.name, empPhone : this.phone, empCity : this.city
            }
        })
        this.dispatchEvent(myEvent);
    }


}